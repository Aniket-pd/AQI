import Foundation
import ARKit
import SceneKit

protocol InversionControllerDelegate: AnyObject {
    func inversionControllerDidStartLoadingModel(_ controller: InversionController)
    func inversionControllerIsReadyToPlace(_ controller: InversionController)
    func inversionControllerDidPlace(_ controller: InversionController)
}

final class InversionController: NSObject {
    private weak var view: ARSCNView?
    weak var delegate: InversionControllerDelegate?

    // Derived state
    private var compScale: CGFloat = 1.0 // effective (base * fpsScale)
    private var baseCompScale: CGFloat = 1.0 // from UI complexity target
    private var fpsScale: CGFloat = 1.0 // from measured FPS
    private var smoothedStability: Double = 0.0
    private var modelScale: CGFloat = 1.0 // interactive scale for the whole composition
    var currentModelScale: CGFloat { modelScale }

    // Scene nodes
    private let root = SCNNode()
    private let cityNode = SCNNode()
    private let atmosphereNode = SCNNode()
    private let sourcesNode = SCNNode()
    private let mixingArrowsNode = SCNNode()
    private var sunLightNode: SCNNode?
    private var sunLight: SCNLight?
    private var ambientLight: SCNLight?
    private let skyNode = SCNNode()
    private var sunVisualNode: SCNNode?
    private let sunTargetNode = SCNNode()
    private var sunAzimuth: Float = 0.0
    private var sunAltitude: Float = 0.3
    private var sunBaseDir: SIMD3<Float> = SIMD3<Float>(0, 0, -1)
    private var sunRadius: Float = 2.8

    // Particle systems
    private var backgroundHaze: SCNParticleSystem = SCNParticleSystem() // pollution aloft
    private var groundHaze: SCNParticleSystem = SCNParticleSystem()      // pollution near ground
    private var coolAirTracers: SCNParticleSystem = SCNParticleSystem()  // cool layer halo
    private var warmAirTracers: SCNParticleSystem = SCNParticleSystem()  // warm layer halo
    private var coolCoreTracers: SCNParticleSystem = SCNParticleSystem() // cool layer core
    private var warmCoreTracers: SCNParticleSystem = SCNParticleSystem() // warm layer core
    private var sourceEmitters: [SCNNode] = []
    private let planarTurbulenceNode = SCNNode()
    private let boundaryTangentTurbulenceNode = SCNNode()
    private let groundTurbulenceNode = SCNNode()
    // Additional visual tracer systems (no physics change)
    private var groundRedTracers: SCNParticleSystem = SCNParticleSystem()
    private var groundBlueTracers: SCNParticleSystem = SCNParticleSystem()
    private var coolHaloPatchTracers: [SCNParticleSystem] = []
    private var warmHaloPatchTracers: [SCNParticleSystem] = []
    private var coolHaloPatchNodes: [SCNNode] = []
    private var warmHaloPatchNodes: [SCNNode] = []
    private var coolEdgeTracers: [SCNParticleSystem] = []
    private var warmEdgeTracers: [SCNParticleSystem] = []
    private var coolEdgeNodes: [SCNNode] = []
    private var warmEdgeNodes: [SCNNode] = []
    private var lidShearTracers: SCNParticleSystem = SCNParticleSystem()
    private var lidShearNode: SCNNode = SCNNode()

    // Physics fields controlling motion
    private let baseTurbulenceNode = SCNNode()
    private let lateralDriftNode = SCNNode()
    private let boundarySlabNode = SCNNode()
    private let boundaryColliderNode = SCNNode()
    private let boundaryDragNode = SCNNode()
    private let coolLayerNode = SCNNode()
    private let warmLayerNode = SCNNode()
    // Removed duplicate declarations:
    // private let boundaryTangentTurbulenceNode = SCNNode()
    // private let groundTurbulenceNode = SCNNode()
    private let coolLayerGeomNode = SCNNode()
    private let warmLayerGeomNode = SCNNode()
    private let buoyancyNode = SCNNode()
    // private let groundTurbulenceNode = SCNNode()

    // State
    private var placed = false
    private var stability: Double = 0.0 // 0..1
    private var boundaryHeight: CGFloat = 0.18 // meters (tabletop scale)
    private var boundaryThickness: CGFloat = 0.06
    private var lastUpdateTime: TimeInterval = 0
    private var timeAccum: Double = 0
    private var fpsFrameCount: Int = 0
    private var lastFPSCheckTime: TimeInterval = 0
    private var currentFPS: Double = 60
    private var trappedLoad: Double = 0 // 0..1 gradual fresh->haze mix
    private var mixPulseActive: Bool = false
    private var mixPulseElapsed: Double = 0
    private var mixPulseDuration: Double = 0
    private var nextPulseTimer: Double = 2.0
    private var timeOfDay: Double = 0.15 // 0 = early morning, 1 = afternoon
    private var shapeUpdateAccum: Double = 0

    // Failure moments timer
    private var failureTimer: Timer?

    // Model preload
    private var preparedCityContainer: SCNNode?
    private var modelPreloadAttempted = false

    // Particle scaling: scale sizes of all particle systems under root when modelScale changes
    private var lastParticleScale: CGFloat = 1.0
    private func scaleAllParticleSizes(by factor: CGFloat) {
        guard factor != 1.0 else { return }
        func walk(_ node: SCNNode) {
            if let systems = node.particleSystems, !systems.isEmpty {
                for s in systems { s.particleSize *= factor }
            }
            for child in node.childNodes { walk(child) }
        }
        walk(root)
    }

    func attach(to view: ARSCNView) {
        self.view = view
        configureScene(view)
        // Preload model so UI can show loading/ready state before placement.
        preloadModelIfNeeded()
        // Initialize sun and sky visuals
        setTimeOfDay(timeOfDay)
    }

    private func setSunBaseDirectionFromCurrentCamera() {
        guard let t = view?.session.currentFrame?.camera.transform else { return }
        var fwd = SIMD3<Float>(-t.columns.2.x, -t.columns.2.y, -t.columns.2.z)
        fwd = simd_normalize(fwd)
        let horiz = SIMD3<Float>(fwd.x, 0, fwd.z)
        let mag = simd_length(horiz)
        if mag > 1e-3 { sunBaseDir = simd_normalize(horiz) } else { sunBaseDir = SIMD3<Float>(0, 0, -1) }
    }

    func setTimeOfDay(_ t: Double) {
        timeOfDay = max(0.0, min(1.0, t))
        // Compute solar arc
        // Azimuth sweeps from east (-) to west (+)
        // Subtle forward-hemisphere arc relative to base direction
        let azMin = -Float.pi * 0.3  // ~-17°
        let azMax =  Float.pi * 0.3  // ~+17°
        let az = Float(azMin + (azMax - azMin) * Float(timeOfDay))
        // Altitude follows a dome curve; 5° at morning, 65° midday
        let minAlt: Float = 5.0 * .pi / 180.0
        let maxAlt: Float = 65.0 * .pi / 180.0
        let dome = sin(Float(timeOfDay) * .pi) // 0..1..0, but we clamp afternoon to near-peak
        let alt = minAlt + (maxAlt - minAlt) * max(0, min(1, dome + 0.02))
        sunAzimuth = az
        sunAltitude = alt
        if let _ = sunLightNode, let sun = sunLight {
            // Warm color in morning, neutral by afternoon
            let warm = UIColor(red: 1.0, green: 0.84, blue: 0.68, alpha: 1.0)
            let neutral = UIColor(white: 1.0, alpha: 1.0)
            let u = CGFloat(min(max(timeOfDay, 0), 1))
            let color = blend(colorA: warm, colorB: neutral, t: min(1.0, u * 1.1))
            sun.temperature = 6500 // ensure consistent model; use color via diffuse
            sun.color = color
            // Intensity ramps up with altitude
            let middayBoost = pow(Double(max(0, min(1, dome))), 0.7)
            sun.intensity = CGFloat(400 + 1200 * middayBoost)
            sun.shadowColor = UIColor.black.withAlphaComponent(0.55 - 0.25 * CGFloat(middayBoost))
            // Update light position immediately in world space relative to city
            updateSunWorldTransformFromCity()
        }
        if let ambient = ambientLight {
            let dome = sin(Float(timeOfDay) * .pi)
            let boost = pow(Double(max(0, min(1, dome))), 0.8)
            ambient.intensity = CGFloat(180 + 180 * boost)
        }
    }

