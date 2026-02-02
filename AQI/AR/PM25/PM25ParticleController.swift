import Foundation
import ARKit
import SceneKit

final class PM25ParticleController: NSObject {
    private(set) weak var sceneView: ARSCNView?
    private var emitterNode = SCNNode()
    private var floorEmitterNode = SCNNode()
    private var turbulenceNode = SCNNode()
    private var breathFieldNode: SCNNode?
    private var clusterTimer: Timer?

    private var particleSystem: SCNParticleSystem = SCNParticleSystem()
    private var floorParticleSystem: SCNParticleSystem = SCNParticleSystem()

    private var lastFPSCheckTime: TimeInterval = 0
    private var frameCount: Int = 0
    private var currentFPS: Double = 60

    // Mapping parameters
    private var baseBirthRate: CGFloat = 3000
    private var baseVelocity: CGFloat = 0.06
    private var baseSize: CGFloat = 0.003
    private var pm25Value: Double = 12
    private var complexityScale: Double = 1.0

    func attach(to view: ARSCNView) {
        self.sceneView = view
        configureScene(view: view)
        buildEmitters(in: view)
        scheduleClusters()
    }

    func detach() {
        clusterTimer?.invalidate()
        clusterTimer = nil
    }

    // MARK: - Setup
    private func configureScene(view: ARSCNView) {
        view.scene = SCNScene()
        view.rendersContinuously = false
        view.antialiasingMode = .multisampling2X
        view.automaticallyUpdatesLighting = true
        // Use ARKit camera feed for background (don't override scene background)
        view.scene.background.contents = nil
        view.backgroundColor = .clear

        // Subtle ambient light to keep particles visible in dark scenes
        let light = SCNLight()
        light.type = .ambient
        light.intensity = 150
        let lightNode = SCNNode()
        lightNode.light = light
        view.scene.rootNode.addChildNode(lightNode)
    }

    private func buildEmitters(in view: ARSCNView) {
        // Main volumetric emitter around the starting position
        particleSystem = makeParticleSystem(volume: CGSize(width: 6, height: 3), depth: 6)
        emitterNode = SCNNode()
        let boxShape = SCNBox(width: 6, height: 3, length: 6, chamferRadius: 0)
        // Do not assign geometry to node; only use as emitter shape so nothing opaque renders
        particleSystem.emitterShape = boxShape
        emitterNode.addParticleSystem(particleSystem)

        // Slightly denser near floor (subtle)
        floorParticleSystem = makeParticleSystem(volume: CGSize(width: 6, height: 0.6), depth: 6)
        floorEmitterNode = SCNNode()
        let floorShape = SCNBox(width: 6, height: 0.6, length: 6, chamferRadius: 0)
        floorParticleSystem.emitterShape = floorShape
        floorEmitterNode.addParticleSystem(floorParticleSystem)
        floorEmitterNode.position.y = -0.8
        floorParticleSystem.birthRate *= 1.25

        // Turbulence field for life-like motion (low strength, animated)
        let turbulence = SCNPhysicsField.turbulenceField(smoothness: 0.5, animationSpeed: 0.3)
        turbulence.strength = 0.4
        turbulence.falloffExponent = 0
        turbulence.halfExtent = SCNVector3(3, 1.5, 3)
        turbulence.usesEllipsoidalExtent = true
        turbulenceNode = SCNNode()
        turbulenceNode.physicsField = turbulence

        view.scene.rootNode.addChildNode(emitterNode)
        view.scene.rootNode.addChildNode(floorEmitterNode)
        view.scene.rootNode.addChildNode(turbulenceNode)
    }

