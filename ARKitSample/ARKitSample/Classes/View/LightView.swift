import Foundation
import ARKit
import UIKit

class LightView: SCNNode {
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: -Setup-
private extension LightView {
    func setup() {
        let lightNode = SCNLight()
        lightNode.type = .omni
        lightNode.intensity = 100
        lightNode.temperature = 0
        
        light = lightNode
        position = SCNVector3(0,5,5)
    }
}