    private func updateSunWorldTransformFromCity() {
        let cityPos = root.worldPosition
        let up = SIMD3<Float>(0, 1, 0)
        let b = simd_normalize(SIMD3<Float>(sunBaseDir.x, 0, sunBaseDir.z))
        // Rotate base dir around Y by sunAzimuth
        let cosA = cos(sunAzimuth), sinA = sin(sunAzimuth)
        let rotatedH = SIMD3<Float>(b.x * cosA - b.z * sinA, 0, b.x * sinA + b.z * cosA)
        let dir = simd_normalize(cos(sunAltitude) * rotatedH + sin(sunAltitude) * up)
        let worldPos = SIMD3<Float>(cityPos.x, cityPos.y, cityPos.z) + dir * sunRadius
        let pos = SCNVector3(worldPos.x, max(worldPos.y, cityPos.y + 0.4), worldPos.z)
        sunLightNode?.worldPosition = pos
        sunTargetNode.worldPosition = cityPos
    }

    func update(stability s: Double, lightEstimate: ARLightEstimate?, complexity: Double) {
        stability = max(0.0, min(1.0, s))
        baseCompScale = CGFloat(max(0.5, min(complexity, 1.25)))
        // Particle-based colored air layers (high contrast)
        let coolColor = UIColor(hue: 210.0/360.0, saturation: 0.85, brightness: 1.0, alpha: 0.5)
        let warmColor = UIColor(hue: 0.0/360.0, saturation: 0.90, brightness: 1.0, alpha: 0.5)
        coolAirTracers.particleColor = coolColor
        warmAirTracers.particleColor = warmColor
        coolCoreTracers.particleColor = coolColor.withAlphaComponent(0.7)
        warmCoreTracers.particleColor = warmColor.withAlphaComponent(0.7)
        // Other dynamics are updated per frame in tick() for smooth transitions
    }

    func placeCity(on plane: ARPlaneAnchor, parentNode: SCNNode) {
        guard !placed else { return }
        placed = true
        smoothedStability = stability

        // Build atmosphere and city (order not critical, we apply colliders after)
        buildAtmosphere()
        buildCityUsingPreparedIfAvailable()
        buildMixingArrows()

        // Position root at plane center (node is already positioned at plane)
        root.position = SCNVector3(plane.center.x, 0, plane.center.z)
        parentNode.addChildNode(root)
        // Set sun base from current camera so sun is behind the city initially
        setSunBaseDirectionFromCurrentCamera()
        updateSunWorldTransformFromCity()

        // Apply colliders based on current stability and start failure moments
        applyPollutionCollider(enabled: true, strength: stability)
        scheduleFailureMoments()
        delegate?.inversionControllerDidPlace(self)
    }

    func placeAtCameraStartIfNeeded(_ view: ARSCNView) {
        guard !placed, let frame = view.session.currentFrame else { return }
        placeAt(transform: frame.camera.transform, forwardOffset: 0.5, verticalOffset: -0.05, in: view)
    }

    func placeAt(transform: simd_float4x4) {
        guard let view = view, !placed else { return }
        placeAt(transform: transform, forwardOffset: 0.0, verticalOffset: 0.0, in: view)
    }

    private func placeAt(transform: simd_float4x4, forwardOffset: Float, verticalOffset: Float, in view: ARSCNView) {
        guard !placed else { return }
        placed = true
        smoothedStability = stability

        buildCityUsingPreparedIfAvailable()
        buildAtmosphere()
        buildMixingArrows()
        // Compute a position in front of camera if requested
        var t = transform
        var position = SIMD3<Float>(t.columns.3.x, t.columns.3.y, t.columns.3.z)
        if forwardOffset != 0 {
            let forward = SIMD3<Float>(-t.columns.2.x, -t.columns.2.y, -t.columns.2.z)
            position += normalize(forward) * forwardOffset
        }
        position.y += verticalOffset
        root.position = SCNVector3(position.x, position.y, position.z)
        view.scene.rootNode.addChildNode(root)
        setSunBaseDirectionFromCurrentCamera()
        updateSunWorldTransformFromCity()
        scheduleFailureMoments()
        delegate?.inversionControllerDidPlace(self)
    }