    private func makeParticleSystem(volume: CGSize, depth: CGFloat) -> SCNParticleSystem {
        let p = SCNParticleSystem()
        p.loops = true
        p.birthRate = baseBirthRate
        p.particleLifeSpan = 10
        p.particleLifeSpanVariation = 2
        p.emittingDirection = SCNVector3(0, 1, 0)
        p.spreadingAngle = 30
        p.particleVelocity = baseVelocity
        p.particleVelocityVariation = 0.04
        p.particleSize = baseSize
        p.particleSizeVariation = 0.002
        p.blendMode = .alpha
        p.isAffectedByGravity = false
        p.particleColor = UIColor(white: 0.92, alpha: 0.35)
        p.particleColorVariation = SCNVector4(0.02, 0.02, 0.02, 0.1)
        p.dampingFactor = 0.02
        p.isBlackPassEnabled = false
        p.particleImage = UIImage(systemName: "circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        p.isAffectedByPhysicsFields = true
        return p
    }

    // MARK: - Updates
    func updatePM25(value: Double, lightEstimate: ARLightEstimate?, complexityScale: Double) {
        self.pm25Value = value
        self.complexityScale = complexityScale

        // Map PM2.5 to density, speed, size, slight color warmth
        let clamped = min(max(value, 0), 300)
        let t = CGFloat(clamped / 300.0) // 0..1

        // Adaptive birth rate with complexity and FPS guard
        let fpsScale = CGFloat(max(min(currentFPS / 60.0, 1.0), 0.6))
        let complexity = CGFloat(max(0.5, min(complexityScale, 1.5)))

        let birth = CGFloat(800 + 9200 * t) * fpsScale * complexity
        let vel = CGFloat(0.04 + 0.22 * t)
        let size = CGFloat(0.002 + 0.003 * t)

        [particleSystem, floorParticleSystem].forEach { p in
            p.birthRate = birth
            p.particleVelocity = vel
            p.particleSize = size
        }

        // Color: slightly warmer/darker as PM increases
        let baseWhite: CGFloat = 0.94 - 0.18 * t
        let warm = CGFloat(1.0 - 0.1 * t)
        let color = UIColor(red: baseWhite, green: min(baseWhite, warm), blue: warm, alpha: 0.36 + 0.12 * t)
        particleSystem.particleColor = color
        floorParticleSystem.particleColor = color.withAlphaComponent(color.cgColor.alpha * 1.05)

        // Light estimation influences brightness subtly
        if let le = lightEstimate {
            let intensity = CGFloat(min(max(le.ambientIntensity / 1000.0, 0.5), 1.2))
            let adjusted = color.withAlphaComponent(min(max(color.cgColor.alpha * intensity, 0.2), 0.7))
            particleSystem.particleColor = adjusted
            floorParticleSystem.particleColor = adjusted
        }

        // Heavier clustering at higher PM: increase damping a bit
        let damp = CGFloat(0.01 + 0.1 * t)
        particleSystem.dampingFactor = damp
        floorParticleSystem.dampingFactor = damp
    }

    func placeAtCameraStart(_ view: ARSCNView) {
        guard let frame = view.session.currentFrame else { return }
        let cam = frame.camera
        let transform = SCNMatrix4(cam.transform)
        emitterNode.transform = transform
        floorEmitterNode.transform = transform
        floorEmitterNode.position.y -= 0.8
        turbulenceNode.transform = transform
    }

    func updatePerFrame(time: TimeInterval) {
        frameCount += 1
        if lastFPSCheckTime == 0 { lastFPSCheckTime = time }
        let dt = time - lastFPSCheckTime
        if dt >= 1.0 {
            currentFPS = Double(frameCount) / dt
            frameCount = 0
            lastFPSCheckTime = time
        }
    }

    // MARK: - Interactions
    func handleTap(at point: CGPoint) {
        guard let view = sceneView else { return }
        let world = worldPosition(from: point, in: view)
        makePulseField(at: world, strength: 6.0, duration: 0.25)
    }

    func handleDrag(at point: CGPoint) {
        guard let view = sceneView else { return }
        let world = worldPosition(from: point, in: view)
        makePulseField(at: world, strength: 2.5, duration: 0.35)
    }

    func setBreath(active: Bool) {
        guard let view = sceneView else { return }
        if active {
            if breathFieldNode == nil {
                let linear = SCNPhysicsField.linearGravity()
                linear.direction = view.cameraForward
                linear.strength = 1.2
                linear.halfExtent = SCNVector3(0.5, 0.5, 1.2)
                linear.usesEllipsoidalExtent = true
                let node = SCNNode()
                node.physicsField = linear
                node.position = view.cameraPosition + view.cameraForward * 0.15
                view.scene.rootNode.addChildNode(node)
                breathFieldNode = node
            }
        } else {
            breathFieldNode?.removeFromParentNode()
            breathFieldNode = nil
        }
    }

    private func makePulseField(at position: SCNVector3, strength: CGFloat, duration: TimeInterval) {
        guard let view = sceneView else { return }
        let field = SCNPhysicsField.radialGravity()
        field.strength = -strength // negative to repel
        field.falloffExponent = 2
        field.minimumDistance = 0.01
        let node = SCNNode()
        node.physicsField = field
        node.position = position
        view.scene.rootNode.addChildNode(node)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            node.removeFromParentNode()
        }
    }

