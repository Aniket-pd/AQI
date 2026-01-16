import SwiftUI
import ARKit
import RealityKit
import Combine

struct InversionARContainer: UIViewRepresentable {
    @ObservedObject var sim: InversionSimulation

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.automaticallyConfigureSession = false
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        config.environmentTexturing = .automatic
        arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])

        // Plane anchor to place content when a plane is found
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: [0.4, 0.4]))
        arView.scene.addAnchor(anchor)

        // Build air layers and particle pool
        let system = InversionARSystem(sim: sim)
        context.coordinator.system = system
        system.setup(in: anchor)

        context.coordinator.cancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
            system.update(dt: Float(event.deltaTime))
        }

        // Coaching overlay for plane detection
        let coaching = ARCoachingOverlayView()
        coaching.session = arView.session
        coaching.activatesAutomatically = true
        coaching.goal = .horizontalPlane
        coaching.frame = arView.bounds
        coaching.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        arView.addSubview(coaching)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // No-op: Avoid mutating @Published state from view updates.
        // RealityKit's per-frame update pulls current values from `sim`.
    }

    final class Coordinator {
        let parent: InversionARContainer
        var system: InversionARSystem?
        var cancellable: Cancellable?
        init(_ parent: InversionARContainer) { self.parent = parent }
        deinit { cancellable?.cancel() }
    }
}

final class InversionARSystem {
    private let sim: InversionSimulation
    private var anchor: AnchorEntity?

    // Air layers
    private var coolLayer: ModelEntity!
    private var capLayer: ModelEntity!

    // Particle visuals (pooled tiny quads)
    private var particleMesh: MeshResource!
    private var particleMaterial: UnlitMaterial!
    private var particleEntities: [ModelEntity] = []

    // Values are read directly from `sim` during update.

    init(sim: InversionSimulation) { self.sim = sim }

    func setup(in anchor: AnchorEntity) {
        self.anchor = anchor
        buildAirLayers(into: anchor)
        buildParticles(into: anchor)
    }

    private func buildAirLayers(into anchor: AnchorEntity) {
        let size: Float = sim.domainHalfSize * 2

        // Cool near-surface layer
        coolLayer = ModelEntity(mesh: .generatePlane(width: size, depth: size), materials: [UnlitMaterial(color: .init(white: 0.6, alpha: 0.12))])
        coolLayer.transform.translation = [0, 0.05, 0]
        coolLayer.orientation = simd_quatf(angle: -.pi/2, axis: [1,0,0])
        anchor.addChild(coolLayer)

        // Warm inversion cap
        capLayer = ModelEntity(mesh: .generatePlane(width: size, depth: size), materials: [UnlitMaterial(color: .init(red: 1.0, green: 0.6, blue: 0.2, alpha: 0.12))])
        capLayer.transform.translation = [0, sim.capHeight, 0]
        capLayer.orientation = simd_quatf(angle: -.pi/2, axis: [1,0,0])
        anchor.addChild(capLayer)
    }

    private func buildParticles(into anchor: AnchorEntity) {
        particleMesh = .generatePlane(width: 0.008, depth: 0.008)
        particleMaterial = UnlitMaterial(color: .init(white: 0.95, alpha: 0.35))
        particleEntities = (0..<sim.particles.count).map { _ in
            let m = ModelEntity(mesh: particleMesh, materials: [particleMaterial])
            m.orientation = simd_quatf(angle: -.pi/2, axis: [1,0,0]) // face up
            return m
        }
        particleEntities.forEach { anchor.addChild($0) }
    }

    func update(dt: Float) {
        sim.update(dt: dt)
        // Move cap layer to updated height
        capLayer?.position.y = sim.capHeight

        // Map particle positions into entities (clamp count if pool changed)
        let n = min(sim.particles.count, particleEntities.count)
        for i in 0..<n {
            let p = sim.particles[i]
            particleEntities[i].isEnabled = p.life > 0
            particleEntities[i].position = p.pos
        }
    }
}