    func tick(time: TimeInterval) {
        if lastUpdateTime == 0 { lastUpdateTime = time }
        let dt = time - lastUpdateTime
        lastUpdateTime = time
        timeAccum += dt
        // Keep sun anchored in world space relative to the city
        updateSunWorldTransformFromCity()

        // Measure FPS and derive a performance scale (0.7..1.0)
        fpsFrameCount += 1
        if lastFPSCheckTime == 0 { lastFPSCheckTime = time }
        let fpsWindow = time - lastFPSCheckTime
        if fpsWindow >= 1.0 {
            currentFPS = Double(fpsFrameCount) / fpsWindow
            fpsFrameCount = 0
            lastFPSCheckTime = time
            let raw = currentFPS / 60.0
            fpsScale = CGFloat(max(min(raw, 1.0), 0.7))
        }

        // Smooth the stability for continuous transitions
        let tau: Double = 0.6
        let alpha = 1.0 - exp(-max(dt, 0.0) / tau)
        smoothedStability += alpha * (stability - smoothedStability)
        let s = smoothedStability

        // Derive parameters
        var baseHB = CGFloat(lerp(0.12, 0.32, s))
        let wobbleAmp: CGFloat = 0.004
        let wobble = wobbleAmp * CGFloat(sin(timeAccum * 2 * .pi * 0.05)) // ~0.05 Hz
        let hbEff = max(0.08, baseHB + wobble)
        boundaryHeight = hbEff
        boundaryThickness = CGFloat(lerp(0.09, 0.03, s))

        // Update fields
        baseTurbulenceNode.physicsField?.strength = CGFloat(lerp(0.06, 0.03, s))
        buoyancyNode.physicsField?.strength = CGFloat(lerp(0.05, 0.0, s))

        // Effective complexity: UI target scaled by FPS
        compScale = max(0.4, min(1.5, baseCompScale * fpsScale))

        // Fog-like air layers density (small particles)
        let layerScale = max(0.0, min(1.0, (s - 0.05) / 0.95))
        coolAirTracers.birthRate = CGFloat(140 + 700 * layerScale) * compScale
        warmAirTracers.birthRate = CGFloat(130 + 650 * layerScale) * compScale
        coolCoreTracers.birthRate = CGFloat(90 + 500 * layerScale) * compScale
        warmCoreTracers.birthRate = CGFloat(80 + 450 * layerScale) * compScale

        // Cushion zone thickness near cap and proximity-scaled behavior (field half-extents)
        let t = CGFloat(lerp(0.01, 0.03, pow(s, 0.8)))
        if let dragField = boundaryDragNode.physicsField {
            let sF = Float(modelScale)
            dragField.halfExtent = SCNVector3(0.18 * sF, Float(max(0.006, t * 0.5)) * sF, 0.18 * sF)
            dragField.strength = CGFloat(lerp(0.0, 0.5, pow(s, 1.2)))
        }
        if let tanField = boundaryTangentTurbulenceNode.physicsField {
            let sF = Float(modelScale)
            tanField.halfExtent = SCNVector3(0.22 * sF, Float(max(0.004, t * 0.33)) * sF, 0.22 * sF)
            tanField.strength = CGFloat(lerp(0.0, 0.25, pow(s, 1.3)))
        }

        // Pollution mixing: split total emission per source into free vs trapped
        let totalPerSource: CGFloat = 55 * compScale
        let trappedFrac = CGFloat(smoothstep(edge0: 0.25, edge1: 0.85, x: s))
        let freeFrac = max(0.0, 1.0 - trappedFrac)
        let trappedBR = totalPerSource * trappedFrac
        let freeBR = totalPerSource * freeFrac
        for node in sourceEmitters {
            guard let systems = node.particleSystems, systems.count > 0 else { continue }
            if systems.count == 1 { systems[0].birthRate = totalPerSource; continue }
            systems[0].birthRate = trappedBR
            systems[0].particleLifeSpan = CGFloat(lerp(7, 22, s))
            if systems.count > 1 {
                systems[1].birthRate = freeBR
                systems[1].particleLifeSpan = 7
            }
            // Wider horizontal diffusion for trapped as inversion strengthens
            systems[0].spreadingAngle = CGFloat(lerp(10, 35, s))
        }

        // Update layer emitter shapes (halo + core) with wobble
        shapeUpdateAccum += dt
        if shapeUpdateAccum >= 0.05 { // throttle shape/geometry updates to ~20 Hz
            if let coolShape = coolAirTracers.emitterShape as? SCNBox {
                coolShape.height = max(0.04, hbEff)
                coolLayerNode.position.y = Float(coolShape.height/2)
            }
            if let coolCoreShape = coolCoreTracers.emitterShape as? SCNBox {
                coolCoreShape.height = max(0.02, hbEff * 0.45)
            }
            if let warmShape = warmAirTracers.emitterShape as? SCNBox {
                let top: CGFloat = 0.22
                let height = max(0.03, top - hbEff)
                warmShape.height = height
                warmLayerNode.position.y = Float(hbEff + height/2)
            }
            if let warmCoreShape = warmCoreTracers.emitterShape as? SCNBox {
                let top: CGFloat = 0.22
                let height = max(0.015, (top - hbEff) * 0.4)
                warmCoreShape.height = height
            }
            shapeUpdateAccum = 0
        }

        // Lid shear band just below lid (visual shear layer)
        lidShearNode.position.y = Float(max(0.02, hbEff - 0.012))

        // Subtle vertical waviness for halo/edge patch nodes to avoid perfectly flat bands
        let waveAmp: Float = 0.003
        let waveFreq: Double = 0.07
        for (i, n) in coolHaloPatchNodes.enumerated() {
            if let box = coolHaloPatchTracers[safe: i]?.emitterShape as? SCNBox {
                let baseY = Float(box.height/2)
                let phase = Float(Double(i) * 1.7)
                n.position.y = baseY + waveAmp * sin(Float(timeAccum * waveFreq) + phase)
            }
        }
        for (i, n) in warmHaloPatchNodes.enumerated() {
            if let box = warmHaloPatchTracers[safe: i]?.emitterShape as? SCNBox {
                let baseY = Float(hbEff + box.height/2)
                let phase = Float(Double(i) * 1.9)
                n.position.y = baseY + waveAmp * sin(Float(timeAccum * waveFreq) + phase)
            }
        }
        for (i, n) in coolEdgeNodes.enumerated() {
            if let box = coolEdgeTracers[safe: i]?.emitterShape as? SCNBox {
                let baseY = Float(box.height/2)
                let phase = Float(Double(i) * 2.1)
                n.position.y = baseY + waveAmp * sin(Float(timeAccum * waveFreq) + phase)
            }
        }
        for (i, n) in warmEdgeNodes.enumerated() {
            if let box = warmEdgeTracers[safe: i]?.emitterShape as? SCNBox {
                let baseY = Float(hbEff + box.height/2)
                let phase = Float(Double(i) * 2.3)
                n.position.y = baseY + waveAmp * sin(Float(timeAccum * waveFreq) + phase)
            }
        }

        // Update boundary collider & bands and planar diffusion
        boundaryColliderNode.position.y = Float(hbEff)
        boundaryDragNode.position.y = Float(hbEff)
        boundaryTangentTurbulenceNode.position.y = Float(hbEff)
        planarTurbulenceNode.position.y = Float(max(0.03, hbEff * 0.45))
        // Horizontal diffusion in trapped layer grows with inversion and accumulated trapped load
        let planarBase: Double = 0.02
        let planarWithS: Double = planarBase + 0.18 * pow(s, 1.2)
        let planarWithLoad: Double = planarWithS + 0.14 * trappedLoad
        planarTurbulenceNode.physicsField?.strength = CGFloat(min(0.35, planarWithLoad))

        // Intermittent micro-mixing pulses under weak inversion
        var pulseEnv: Double = 0
        if s < 0.45 {
            nextPulseTimer -= dt
            if nextPulseTimer <= 0 && !mixPulseActive {
                mixPulseActive = true
                mixPulseElapsed = 0
                mixPulseDuration = Double.random(in: 0.5...1.2)
                nextPulseTimer = Double.random(in: 2.0...4.0)
            }
            if mixPulseActive {
                mixPulseElapsed += dt
                let u = min(max(mixPulseElapsed / max(0.2, mixPulseDuration), 0), 1)
                // Smooth envelope 0..1..0
                pulseEnv = 0.5 * (1 - cos(.pi * u))
                if mixPulseElapsed >= mixPulseDuration { mixPulseActive = false }
            }
        } else {
            mixPulseActive = false
            nextPulseTimer = min(nextPulseTimer, 2.0)
        }

        // Pollution mixing: per-source free vs trapped with pulse modulation
        let totalPerSource2: CGFloat = 55 * compScale
        let trappedFracBase = smoothstep(edge0: 0.25, edge1: 0.85, x: s)
        let trappedFracEff = max(0.0, min(1.0, trappedFracBase - 0.12 * pulseEnv))

        // Update trappedLoad (fresh->haze) slowly over time
        let gain = 0.16 * s
        let loss = 0.12 * (1 - s) + 0.06 * pulseEnv
        trappedLoad = min(max(trappedLoad + dt * (gain - loss), 0.0), 1.0)

        for node in sourceEmitters {
            guard let systems = node.particleSystems, systems.count >= 3 else { continue }
            let trappedTotal = totalPerSource2 * CGFloat(trappedFracEff)
            let freshRate = trappedTotal * CGFloat(1 - trappedLoad)
            let hazeRate = trappedTotal * CGFloat(trappedLoad)
            let freeRate = totalPerSource2 - trappedTotal
            systems[0].birthRate = freshRate
            systems[1].birthRate = hazeRate
            systems[2].birthRate = freeRate
            // Haze longer lifetime and wider spread as inversion strengthens
            systems[1].particleLifeSpan = CGFloat(lerp(9, 16, s))
            systems[1].spreadingAngle = CGFloat(lerp(18, 40, s))
            systems[1].dampingFactor = CGFloat(lerp(0.08, 0.18, s))
            // Broaden trapped haze emitter for fog-like sheet (thin, wide)
            if let box = systems[1].emitterShape as? SCNBox {
                let w = min(0.34, max(0.06, 0.08 + 0.22 * s))
                box.width = w
                box.length = w
                box.height = max(0.004, 0.01 * (1.0 - CGFloat(s)))
            }
            // Slightly reduce drag during pulse to hint near-escape
            // (implemented by boundaryDrag strength above)
            // Free gets a tiny upward boost during pulse
            systems[2].particleVelocity = CGFloat(0.02 + 0.004 * pulseEnv)
        }

        // Always enable barrier; leakage handled by free fraction and cushion band
        applyPollutionCollider(enabled: true, strength: s)

        // Morning fog and trapped haze lifting with sun
        let fogMorning = 1.0 - smoothstep(edge0: 0.15, edge1: 0.7, x: timeOfDay)
        let fogEff = max(0.0, min(1.0, 0.5 * fogMorning + 0.5 * s))
        backgroundHaze.birthRate = CGFloat(70.0 * fogEff) * compScale
        groundHaze.birthRate = CGFloat(140.0 * fogEff) * compScale

        // Teaching cues: arrows fade as stability increases; base plate tint shifts subtly
        let arrowOpacity = CGFloat(1.0 - smoothstep(edge0: 0.08, edge1: 0.5, x: s))
        mixingArrowsNode.opacity = arrowOpacity
        if let basePlate = cityNode.childNode(withName: "basePlate", recursively: false),
           let mat = basePlate.geometry?.firstMaterial {
            let warm = UIColor(red: 0.28, green: 0.25, blue: 0.22, alpha: 1)
            let cool = UIColor(red: 0.18, green: 0.2, blue: 0.24, alpha: 1)
            let mix = CGFloat(smoothstep(edge0: 0.12, edge1: 0.28, x: s))
            mat.diffuse.contents = blend(colorA: warm, colorB: cool, t: mix)
        }

        // Align helper nodes (for completeness)
        boundarySlabNode.position.y = Float(boundaryHeight)
        if let slabField = boundarySlabNode.physicsField {
            let sF = Float(modelScale)
            slabField.halfExtent = SCNVector3(0.18 * sF, Float(boundaryThickness * 0.5) * sF, 0.18 * sF)
        }
    }

