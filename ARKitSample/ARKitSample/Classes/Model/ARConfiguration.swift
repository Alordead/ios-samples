import Foundation
import ARKit

class ARConfiguration: ARWorldTrackingConfiguration {
    override init() {
        super.init()
        setup()
    }
}

// MARK: -Setup-
private extension ARConfiguration {
    func setup() {
        isLightEstimationEnabled = true
        planeDetection = .horizontal
    }
}
