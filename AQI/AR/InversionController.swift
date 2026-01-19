import Foundation
import ARKit
import SceneKit

final class InversionController: NSObject {
    private weak var view: ARSCNView?

    // Derived state
    private var compScale: CGFloat = 1.0
    private var smoothedStability: Double = 0.0

    // Scene nodes
    private let root = SCNNode()
    private let cityNode = SCNNode()
    private let atmosphereNode = SCNNode()
    private let sourcesNode = SCNNode()

    // Particle systems
    private var backgroundHaze: SCNParticleSystem = SCNParticleSystem() // pollution aloft
    private var groundHaze: SCNParticleSystem = SCNParticleSystem()      // pollution near ground
    private var coolAirTracers: SCNParticleSystem = SCNParticleSystem()  // cool layer halo
    private var warmAirTracers: SCNParticleSystem = SCNParticleSystem()  // warm layer halo
    private var coolCoreTracers: SCNParticleSystem = SCNParticleSystem() // cool layer core
    private var warmCoreTracers: SCNParticleSystem = SCNParticleSystem() // warm layer core
    private var sourceEmitters: [SCNNode] = []
    private let planarTurbulenceNode = SCNNode()

    // Physics fields controlling motion
    private let baseTurbulenceNode = SCNNode()
    private let lateralDriftNode = SCNNode()
    private let boundarySlabNode = SCNNode()
    private let boundaryColliderNode = SCNNode()
    private let boundaryDragNode = SCNNode()
    private let coolLayerNode = SCNNode()
    private let warmLayerNode = SCNNode()
    private let boundaryTangentTurbulenceNode = SCNNode()
    private let groundTurbulenceNode = SCNNode()
    private let coolLayerGeomNode = SCNNode()
    private let warmLayerGeomNode = SCNNode()
    private let buoyancyNode = SCNNode()

    // State
    private var placed = false
    private var stability: Double = 0.0 // 0..1
    private var boundaryHeight: CGFloat = 0.18 // meters (tabletop scale)
    private var boundaryThickness: CGFloat = 0.06
    private var lastUpdateTime: TimeInterval = 0
    private var timeAccum: Double = 0

    // Failure moments timer
    private var failureTimer: Timer?

    func attach(to view: ARSCNView) {
        self.view = view
        configureScene(view)
    }

    func update(stability s: Double, lightEstimate: ARLightEstimate?, complexity: Double) {
        stability = max(0.0, min(1.0, s))
        compScale = CGFloat(max(0.5, min(complexity, 1.25)))
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
        buildCity()

        // Position root at plane center (node is already positioned at plane)
        root.position = SCNVector3(plane.center.x, 0, plane.center.z)
        parentNode.addChildNode(root)

        // Apply colliders based on current stability and start failure moments
        applyPollutionCollider(enabled: true, strength: stability)
        scheduleFailureMoments()
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

        buildCity()
        buildAtmosphere()
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
        scheduleFailureMoments()
    }

    func tick(time: TimeInterval) {
        if lastUpdateTime == 0 { lastUpdateTime = time }
        let dt = time - lastUpdateTime
        lastUpdateTime = time
        timeAccum += dt

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

        // Fog-like air layers density (small particles)
        let layerScale = max(0.0, min(1.0, (s - 0.05) / 0.95))
        coolAirTracers.birthRate = CGFloat(240 + 1200 * layerScale) * compScale
        warmAirTracers.birthRate = CGFloat(240 + 1100 * layerScale) * compScale
        coolCoreTracers.birthRate = CGFloat(140 + 900 * layerScale) * compScale
        warmCoreTracers.birthRate = CGFloat(120 + 800 * layerScale) * compScale

        // Pollution mixing: split total emission per source into free vs trapped
        let totalPerSource: CGFloat = 80 * compScale
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

        // Update boundary collider & drag band and planar diffusion
        boundaryColliderNode.position.y = Float(hbEff)
        boundaryDragNode.position.y = Float(hbEff)
        boundaryDragNode.physicsField?.strength = CGFloat(lerp(0.0, 0.5, pow(s, 1.2)))
        boundaryTangentTurbulenceNode.position.y = Float(hbEff)
        boundaryTangentTurbulenceNode.physicsField?.strength = CGFloat(lerp(0.0, 0.25, pow(s, 1.3)))
        planarTurbulenceNode.position.y = Float(max(0.03, hbEff * 0.45))
        planarTurbulenceNode.physicsField?.strength = CGFloat(lerp(0.02, 0.22, pow(s, 1.2)))

        // Always enable barrier; leakage handled by free fraction and drag band
        applyPollutionCollider(enabled: true, strength: s)

        // Align helper nodes (for completeness)
        boundarySlabNode.position.y = Float(boundaryHeight)
        boundarySlabNode.physicsField?.halfExtent = SCNVector3(0.18, Float(boundaryThickness * 0.5), 0.18)
    }