    // MARK: - Model preload and building
    private func preloadModelIfNeeded() {
        guard !modelPreloadAttempted else { return }
        modelPreloadAttempted = true
        delegate?.inversionControllerDidStartLoadingModel(self)

        // Try to synchronously load a USDZ; if unavailable, we are ready (procedural fallback).
        let modelName = "Tiny_City (1)"
        var modelURL: URL?
        if let url = Bundle.main.url(forResource: modelName, withExtension: "usdz", subdirectory: "AR/Assets") {
            modelURL = url
        } else if let url = Bundle.main.url(forResource: modelName, withExtension: "usdz") {
            modelURL = url
        }
        if let url = modelURL, let scene = try? SCNScene(url: url, options: nil) {
            let container = SCNNode()
            container.name = "cityModel"
            for child in scene.rootNode.childNodes { container.addChildNode(child) }

            var minVec = SCNVector3Zero
            var maxVec = SCNVector3Zero
            if container.__getBoundingBoxMin(&minVec, max: &maxVec) {
                let sizeX = CGFloat(maxVec.x - minVec.x)
                let sizeZ = CGFloat(maxVec.z - minVec.z)
                let maxSpan = max(sizeX, sizeZ)
                let targetSpan: CGFloat = 0.34
                if maxSpan > 0.0001 { let s = Float(targetSpan / maxSpan); container.scale = SCNVector3(s, s, s) }
                let centerX = (minVec.x + maxVec.x) * 0.5
                let centerZ = (minVec.z + maxVec.z) * 0.5
                let scaledMinY = Float(minVec.y) * container.scale.y
                container.position = SCNVector3(-centerX * container.scale.x,
                                                -scaledMinY + 0.006,
                                                -centerZ * container.scale.z)
            }
            preparedCityContainer = container
        }
        delegate?.inversionControllerIsReadyToPlace(self)
    }

    private func buildCityUsingPreparedIfAvailable() {
        cityNode.childNodes.forEach { $0.removeFromParentNode() }
        root.addChildNode(cityNode)
        if let prepared = preparedCityContainer {
            // Base plate under model
            let baseSize: CGFloat = 0.34
            let base = SCNBox(width: baseSize, height: 0.01, length: baseSize, chamferRadius: 0.004)
            let baseNode = SCNNode(geometry: base)
            base.firstMaterial = SCNMaterial()
            base.firstMaterial?.diffuse.contents = UIColor(white: 0.15, alpha: 1)
            base.firstMaterial?.lightingModel = .lambert
            baseNode.name = "basePlate"
            baseNode.position = SCNVector3(0, 0, 0)
            cityNode.addChildNode(baseNode)

            cityNode.addChildNode(prepared)
            buildSources()
        } else {
            buildCity()
        }
    }

    // MARK: - Interactive transforms
    func setModelScale(_ scale: CGFloat) {
        let s = max(0.5, min(2.5, scale))
        let prev = modelScale
        modelScale = s
        if lastParticleScale != 0 {
            let factor = (s / max(0.0001, lastParticleScale))
            scaleAllParticleSizes(by: factor)
        }
        lastParticleScale = s
        root.scale = SCNVector3(Float(s), Float(s), Float(s))
    }
    func rotateModel(by radians: CGFloat) {
        root.eulerAngles.y += Float(radians)
    }

