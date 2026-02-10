import SwiftUI
import ARKit
import SceneKit

struct PM25ARView: UIViewRepresentable {
    @ObservedObject var viewModel: PM25OverlayViewModel

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> ARSCNView {
        let view = ARSCNView(frame: .zero)
        view.delegate = context.coordinator
        view.session.delegate = context.coordinator
        view.automaticallyUpdatesLighting = true
        view.preferredFramesPerSecond = 60
        view.contentScaleFactor = UIScreen.main.scale
        view.isUserInteractionEnabled = true

        let config = ARWorldTrackingConfiguration()
        config.environmentTexturing = .automatic
        config.isLightEstimationEnabled = true
        view.session.run(config, options: [.resetTracking, .removeExistingAnchors])

        context.coordinator.controller.attach(to: view)
        // Gestures: tap pulse and pan push
        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.onTap(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        let pan = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.onPan(_:)))
        pan.maximumNumberOfTouches = 1
        pan.cancelsTouchesInView = false
        view.addGestureRecognizer(pan)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            context.coordinator.controller.placeAtCameraStart(view)
        }

        return view
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // Intentionally no heavy updates here; AR session delegate drives updates.
    }

    final class Coordinator: NSObject, ARSCNViewDelegate, ARSessionDelegate {
        let parent: PM25ARView
        let controller = PM25ParticleController()
        init(_ parent: PM25ARView) { self.parent = parent }

        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            controller.updatePM25(value: parent.viewModel.pm25, lightEstimate: frame.lightEstimate, complexityScale: parent.viewModel.targetComplexity)
        }

        func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
            controller.updatePerFrame(time: time)
        }

        // UIKit gesture handlers
        @objc func onTap(_ gr: UITapGestureRecognizer) {
            let p = gr.location(in: gr.view)
            controller.handleTap(at: p)
        }

        @objc func onPan(_ gr: UIPanGestureRecognizer) {
            let p = gr.location(in: gr.view)
            controller.handleDrag(at: p)
        }
    }
}