    private func configureScene(_ view: ARSCNView) {
        view.scene = SCNScene()
        view.scene.rootNode.addChildNode(root)
        view.scene.background.contents = nil
        view.rendersContinuously = true

        // Mild ambient light to see particles and city
        let ambient = SCNLight()
        ambient.type = .ambient
        ambient.intensity = 240
        let ambientNode = SCNNode()
        ambientNode.light = ambient
        root.addChildNode(ambientNode)

        // Minimal turbulence for natural variation (non-directional)
        let turb = SCNPhysicsField.turbulenceField(smoothness: 0.6, animationSpeed: 0.2)
        turb.strength = 0.04
        turb.halfExtent = SCNVector3(0.15, 0.1, 0.15)
        turb.usesEllipsoidalExtent = true
        baseTurbulenceNode.physicsField = turb
        baseTurbulenceNode.position = SCNVector3Zero
        root.addChildNode(baseTurbulenceNode)

        // Gentle lateral drift (disabled)
        let linear = SCNPhysicsField.linearGravity()
        linear.direction = SCNVector3(1, 0, 0) // will not rotate with device; ok for miniature
        linear.strength = 0.0
        linear.halfExtent = SCNVector3(0.25, 0.25, 0.25)
        linear.usesEllipsoidalExtent = true
        lateralDriftNode.physicsField = linear
        root.addChildNode(lateralDriftNode)

        // Planar turbulence for horizontal diffusion (no mean wind)
        let planar = SCNPhysicsField.turbulenceField(smoothness: 0.8, animationSpeed: 0.12)
        planar.strength = 0.0
        planar.halfExtent = SCNVector3(0.22, 0.03, 0.22)
        planar.usesEllipsoidalExtent = true
        planarTurbulenceNode.physicsField = planar
        planarTurbulenceNode.position = SCNVector3(0, Float(boundaryHeight * 0.4), 0)
        root.addChildNode(planarTurbulenceNode)

        // Inversion boundary: (a) thin field stub (disabled) and (b) collision plane
        let slab = SCNPhysicsField.linearGravity()
        slab.direction = SCNVector3(0, -1, 0)
        slab.strength = 0.0 // unused — we rely on collider plane
        slab.halfExtent = SCNVector3(0.18, 0.03, 0.18)
        slab.usesEllipsoidalExtent = true
        boundarySlabNode.physicsField = slab
        boundarySlabNode.position = SCNVector3(0, Float(boundaryHeight), 0)
        root.addChildNode(boundarySlabNode)

        // Drag band around the inversion boundary to slow vertical motion progressively
        let drag = SCNPhysicsField.drag()
        drag.strength = 0.0
        drag.halfExtent = SCNVector3(0.18, 0.015, 0.18)
        drag.usesEllipsoidalExtent = true
        boundaryDragNode.physicsField = drag
        boundaryDragNode.position = SCNVector3(0, Float(boundaryHeight), 0)
        root.addChildNode(boundaryDragNode)

        // Tangent turbulence near boundary to encourage sideways sliding along the cap
        let tangentTurb = SCNPhysicsField.turbulenceField(smoothness: 0.75, animationSpeed: 0.15)
        tangentTurb.strength = 0.0
        tangentTurb.halfExtent = SCNVector3(0.22, 0.01, 0.22)
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

        // Gentle upward buoyancy when not inverted
        let buoy = SCNPhysicsField.linearGravity()
        buoy.direction = SCNVector3(0, 1, 0)
        buoy.strength = 0.05
        buoy.halfExtent = SCNVector3(0.2, 0.2, 0.2)
        buoy.usesEllipsoidalExtent = true
        buoyancyNode.physicsField = buoy
        root.addChildNode(buoyancyNode)

        // Subtle near-ground micro-turbulence for pollution (not wind, affects low layer)
        let groundTurb = SCNPhysicsField.turbulenceField(smoothness: 0.8, animationSpeed: 0.12)
        groundTurb.strength = 0.03
        groundTurb.halfExtent = SCNVector3(0.20, 0.03, 0.20)
        groundTurb.usesEllipsoidalExtent = true
        groundTurbulenceNode.physicsField = groundTurb
        groundTurbulenceNode.position = SCNVector3(0, 0.03, 0)
        root.addChildNode(groundTurbulenceNode)
    }