    private func configureScene(_ view: ARSCNView) {
        view.scene = SCNScene()
        view.scene.rootNode.addChildNode(root)
        view.scene.background.contents = nil
        view.rendersContinuously = true

        // Sky container and sun target live at scene root (world-anchored)
        view.scene.rootNode.addChildNode(skyNode)
        view.scene.rootNode.addChildNode(sunTargetNode)

        // Mild ambient light to see particles and city
        let ambient = SCNLight()
        ambient.type = .ambient
        ambient.intensity = 240
        let ambientNode = SCNNode()
        ambientNode.light = ambient
        self.ambientLight = ambient
        root.addChildNode(ambientNode)

        // Directional sun light with soft shadows for grounding
        let sun = SCNLight()
        sun.type = .directional
        sun.intensity = 650
        sun.castsShadow = true
        sun.shadowMode = .deferred
        sun.shadowSampleCount = 4
        sun.shadowRadius = 3
        sun.shadowBias = 8
        sun.shadowColor = UIColor.black.withAlphaComponent(0.45)
        let sunNode = SCNNode()
        sunNode.light = sun
        sunNode.position = SCNVector3(0, 0.3, 0)
        self.sunLightNode = sunNode
        self.sunLight = sun
        // Aim sun toward root with constraint so orientation updates as we move the sun
        let look = SCNLookAtConstraint(target: sunTargetNode)
        look.isGimbalLockEnabled = true
        sunNode.constraints = [look]
        view.scene.rootNode.addChildNode(sunNode)

        // Visible sun disc removed per request (keep directional light/shadows)

        // Minimal turbulence for natural variation (non-directional)
        let turb = SCNPhysicsField.turbulenceField(smoothness: 0.6, animationSpeed: 0.2)
        turb.strength = 0.04
        do { let sF = Float(modelScale); turb.halfExtent = SCNVector3(0.15 * sF, 0.1 * sF, 0.15 * sF) }
        turb.usesEllipsoidalExtent = true
        baseTurbulenceNode.physicsField = turb
        baseTurbulenceNode.position = SCNVector3Zero
        root.addChildNode(baseTurbulenceNode)

        // Gentle lateral drift (disabled)
        let linear = SCNPhysicsField.linearGravity()
        linear.direction = SCNVector3(1, 0, 0) // will not rotate with device; ok for miniature
        linear.strength = 0.0
        do { let sF = Float(modelScale); linear.halfExtent = SCNVector3(0.25 * sF, 0.25 * sF, 0.25 * sF) }
        linear.usesEllipsoidalExtent = true
        lateralDriftNode.physicsField = linear
        root.addChildNode(lateralDriftNode)

        // Planar turbulence for horizontal diffusion (no mean wind)
        let planar = SCNPhysicsField.turbulenceField(smoothness: 0.8, animationSpeed: 0.12)
        planar.strength = 0.0
        do { let sF = Float(modelScale); planar.halfExtent = SCNVector3(0.22 * sF, 0.03 * sF, 0.22 * sF) }
        planar.usesEllipsoidalExtent = true
        planarTurbulenceNode.physicsField = planar
        planarTurbulenceNode.position = SCNVector3(0, Float(boundaryHeight * 0.4), 0)
        root.addChildNode(planarTurbulenceNode)

        // Inversion boundary: (a) thin field stub (disabled) and (b) collision plane
        let slab = SCNPhysicsField.linearGravity()
        slab.direction = SCNVector3(0, -1, 0)
        slab.strength = 0.0 // unused — we rely on collider plane
        do { let sF = Float(modelScale); slab.halfExtent = SCNVector3(0.18 * sF, 0.03 * sF, 0.18 * sF) }
        slab.usesEllipsoidalExtent = true
        boundarySlabNode.physicsField = slab
        boundarySlabNode.position = SCNVector3(0, Float(boundaryHeight), 0)
        root.addChildNode(boundarySlabNode)

        // Drag band around the inversion boundary to slow vertical motion progressively
        let drag = SCNPhysicsField.drag()
        drag.strength = 0.0
        do { let sF = Float(modelScale); drag.halfExtent = SCNVector3(0.18 * sF, 0.015 * sF, 0.18 * sF) }
        drag.usesEllipsoidalExtent = true
        boundaryDragNode.physicsField = drag
        boundaryDragNode.position = SCNVector3(0, Float(boundaryHeight), 0)
        root.addChildNode(boundaryDragNode)

        // Tangent turbulence near boundary to encourage sideways sliding along the cap
        let tangentTurb = SCNPhysicsField.turbulenceField(smoothness: 0.75, animationSpeed: 0.15)
        tangentTurb.strength = 0.0
        do { let sF = Float(modelScale); tangentTurb.halfExtent = SCNVector3(0.22 * sF, 0.01 * sF, 0.22 * sF) }
        tangentTurb.usesEllipsoidalExtent = true
        boundaryTangentTurbulenceNode.physicsField = tangentTurb
        boundaryTangentTurbulenceNode.position = SCNVector3(0, Float(boundaryHeight), 0)
        root.addChildNode(boundaryTangentTurbulenceNode)

        // Collision plane to block upward crossing when inversion is active
        let planeGeom = SCNBox(width: 0.34, height: 0.002, length: 0.34, chamferRadius: 0)
        let mat = SCNMaterial()
        mat.diffuse.contents = UIColor.clear
        mat.isDoubleSided = true
        mat.writesToDepthBuffer = false
        planeGeom.materials = [mat]
        boundaryColliderNode.geometry = planeGeom
        boundaryColliderNode.position = SCNVector3(0, Float(boundaryHeight), 0)
        boundaryColliderNode.physicsBody = SCNPhysicsBody.static()
        root.addChildNode(boundaryColliderNode)

        // Base plate already receives shadows; no separate shadow-only plane

        // Gentle upward buoyancy when not inverted
        let buoy = SCNPhysicsField.linearGravity()
        buoy.direction = SCNVector3(0, 1, 0)
        buoy.strength = 0.05
        do { let sF = Float(modelScale); buoy.halfExtent = SCNVector3(0.2 * sF, 0.2 * sF, 0.2 * sF) }
        buoy.usesEllipsoidalExtent = true
        buoyancyNode.physicsField = buoy
        root.addChildNode(buoyancyNode)

        // Subtle near-ground micro-turbulence for pollution (not wind, affects low layer)
        let groundTurb = SCNPhysicsField.turbulenceField(smoothness: 0.8, animationSpeed: 0.12)
        groundTurb.strength = 0.03
        do { let sF = Float(modelScale); groundTurb.halfExtent = SCNVector3(0.20 * sF, 0.03 * sF, 0.20 * sF) }
        groundTurb.usesEllipsoidalExtent = true
        groundTurbulenceNode.physicsField = groundTurb
        groundTurbulenceNode.position = SCNVector3(0, 0.03, 0)
        root.addChildNode(groundTurbulenceNode)
    }

    private func buildCity() {
        cityNode.childNodes.forEach { $0.removeFromParentNode() }
        root.addChildNode(cityNode)

        // Try to load a real USDZ city model from the app bundle.
        // Looks under "AR/Assets" first, then at bundle root.
        let modelName = "Tiny_City (1)"
        var modelURL: URL?
        if let url = Bundle.main.url(forResource: modelName, withExtension: "usdz", subdirectory: "AR/Assets") {
            modelURL = url
        } else if let url = Bundle.main.url(forResource: modelName, withExtension: "usdz") {
            modelURL = url
        }

        if let url = modelURL, let scene = try? SCNScene(url: url, options: nil) {
            // Wrap model under a container so we can scale and center it.
            let container = SCNNode()
            container.name = "cityModel"
            for child in scene.rootNode.childNodes {
                container.addChildNode(child)
            }

            // Compute bounds and normalize: sit on ground (y=0) and fit within ~34 cm square.
            var minVec = SCNVector3Zero
            var maxVec = SCNVector3Zero
            if container.__getBoundingBoxMin(&minVec, max: &maxVec) {
                let sizeX = CGFloat(maxVec.x - minVec.x)
                let sizeZ = CGFloat(maxVec.z - minVec.z)
                let maxSpan = max(sizeX, sizeZ)
                let targetSpan: CGFloat = 0.34 // match original base size
                if maxSpan > 0.0001 {
                    let s = Float(targetSpan / maxSpan)
                    container.scale = SCNVector3(s, s, s)
                }
                // After scaling, compute center and min to align: center at origin, base on ground
                let centerX = (minVec.x + maxVec.x) * 0.5
                let centerZ = (minVec.z + maxVec.z) * 0.5
                let scaledMinY = Float(minVec.y) * container.scale.y
                container.position = SCNVector3(-centerX * container.scale.x,
                                                -scaledMinY + 0.006,
                                                -centerZ * container.scale.z)
            }

            // Add a base plate under the model to preserve tinting behavior and visual reference
            let baseSize: CGFloat = 0.34
            let base = SCNBox(width: baseSize, height: 0.01, length: baseSize, chamferRadius: 0.004)
            let baseNode = SCNNode(geometry: base)
            base.firstMaterial = SCNMaterial()
            base.firstMaterial?.diffuse.contents = UIColor(white: 0.15, alpha: 1)
            base.firstMaterial?.lightingModel = .lambert
            baseNode.name = "basePlate"
            baseNode.position = SCNVector3(0, 0, 0)
            cityNode.addChildNode(baseNode)

            cityNode.addChildNode(container)

            // Build pollution sources relative to the model footprint
            buildSources()
            return
        }

        // Fallback: build the original procedural city if USDZ missing
        let baseSize: CGFloat = 0.34 // 34 cm square platform
        let base = SCNBox(width: baseSize, height: 0.01, length: baseSize, chamferRadius: 0.004)
        let baseNode = SCNNode(geometry: base)
        base.firstMaterial = SCNMaterial()
        base.firstMaterial?.diffuse.contents = UIColor(white: 0.15, alpha: 1)
        base.firstMaterial?.lightingModel = .lambert
        baseNode.name = "basePlate"
        baseNode.position = SCNVector3(0, 0, 0)
        cityNode.addChildNode(baseNode)

        func addRoad(x: CGFloat, z: CGFloat, w: CGFloat, l: CGFloat) {
            let g = SCNBox(width: w, height: 0.002, length: l, chamferRadius: 0)
            g.firstMaterial?.diffuse.contents = UIColor(white: 0.12, alpha: 1)
            let n = SCNNode(geometry: g)
            n.position = SCNVector3(x, 0.006, z)
            cityNode.addChildNode(n)
        }
        let grid: [CGFloat] = [-0.12, 0.0, 0.12]
        for x in grid { addRoad(x: x, z: 0, w: 0.02, l: baseSize*0.94) }
        for z in grid { addRoad(x: 0, z: z, w: baseSize*0.94, l: 0.02) }

        func addBuilding(x: CGFloat, z: CGFloat, w: CGFloat, d: CGFloat, h: CGFloat) {
            let b = SCNBox(width: w, height: h, length: d, chamferRadius: 0.002)
            let m = SCNMaterial()
            m.diffuse.contents = UIColor(white: CGFloat.random(in: 0.3...0.6), alpha: 1)
            b.materials = [m]
            let n = SCNNode(geometry: b)
            n.position = SCNVector3(x, h/2 + 0.006, z)
            cityNode.addChildNode(n)
        }
        let positions: [SCNVector3] = [
            SCNVector3(-0.1, 0, -0.1), SCNVector3(0.0, 0, -0.1), SCNVector3(0.1, 0, -0.1),
            SCNVector3(-0.1, 0,  0.0), SCNVector3(0.0, 0,  0.0), SCNVector3(0.1, 0,  0.0),
            SCNVector3(-0.1, 0,  0.1), SCNVector3(0.0, 0,  0.1), SCNVector3(0.1, 0,  0.1)
        ]
        for p in positions.shuffled() {
            let w = CGFloat.random(in: 0.02...0.04)
            let d = CGFloat.random(in: 0.02...0.05)
            let h = CGFloat.random(in: 0.025...0.09)
            addBuilding(x: CGFloat(p.x), z: CGFloat(p.z), w: w, d: d, h: h)
        }

        buildSources()
    }