    private func worldPosition(from point: CGPoint, in view: ARSCNView) -> SCNVector3 {
        // Try hit-test against feature points
        if let result = view.hitTest(point, types: [.featurePoint, .estimatedHorizontalPlane]).first {
            let pos = result.worldTransform.columns.3
            return SCNVector3(pos.x, pos.y, pos.z)
        }
        // Fallback: 0.5m in front of camera
        return view.cameraPosition + view.cameraForward * 0.5
    }

    // MARK: - Micro-events: drifting clusters
    private func scheduleClusters() {
        clusterTimer?.invalidate()
        clusterTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.spawnCluster()
        }
    }

    private func spawnCluster() {
        guard let view = sceneView else { return }
        // Probability increases with PM
        let p = min(max(pm25Value / 150.0, 0.05), 0.9)
        if Double.random(in: 0...1) > p { return }

        let s = SCNParticleSystem()
        s.loops = false
        s.birthRate = CGFloat(600 + 1200 * p) * CGFloat(complexityScale)
        s.particleLifeSpan = 3.5
        s.particleVelocity = 0.05
        s.particleSize = 0.004
        s.particleColor = (particleSystem.particleColor ?? UIColor.white).withAlphaComponent(0.5)
        s.spreadingAngle = 12
        s.particleImage = UIImage(systemName: "circle.fill")
        s.isAffectedByPhysicsFields = true

        let node = SCNNode()
        let sphere = SCNSphere(radius: 0.12)
        // Use sphere only as emitter shape; do not render geometry
        s.emitterShape = sphere
        node.addParticleSystem(s)

        // Place ahead and drift sideways a bit
        node.position = view.cameraPosition + view.cameraForward * Float.random(in: 0.6...1.2)
        node.position.x += Float.random(in: -0.4...0.4)
        node.position.y += Float.random(in: -0.2...0.2)

        // Add a gentle directional field to move the cluster
        let linear = SCNPhysicsField.linearGravity()
        let sideways = view.cameraRight * Float.random(in: -0.2...0.2)
        linear.direction = (view.cameraForward * 0.8 + sideways).normalized
        linear.strength = 0.3
        let linearNode = SCNNode()
        linearNode.physicsField = linear
        linearNode.position = node.position

        view.scene.rootNode.addChildNode(node)
        view.scene.rootNode.addChildNode(linearNode)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.7) {
            node.removeFromParentNode()
            linearNode.removeFromParentNode()
        }
    }
}

// MARK: - ARSCNView helpers
extension ARSCNView {
    var cameraTransform: simd_float4x4? { session.currentFrame?.camera.transform }

    var cameraPosition: SCNVector3 {
        guard let t = cameraTransform else { return SCNVector3Zero }
        return SCNVector3(t.columns.3.x, t.columns.3.y, t.columns.3.z)
    }

    var cameraForward: SCNVector3 {
        guard let t = cameraTransform else { return SCNVector3(0, 0, -1) }
        let forward = SCNVector3(-t.columns.2.x, -t.columns.2.y, -t.columns.2.z)
        return forward.normalized
    }

    var cameraRight: SCNVector3 {
        guard let t = cameraTransform else { return SCNVector3(1, 0, 0) }
        return SCNVector3(t.columns.0.x, t.columns.0.y, t.columns.0.z).normalized
    }
}

// MARK: - Vectors
extension SCNVector3 {
    static func +(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 { SCNVector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z) }
    static func -(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 { SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z) }
    static func *(lhs: SCNVector3, rhs: Float) -> SCNVector3 { SCNVector3(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs) }
    static func *(lhs: SCNVector3, rhs: CGFloat) -> SCNVector3 { SCNVector3(lhs.x * Float(rhs), lhs.y * Float(rhs), lhs.z * Float(rhs)) }
    static func *(lhs: SCNVector3, rhs: Double) -> SCNVector3 { SCNVector3(lhs.x * Float(rhs), lhs.y * Float(rhs), lhs.z * Float(rhs)) }
    static func *(lhs: Float, rhs: SCNVector3) -> SCNVector3 { rhs * lhs }
    static func *(lhs: CGFloat, rhs: SCNVector3) -> SCNVector3 { rhs * lhs }
    static func *(lhs: Double, rhs: SCNVector3) -> SCNVector3 { rhs * lhs }
    var length: Float { sqrtf(x*x + y*y + z*z) }
    var normalized: SCNVector3 { let len = max(length, 0.0001); return SCNVector3(x/len, y/len, z/len) }
}
