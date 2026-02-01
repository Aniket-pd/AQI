import SwiftUI
import ARKit
import SceneKit
import Combine

struct InversionARView: UIViewRepresentable {
    @ObservedObject var viewModel: InversionViewModel

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> ARSCNView {
        let view = ARSCNView(frame: .zero)
        view.delegate = context.coordinator
        view.session.delegate = context.coordinator
        view.automaticallyUpdatesLighting = true
        view.preferredFramesPerSecond = 60
        view.antialiasingMode = .multisampling2X

        let config = ARWorldTrackingConfiguration()
        config.environmentTexturing = .automatic
        config.isLightEstimationEnabled = true
        config.planeDetection = [.horizontal]
        view.session.run(config, options: [.resetTracking, .removeExistingAnchors])

        context.coordinator.controller.delegate = context.coordinator
        context.coordinator.controller.attach(to: view)
        // Initial UI state
        context.coordinator.parent.viewModel.placementState = .loadingModel

        // Tap-to-place support
        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.onTap(_:)))
        view.addGestureRecognizer(tap)

        // Gestures: pinch to scale, two-finger rotate
        let pinch = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.onPinch(_:)))
        view.addGestureRecognizer(pinch)
        let rotate = UIRotationGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.onRotate(_:)))
        view.addGestureRecognizer(rotate)

        // Fallback: auto-place in front of camera if no plane appears quickly
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            context.coordinator.controller.placeAtCameraStartIfNeeded(view)
        }
        return view
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {
        let light = uiView.session.currentFrame?.lightEstimate
        context.coordinator.controller.update(stability: viewModel.stability,
                                              lightEstimate: light,
                                              complexity: viewModel.targetComplexity)
    }

    final class Coordinator: NSObject, ARSCNViewDelegate, ARSessionDelegate, InversionControllerDelegate {
        let parent: InversionARView
        let controller = InversionController()

        init(_ parent: InversionARView) { self.parent = parent }

        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            controller.tick(time: frame.timestamp)
        }

        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            controller.placeCity(on: planeAnchor, parentNode: node)
        }

        // Tap raycast to place on detected/estimated plane or feature points
        @objc func onTap(_ gr: UITapGestureRecognizer) {
            guard let view = gr.view as? ARSCNView else { return }
            let p = gr.location(in: view)
            if let query = view.raycastQuery(from: p, allowing: .estimatedPlane, alignment: .horizontal),
               let result = view.session.raycast(query).first {
                let t = result.worldTransform
                controller.placeAt(transform: t)
            } else if let hit = view.hitTest(p, types: [.existingPlaneUsingExtent, .featurePoint]).first {
                controller.placeAt(transform: hit.worldTransform)
            } else if let frame = view.session.currentFrame {
                controller.placeAt(transform: frame.camera.transform)
            }
        }

        // MARK: - Gestures
        @objc func onPinch(_ gr: UIPinchGestureRecognizer) {
            // Only scale after placement to match Reality Composer behavior
            guard case .placed = parent.viewModel.placementState else { return }
            let current = Double(controller.currentModelScale)
            let newScale = max(0.5, min(2.5, current * gr.scale))
            controller.setModelScale(CGFloat(newScale))
            gr.scale = 1.0
        }

        @objc func onRotate(_ gr: UIRotationGestureRecognizer) {
            guard case .placed = parent.viewModel.placementState else { return }
            controller.rotateModel(by: gr.rotation)
            gr.rotation = 0
        }

        // MARK: - InversionControllerDelegate
        func inversionControllerDidStartLoadingModel(_ controller: InversionController) {
            DispatchQueue.main.async { self.parent.viewModel.placementState = .loadingModel }
        }
        func inversionControllerIsReadyToPlace(_ controller: InversionController) {
            DispatchQueue.main.async { self.parent.viewModel.placementState = .readyToPlace }
        }
        func inversionControllerDidPlace(_ controller: InversionController) {
            DispatchQueue.main.async { self.parent.viewModel.placementState = .placed }
        }
    }
}