    private func buildSources() {
        sourcesNode.removeFromParentNode()
        sourcesNode.childNodes.forEach { $0.removeFromParentNode() }
        cityNode.addChildNode(sourcesNode)
        sourceEmitters.removeAll()

        // Select a handful of emitter positions: intersections + some rooftops
        let intersections: [SCNVector3] = [
            SCNVector3(-0.12, 0.012, -0.12), SCNVector3(0.0, 0.012, -0.12), SCNVector3(0.12, 0.012, -0.12),
            SCNVector3(-0.12, 0.012,  0.0),  SCNVector3(0.0, 0.012,  0.0),  SCNVector3(0.12, 0.012,  0.0),
            SCNVector3(-0.12, 0.012,  0.12), SCNVector3(0.0, 0.012,  0.12), SCNVector3(0.12, 0.012,  0.12)
        ]
        for i in intersections {
            let n = makeSourceEmitterTriple()
            n.position = i
            sourcesNode.addChildNode(n)
            sourceEmitters.append(n)
        }

        // A few rooftop sources
        for _ in 0..<6 {
            let n = makeSourceEmitterTriple()
            let x = Float.random(in: -0.12...0.12)
            let z = Float.random(in: -0.12...0.12)
            let y = Float.random(in: 0.03...0.09)
            n.position = SCNVector3(x, y, z)
            sourcesNode.addChildNode(n)
            sourceEmitters.append(n)
        }
    }

    // Upward mixing arrows for normal atmosphere teaching
    private func buildMixingArrows() {
        mixingArrowsNode.removeFromParentNode()
        mixingArrowsNode.childNodes.forEach { $0.removeFromParentNode() }
        root.addChildNode(mixingArrowsNode)

        let positions: [SCNVector3] = [
            SCNVector3(-0.12, 0.015, -0.12), SCNVector3(0.0, 0.015, -0.12), SCNVector3(0.12, 0.015, -0.12),
            SCNVector3(-0.12, 0.015,  0.0),  SCNVector3(0.0, 0.015,  0.0),  SCNVector3(0.12, 0.015,  0.0),
            SCNVector3(-0.12, 0.015,  0.12), SCNVector3(0.0, 0.015,  0.12), SCNVector3(0.12, 0.015,  0.12)
        ]
        for p in positions {
            let shaft = SCNCylinder(radius: 0.001, height: 0.014)
            let head = SCNCone(topRadius: 0.0, bottomRadius: 0.003, height: 0.006)
            let m = SCNMaterial()
            m.diffuse.contents = UIColor(white: 1.0, alpha: 0.6)
            m.lightingModel = .constant
            shaft.materials = [m]
            head.materials = [m]

            let shaftNode = SCNNode(geometry: shaft)
            shaftNode.position = SCNVector3(p.x, p.y + 0.007, p.z)
            let headNode = SCNNode(geometry: head)
            headNode.position = SCNVector3(p.x, p.y + 0.016, p.z)
            mixingArrowsNode.addChildNode(shaftNode)
            mixingArrowsNode.addChildNode(headNode)

            // Gentle up-down oscillation
            let moveUp = SCNAction.moveBy(x: 0, y: 0.004, z: 0, duration: 1.4)
            let moveDown = SCNAction.moveBy(x: 0, y: -0.004, z: 0, duration: 1.4)
            moveUp.timingMode = .easeInEaseOut
            moveDown.timingMode = .easeInEaseOut
            let seq = SCNAction.sequence([moveUp, moveDown])
            shaftNode.runAction(SCNAction.repeatForever(seq))
            headNode.runAction(SCNAction.repeatForever(seq))
        }
        mixingArrowsNode.opacity = 0
    }