    private func buildCity() {
        cityNode.childNodes.forEach { $0.removeFromParentNode() }
        root.addChildNode(cityNode)

        let baseSize: CGFloat = 0.34 // 34 cm square platform
        let base = SCNBox(width: baseSize, height: 0.01, length: baseSize, chamferRadius: 0.004)
        let baseNode = SCNNode(geometry: base)
        base.firstMaterial?.diffuse.contents = UIColor(white: 0.15, alpha: 1)
        baseNode.position = SCNVector3(0, 0, 0)
        cityNode.addChildNode(baseNode)

        // Simple grid roads
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

        // Buildings: varied heights near center
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

        // Rooftop/road sources for emissions
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
            let n = makeSourceEmitterPair()
            n.position = i
            sourcesNode.addChildNode(n)
            sourceEmitters.append(n)
        }

        // A few rooftop sources
        for _ in 0..<6 {
            let n = makeSourceEmitterPair()
            let x = Float.random(in: -0.12...0.12)
            let z = Float.random(in: -0.12...0.12)
            let y = Float.random(in: 0.03...0.09)
            n.position = SCNVector3(x, y, z)
            sourcesNode.addChildNode(n)
            sourceEmitters.append(n)
        }
    }

    private func buildAtmosphere() {
        atmosphereNode.removeFromParentNode()
        root.addChildNode(atmosphereNode)

        // Broad background haze across volume (neutral pollution)
        backgroundHaze = SCNParticleSystem()
        backgroundHaze.loops = true
        backgroundHaze.birthRate = 0
        backgroundHaze.particleLifeSpan = 8
        backgroundHaze.particleLifeSpanVariation = 2
        backgroundHaze.particleVelocity = 0.02
        backgroundHaze.particleVelocityVariation = 0.015
        backgroundHaze.particleSize = 0.003
        backgroundHaze.particleSizeVariation = 0.001
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
        groundHaze.particleLifeSpan = 10
        groundHaze.particleVelocity = 0.012
        groundHaze.particleVelocityVariation = 0.01
        groundHaze.particleSize = 0.0035
        groundHaze.particleSizeVariation = 0.001
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
        coolAirTracers.particleLifeSpan = 9
        coolAirTracers.particleVelocity = 0.006
        coolAirTracers.particleVelocityVariation = 0.004
        coolAirTracers.particleSize = 0.0012
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
        warmAirTracers.particleLifeSpan = 9
        warmAirTracers.particleVelocity = 0.006
        warmAirTracers.particleVelocityVariation = 0.004
        warmAirTracers.particleSize = 0.0010
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
        coolCoreTracers.particleLifeSpan = 9
        coolCoreTracers.particleVelocity = 0.004
        coolCoreTracers.particleVelocityVariation = 0.003
        coolCoreTracers.particleSize = 0.0009
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
        warmCoreTracers.particleLifeSpan = 9
        warmCoreTracers.particleVelocity = 0.004
        warmCoreTracers.particleVelocityVariation = 0.003
        warmCoreTracers.particleSize = 0.0008
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

    private func makeSourceEmitterPair() -> SCNNode {
        let n = SCNNode()
        let sphere = SCNSphere(radius: 0.01)

        // Trapped system (collides with boundary)
        let trapped = SCNParticleSystem()
        trapped.loops = true
        trapped.birthRate = 0
        trapped.particleLifeSpan = 8
        trapped.particleLifeSpanVariation = 2
        trapped.particleVelocity = 0.02
        trapped.particleVelocityVariation = 0.012
        trapped.emittingDirection = SCNVector3(0, 1, 0)
        trapped.spreadingAngle = 10
        trapped.particleSize = 0.0024
        trapped.particleSizeVariation = 0.001
        trapped.particleColor = UIColor(red: 0.65, green: 0.62, blue: 0.60, alpha: 0.28)
        trapped.particleImage = InversionController.makeDiscImage()
        trapped.isAffectedByPhysicsFields = true
        trapped.emitterShape = sphere
        n.addParticleSystem(trapped)

        // Free system (passes when inversion weak)
        let free = SCNParticleSystem()
        free.loops = true
        free.birthRate = 0
        free.particleLifeSpan = 7
        free.particleLifeSpanVariation = 1.5
        free.particleVelocity = 0.02
        free.particleVelocityVariation = 0.012
        free.emittingDirection = SCNVector3(0, 1, 0)
        free.spreadingAngle = 12
        free.particleSize = 0.0024
        free.particleSizeVariation = 0.001
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
            // Apply collider only to the first system (trapped)
            let trapped = systems[0]
            if enabled {
                trapped.colliderNodes = [boundaryColliderNode]
                trapped.particleDiesOnCollision = false
                trapped.dampingFactor = min(0.9, trapped.dampingFactor + extraDamping)
            } else {
                trapped.colliderNodes = []
                trapped.dampingFactor = max(0.0, trapped.dampingFactor - extraDamping)
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
        cohort.particleLifeSpan = 2.8
        cohort.particleVelocity = 0.042 // stronger rise
        cohort.spreadingAngle = 10
        cohort.emittingDirection = SCNVector3(0, 1, 0)
        cohort.particleSize = 0.0026
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
