import Foundation
import ARKit
import UIKit

class CubeView: SCNNode {
    
    // MARK: -Public-
    
    public let box = SCNBox(width: 0.02, height: 0.02, length: 0.02, chamferRadius: 0)
    
    // MARK: -Private-
    
    private enum State {
        case moving
        case stopped
    }
    
    private var state: State = .stopped {
        didSet {
            handleStateUpdating()
        }
    }
    
    private var rotationSpeed: Double = 1
    
    override init() {
        super.init()
    }
    
    init(with position: SCNVector3 = SCNVector3(0, 0.02, -0.05)) {
        super.init()
        setup(with: position)
        startAnimate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

// MARK: -UI-
extension CubeView {
    private func setup(with position: SCNVector3) {
        physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        physicsBody?.mass = 2.0
        physicsBody?.categoryBitMask = 1 << 1
        physicsBody?.damping = 0.5
        geometry = box
        rotation = getRandomRotationVector()
        geometry?.firstMaterial?.diffuse.contents = getRandomColor()
        geometry?.firstMaterial?.blendMode = getRandomBlendMode()
        self.position = position
    }
    
    func getRandomRotationVector() -> SCNVector4 {
        return SCNVector4(Float.random(in: 0...90), Float.random(in: 0...90), Float.random(in: 0...90), Float.random(in: 0...90))
    }
    
    func getRandomColor() -> UIColor {
        return UIColor.init(red: CGFloat.random(in: 0..<255) / 255.0,
                            green: CGFloat.random(in: 0..<255) / 255.0,
                            blue: CGFloat.random(in: 0..<255) / 255.0,
                            alpha: 1)
    }
    
    func getRandomBlendMode() -> SCNBlendMode {
        let randomInt = Int.random(in: 0...1)
        switch randomInt {
        case 0:
            return .alpha
        case 1:
            return .screen
        default:
            return .alpha
        }
    }
    
}

// MARK: -Public actions-
extension CubeView {
    func swapState() {
        state = state == .moving ? .stopped : .moving
    }
    
    func startAnimate() {
        state = .stopped
    }
}

// MARK: -Handlers-
extension CubeView {
    @objc func handleCubeDidSwipe(_ sender: UISwipeGestureRecognizer) {
        rotationSpeed = sender.direction == .right ? rotationSpeed + 0.2 : rotationSpeed - 0.2
        refreshAnimations()
    }
}

// MARK: -Private actions-
extension CubeView {
    
    private func handleStateUpdating() {
        switch state {
        case .moving: startRotateAnimation()
        case .stopped: stopAllAnimations()
        }
    }
    
    private func refreshAnimations() {
        stopAllAnimations()
        startRotateAnimation()
    }
    
    private func startRotateAnimation() {
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(rotationSpeed * Double.pi), z: 0, duration: 1)
        let repAction = SCNAction.repeatForever(action)
        self.runAction(repAction, forKey: "rotate")
    }
    
    private func stopAllAnimations() {
        self.removeAllActions()
    }
    
}