    private func buildAtmosphere() {
        atmosphereNode.removeFromParentNode()
        root.addChildNode(atmosphereNode)
        root.addChildNode(mixingArrowsNode)

        // Broad background haze across volume (neutral pollution)
        backgroundHaze = SCNParticleSystem()
        backgroundHaze.loops = true
        backgroundHaze.birthRate = 0
        backgroundHaze.particleLifeSpan = 6.5
        backgroundHaze.particleLifeSpanVariation = 2
        backgroundHaze.particleVelocity = 0.02
        backgroundHaze.particleVelocityVariation = 0.015
        backgroundHaze.particleSize = 0.0016
        backgroundHaze.particleSizeVariation = 0.0006
        backgroundHaze.particleColor = UIColor(red: 0.78, green: 0.74, blue: 0.70, alpha: 0.22)
        backgroundHaze.particleImage = InversionController.makeDiscImage()
        backgroundHaze.isAffectedByPhysicsFields = true
        let bgNode = SCNNode()
        let box = SCNBox(width: 0.34, height: 0.22, length: 0.34, chamferRadius: 0)
        backgroundHaze.emitterShape = box
        bgNode.addParticleSystem(backgroundHaze)
        atmosphereNode.addChildNode(bgNode)

        // Ground-layer haze to settle between buildings (neutral pollution)
        groundHaze = SCNParticleSystem()
        groundHaze.loops = true
        groundHaze.birthRate = 0
        groundHaze.particleLifeSpan = 7.8
        groundHaze.particleVelocity = 0.012
        groundHaze.particleVelocityVariation = 0.01
        groundHaze.particleSize = 0.0018
        groundHaze.particleSizeVariation = 0.0006
        groundHaze.dampingFactor = 0.06
        groundHaze.particleColor = UIColor(red: 0.78, green: 0.74, blue: 0.70, alpha: 0.28)
        groundHaze.particleImage = InversionController.makeDiscImage()
        groundHaze.isAffectedByPhysicsFields = true
        let ghNode = SCNNode()
        let shallow = SCNBox(width: 0.34, height: 0.06, length: 0.34, chamferRadius: 0)
        groundHaze.emitterShape = shallow
        ghNode.addParticleSystem(groundHaze)
        ghNode.position.y = 0.03
        atmosphereNode.addChildNode(ghNode)

        // Cool air tracers (below boundary)
        coolAirTracers = SCNParticleSystem()
        coolAirTracers.loops = true
        coolAirTracers.birthRate = 0
        coolAirTracers.particleLifeSpan = 7.5
        coolAirTracers.particleVelocity = 0.006
        coolAirTracers.particleVelocityVariation = 0.004
        coolAirTracers.particleSize = 0.0007
        coolAirTracers.particleImage = InversionController.makeDiscImage()
        coolAirTracers.dampingFactor = 0.1
        coolAirTracers.isAffectedByPhysicsFields = true
        let coolShape = SCNBox(width: 0.34, height: boundaryHeight, length: 0.34, chamferRadius: 0)
        coolAirTracers.emitterShape = coolShape
        coolLayerNode.removeFromParentNode()
        coolLayerNode.addParticleSystem(coolAirTracers)
        coolLayerNode.position.y = Float(coolShape.height/2)
        atmosphereNode.addChildNode(coolLayerNode)

        // Warm air tracers (above boundary)
        warmAirTracers = SCNParticleSystem()
        warmAirTracers.loops = true
        warmAirTracers.birthRate = 0
        warmAirTracers.particleLifeSpan = 7.5
        warmAirTracers.particleVelocity = 0.006
        warmAirTracers.particleVelocityVariation = 0.004
        warmAirTracers.particleSize = 0.0006
        warmAirTracers.particleImage = InversionController.makeDiscImage()
        warmAirTracers.emittingDirection = SCNVector3(0, 1, 0)
        warmAirTracers.dampingFactor = 0.1
        warmAirTracers.isAffectedByPhysicsFields = true
        let top: CGFloat = 0.22
        let warmHeight = max(0.03, top - boundaryHeight)
        let warmShape = SCNBox(width: 0.34, height: warmHeight, length: 0.34, chamferRadius: 0)
        warmAirTracers.emitterShape = warmShape
        warmLayerNode.removeFromParentNode()
        warmLayerNode.addParticleSystem(warmAirTracers)
        warmLayerNode.position.y = Float(boundaryHeight + warmHeight/2)
        atmosphereNode.addChildNode(warmLayerNode)

        // Add denser core sheets for each layer (thin height)
        coolCoreTracers = SCNParticleSystem()
        coolCoreTracers.loops = true
        coolCoreTracers.birthRate = 0
        coolCoreTracers.particleLifeSpan = 7.2
        coolCoreTracers.particleVelocity = 0.004
        coolCoreTracers.particleVelocityVariation = 0.003
        coolCoreTracers.particleSize = 0.0005
        coolCoreTracers.particleImage = InversionController.makeDiscImage()
        coolCoreTracers.dampingFactor = 0.14
        coolCoreTracers.isAffectedByPhysicsFields = true
        let coolCoreShape = SCNBox(width: 0.34, height: max(0.02, boundaryHeight * 0.45), length: 0.34, chamferRadius: 0)
        coolCoreTracers.emitterShape = coolCoreShape
        let coolCoreNode = SCNNode()
        coolCoreNode.addParticleSystem(coolCoreTracers)
        coolCoreNode.position.y = Float(coolCoreShape.height/2)
        atmosphereNode.addChildNode(coolCoreNode)

        warmCoreTracers = SCNParticleSystem()
        warmCoreTracers.loops = true
        warmCoreTracers.birthRate = 0
        warmCoreTracers.particleLifeSpan = 7.2
        warmCoreTracers.particleVelocity = 0.004
        warmCoreTracers.particleVelocityVariation = 0.003
        warmCoreTracers.particleSize = 0.00045
        warmCoreTracers.particleImage = InversionController.makeDiscImage()
        warmCoreTracers.dampingFactor = 0.14
        warmCoreTracers.isAffectedByPhysicsFields = true
        let warmCoreShape = SCNBox(width: 0.34, height: max(0.015, warmHeight * 0.4), length: 0.34, chamferRadius: 0)
        warmCoreTracers.emitterShape = warmCoreShape
        let warmCoreNode = SCNNode()
        warmCoreNode.addParticleSystem(warmCoreTracers)
        warmCoreNode.position.y = Float(boundaryHeight + warmCoreShape.height/2)
        atmosphereNode.addChildNode(warmCoreNode)

        // Color is carried by particles, no extra slabs
    }

    private func makeSourceEmitterTriple() -> SCNNode {
        let n = SCNNode()
        let sphere = SCNSphere(radius: 0.01)

        // Trapped fresh
        let trappedFresh = SCNParticleSystem()
        trappedFresh.loops = true
        trappedFresh.birthRate = 0
        trappedFresh.particleLifeSpan = 6.0
        trappedFresh.particleLifeSpanVariation = 1.5
        trappedFresh.particleVelocity = 0.02
        trappedFresh.particleVelocityVariation = 0.012
        trappedFresh.emittingDirection = SCNVector3(0, 1, 0)
        trappedFresh.spreadingAngle = 10
        trappedFresh.particleSize = 0.0011
        trappedFresh.particleSizeVariation = 0.0005
        trappedFresh.particleColor = UIColor(red: 0.68, green: 0.66, blue: 0.64, alpha: 0.30)
        trappedFresh.particleImage = InversionController.makeDiscImage()
        trappedFresh.isAffectedByPhysicsFields = true
        trappedFresh.emitterShape = sphere
        n.addParticleSystem(trappedFresh)

        // Trapped haze (sheet-like)
        let trappedHaze = SCNParticleSystem()
        trappedHaze.loops = true
        trappedHaze.birthRate = 0
        trappedHaze.particleLifeSpan = 8.0
        trappedHaze.particleLifeSpanVariation = 2
        trappedHaze.particleVelocity = 0.015
        trappedHaze.particleVelocityVariation = 0.010
        trappedHaze.emittingDirection = SCNVector3(0, 1, 0)
        trappedHaze.spreadingAngle = 18
        trappedHaze.particleSize = 0.0013
        trappedHaze.particleSizeVariation = 0.0006
        trappedHaze.particleColor = UIColor(red: 0.62, green: 0.60, blue: 0.58, alpha: 0.28)
        trappedHaze.particleImage = InversionController.makeDiscImage()
        trappedHaze.isAffectedByPhysicsFields = true
        trappedHaze.emitterShape = SCNBox(width: 0.08, height: 0.01, length: 0.08, chamferRadius: 0)
        n.addParticleSystem(trappedHaze)

        // Free system (passes when inversion weak)
        let free = SCNParticleSystem()
        free.loops = true
        free.birthRate = 0
        free.particleLifeSpan = 6.0
        free.particleLifeSpanVariation = 1.5
        free.particleVelocity = 0.02
        free.particleVelocityVariation = 0.012
        free.emittingDirection = SCNVector3(0, 1, 0)
        free.spreadingAngle = 12
        free.particleSize = 0.0011
        free.particleSizeVariation = 0.0005
        free.particleColor = UIColor(red: 0.65, green: 0.62, blue: 0.60, alpha: 0.26)
        free.particleImage = InversionController.makeDiscImage()
        free.isAffectedByPhysicsFields = true
        free.emitterShape = sphere
        n.addParticleSystem(free)

        return n
    }

