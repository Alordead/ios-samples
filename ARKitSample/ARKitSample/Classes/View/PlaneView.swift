import Foundation
import ARKit
import UIKit

class PlaneView: SCNNode {
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: -Setup-
private extension PlaneView {
    func setup() {
        let flourPlane = SCNFloor()
        let groundMaterial = SCNMaterial()
        groundMaterial.lightingModel = .constant
        groundMaterial.writesToDepthBuffer = true
        groundMaterial.colorBufferWriteMask = []
        groundMaterial.isDoubleSided = true
        flourPlane.materials = [groundMaterial]
        position = SCNVector3(0.0, 2.0, 0.0)
        geometry = flourPlane
    }
}
