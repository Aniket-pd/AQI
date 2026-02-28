import Foundation
import SceneKit
import UIKit

final class ARAssetWarmup {
    static let shared = ARAssetWarmup()

    private let queue = DispatchQueue(label: "com.aqi.ar-warmup", qos: .userInitiated)
    private let lock = NSLock()
    private var hasStarted = false
    private var isLoadingCity = false
    private var cachedCityTemplate: SCNNode?
    private var cityWaiters: [(SCNNode?) -> Void] = []

    private init() {}

    static let pm25ParticleImage: UIImage? = {
        UIImage(systemName: "circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
    }()

    func prepareIfNeeded() {
        lock.lock()
        let shouldStart = !hasStarted
        if shouldStart { hasStarted = true }
        lock.unlock()

        guard shouldStart else { return }

        _ = Self.pm25ParticleImage
        preloadCityIfNeeded()
    }

    func fetchPreparedCityContainer(_ completion: @escaping (SCNNode?) -> Void) {
        lock.lock()
        if let cachedCityTemplate {
            let clone = cachedCityTemplate.clone()
            lock.unlock()
            DispatchQueue.main.async { completion(clone) }
            return
        }

        cityWaiters.append(completion)
        let needsLoad = !isLoadingCity
        if needsLoad {
            isLoadingCity = true
            hasStarted = true
        }
        lock.unlock()

        if needsLoad {
            queue.async { [weak self] in
                guard let self else { return }
                let loaded = Self.loadPreparedCityTemplate()
                self.finishCityLoad(with: loaded)
            }
        }
    }

    private func preloadCityIfNeeded() {
        fetchPreparedCityContainer { _ in }
    }

    private func finishCityLoad(with template: SCNNode?) {
        lock.lock()
        cachedCityTemplate = template
        isLoadingCity = false
        let waiters = cityWaiters
        cityWaiters.removeAll()
        lock.unlock()

        DispatchQueue.main.async {
            waiters.forEach { $0(template?.clone()) }
        }
    }

    private static func loadPreparedCityTemplate() -> SCNNode? {
        guard let url = cityModelURL(),
              let scene = try? SCNScene(url: url, options: nil) else {
            return nil
        }

        let container = SCNNode()
        container.name = "cityModel"
        for child in scene.rootNode.childNodes {
            container.addChildNode(child)
        }

        var minVec = SCNVector3Zero
        var maxVec = SCNVector3Zero
        if container.__getBoundingBoxMin(&minVec, max: &maxVec) {
            let sizeX = CGFloat(maxVec.x - minVec.x)
            let sizeZ = CGFloat(maxVec.z - minVec.z)
            let maxSpan = max(sizeX, sizeZ)
            let targetSpan: CGFloat = 0.34
            if maxSpan > 0.0001 {
                let scale = Float(targetSpan / maxSpan)
                container.scale = SCNVector3(scale, scale, scale)
            }

            let centerX = (minVec.x + maxVec.x) * 0.5
            let centerZ = (minVec.z + maxVec.z) * 0.5
            let scaledMinY = Float(minVec.y) * container.scale.y
            container.position = SCNVector3(
                -centerX * container.scale.x,
                -scaledMinY + 0.006,
                -centerZ * container.scale.z
            )
        }

        return container
    }

    private static func cityModelURL() -> URL? {
        // "Tiny City" (https://skfb.ly/6xOOr) by Matheus Dalla is licensed under
        // Creative Commons Attribution 4.0 (http://creativecommons.org/licenses/by/4.0/).
        let modelName = "Tiny_City (1)"
        if let url = Bundle.main.url(forResource: modelName, withExtension: "usdz", subdirectory: "AR/Assets") {
            return url
        }
        return Bundle.main.url(forResource: modelName, withExtension: "usdz")
    }
}