    private func scheduleFailureMoments() {
        failureTimer?.invalidate()
        failureTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { [weak self] _ in
            self?.triggerFailureMomentIfNeeded()
        })
    }

    private func applyPollutionCollider(enabled: Bool, strength: Double) {
        let friction = CGFloat(lerp(0.05, 0.5, min(max(strength, 0.0), 1.0)))
        let extraDamping: CGFloat = enabled ? friction * 0.6 : 0.0
        for node in sourceEmitters {
            guard let systems = node.particleSystems, systems.count > 0 else { continue }
            // Apply collider to trappedFresh (0) and trappedHaze (1)
            for idx in 0..<(min(2, systems.count)) {
                let s = systems[idx]
                if enabled {
                    s.colliderNodes = [boundaryColliderNode]
                    s.particleDiesOnCollision = false
                    s.dampingFactor = min(0.9, s.dampingFactor + extraDamping)
                } else {
                    s.colliderNodes = []
                    s.dampingFactor = max(0.0, s.dampingFactor - extraDamping)
                }
            }
        }
    }

    private func triggerFailureMomentIfNeeded() {
        guard placed else { return }
        // Only during weak inversion range
        if stability < 0.3 || stability > 0.55 { return }

        // Rare, irregular events
        if Double.random(in: 0...1) > 0.35 { return }

        // Pick a random source emitter
        guard let emitter = sourceEmitters.randomElement(), let view = view else { return }

        // Create a short-lived upward-biased cohort
        let cohort = SCNParticleSystem()
        cohort.loops = false
        cohort.birthRate = CGFloat(Int.random(in: 20...36))
        cohort.particleLifeSpan = 2.2
        cohort.particleVelocity = 0.042 // stronger rise
        cohort.spreadingAngle = 10
        cohort.emittingDirection = SCNVector3(0, 1, 0)
        cohort.particleSize = 0.0012
        cohort.particleImage = InversionController.makeDiscImage()
        cohort.particleColor = UIColor(red: 0.78, green: 0.74, blue: 0.70, alpha: 0.36)
        cohort.isAffectedByPhysicsFields = true
        if stability > 0.2 {
            cohort.colliderNodes = [boundaryColliderNode]
            cohort.particleDiesOnCollision = false
            cohort.dampingFactor = 0.2
        }

        let node = SCNNode()
        let shape = SCNSphere(radius: 0.012)
        cohort.emitterShape = shape
        node.addParticleSystem(cohort)
        node.position = emitter.convertPosition(SCNVector3Zero, to: view.scene.rootNode)

        view.scene.rootNode.addChildNode(node)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
            node.removeFromParentNode()
        }
    }
}

// MARK: - Utils
private func lerp(_ a: Double, _ b: Double, _ t: Double) -> Double { a + (b - a) * t }
private func smoothstep(edge0: Double, edge1: Double, x: Double) -> Double {
    let t = min(max((x - edge0) / max(1e-6, (edge1 - edge0)), 0.0), 1.0)
    return t * t * (3 - 2 * t)
}
private func blend(colorA: UIColor, colorB: UIColor, t: CGFloat) -> UIColor {
    var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
    var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
    colorA.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
    colorB.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
    let u = max(0, min(1, t))
    return UIColor(red: r1 + (r2 - r1) * u,
                   green: g1 + (g2 - g1) * u,
                   blue: b1 + (b2 - b1) * u,
                   alpha: a1 + (a2 - a1) * u)
}

extension InversionController {
    static func makeDiscImage(diameter: CGFloat = 16, softness: CGFloat = 1.8) -> UIImage {
        let size = CGSize(width: diameter, height: diameter)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            let center = CGPoint(x: size.width/2, y: size.height/2)
            let radius = diameter/2
            for r in stride(from: radius, through: 0, by: -1) {
                let alpha = max(0, 1 - (radius - r) / (softness))
                UIColor(white: 1, alpha: alpha*alpha*0.9).setFill()
                let rect = CGRect(x: center.x - r, y: center.y - r, width: r*2, height: r*2)
                ctx.cgContext.fillEllipse(in: rect)
            }
        }
    }
    static func makeVerticalGradient(size: CGSize, top: UIColor, bottom: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            let colors = [top.cgColor, bottom.cgColor] as CFArray
            let locations: [CGFloat] = [0.0, 1.0]
            let space = CGColorSpaceCreateDeviceRGB()
            if let grad = CGGradient(colorsSpace: space, colors: colors, locations: locations) {
                ctx.cgContext.drawLinearGradient(grad, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: size.height), options: [])
            }
        }
    }
}

// MARK: - Layer geometry helpers
private extension InversionController {
    func buildLayerGeometry() {
        let width: CGFloat = 0.34
        let length: CGFloat = 0.34
        // Cool layer slab
        let coolBox = SCNBox(width: width, height: max(0.04, boundaryHeight), length: length, chamferRadius: 0)
        let coolMat = SCNMaterial()
        let coolTop = UIColor(hue: 210/360.0, saturation: 0.35, brightness: 1.0, alpha: 0.08)
        let coolBottom = UIColor(hue: 210/360.0, saturation: 0.35, brightness: 1.0, alpha: 0.02)
        coolMat.diffuse.contents = InversionController.makeVerticalGradient(size: CGSize(width: 32, height: 64), top: coolBottom, bottom: coolTop)
        coolMat.lightingModel = .constant
        coolMat.isDoubleSided = true
        coolMat.writesToDepthBuffer = false
        coolMat.blendMode = .alpha
        coolBox.firstMaterial = coolMat
        coolLayerGeomNode.geometry = coolBox
        coolLayerGeomNode.position = SCNVector3(0, Float(coolBox.height/2), 0)
        atmosphereNode.addChildNode(coolLayerGeomNode)

        // Warm layer slab
        let top: CGFloat = 0.22
        let warmHeight = max(0.03, top - boundaryHeight)
        let warmBox = SCNBox(width: width, height: warmHeight, length: length, chamferRadius: 0)
        let warmMat = SCNMaterial()
        let warmTopC = UIColor(hue: 28/360.0, saturation: 0.45, brightness: 1.0, alpha: 0.06)
        let warmBottomC = UIColor(hue: 28/360.0, saturation: 0.45, brightness: 1.0, alpha: 0.10)
        warmMat.diffuse.contents = InversionController.makeVerticalGradient(size: CGSize(width: 32, height: 64), top: warmBottomC, bottom: warmTopC)
        warmMat.lightingModel = .constant
        warmMat.isDoubleSided = true
        warmMat.writesToDepthBuffer = false
        warmMat.blendMode = .alpha
        warmBox.firstMaterial = warmMat
        warmLayerGeomNode.geometry = warmBox
        warmLayerGeomNode.position = SCNVector3(0, Float(boundaryHeight + warmBox.height/2), 0)
        atmosphereNode.addChildNode(warmLayerGeomNode)
    }

    func updateLayerGeometry() {
        if let coolBox = coolLayerGeomNode.geometry as? SCNBox {
            coolBox.height = max(0.04, boundaryHeight)
            coolLayerGeomNode.position.y = Float(coolBox.height/2)
        }
        if let warmBox = warmLayerGeomNode.geometry as? SCNBox {
            let top: CGFloat = 0.22
            let h = max(0.03, top - boundaryHeight)
            warmBox.height = h
            warmLayerGeomNode.position.y = Float(boundaryHeight + h/2)
        }
    }
}
// Safe subscript helper for arrays
private extension Array {
    subscript(safe index: Int) -> Element? {
        (0..<count).contains(index) ? self[index] : nil
    }
}
