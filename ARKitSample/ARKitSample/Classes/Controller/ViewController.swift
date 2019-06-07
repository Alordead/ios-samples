import UIKit
import ARKit

class ViewController: UIViewController, SCNPhysicsContactDelegate {
    
    let configuration = ARConfiguration()
    let sceneView: ARSCNView
    var cubes: [CubeView] = []
    let plane = PlaneView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
        setupARScene()
        setupLights()
    }
    
    required init?(coder aDecoder: NSCoder) {
        sceneView = ARSCNView()
        super.init(coder: aDecoder)
    }

}

// MARK: -UI-
private extension ViewController {
    
    func setupUI() {
        sceneView.frame = self.view.bounds
        sceneView.scene.rootNode.addChildNode(plane)
        sceneView.antialiasingMode = .multisampling4X
        
        self.view.addSubview(sceneView)
    }
    
    func setupActions() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector (self.handleSceneViewDidTap(_:)))
        sceneView.addGestureRecognizer(tapRecognizer)
        
        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector (self.handleCubeDidSwipe(_:)))
        rightSwipeRecognizer.direction = [.right]
        sceneView.addGestureRecognizer(rightSwipeRecognizer)
        
        let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector (self.handleCubeDidSwipe(_:)))
        leftSwipeRecognizer.direction = [.left]
        sceneView.addGestureRecognizer(leftSwipeRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector (self.handleSceneViewLongPressed(_:)))
        sceneView.addGestureRecognizer(longPressRecognizer)
    }
    
    func setupARScene() {
        self.sceneView.session.run(configuration)
        self.sceneView.scene.physicsWorld.gravity = SCNVector3(0, -1.62, 0)
    }
    
    func setupLights() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
}

// MARK -Actions-
private extension ViewController {
    
    func insertCubeIfNeeded(with tapPoint: CGPoint, and cube: CubeView? = nil) {
        let result = sceneView.hitTest(tapPoint, types: .existingPlane)
        
        if result.isEmpty {
            return
        }
        
        guard let hitResult = result.first else { return }
        
        if let cube = cube {
            insertCube(with: hitResult, and: SCNVector3(cube.position.x,
                                                               cube.position.y + 0.02,
                                                               cube.position.z))
        } else {
            insertCube(with: hitResult, and: SCNVector3(x: hitResult.worldTransform.columns.3.x,
                                                       y: hitResult.worldTransform.columns.3.y,
                                                       z: hitResult.worldTransform.columns.3.z))
        }
    }
    
    func insertCube(with hitResult: ARHitTestResult, and vector: SCNVector3) {
        let position = vector
        let cube = CubeView(with: position)
    
        sceneView.scene.rootNode.addChildNode(cube)
        cubes.append(cube)
    }
    
}

// MARK -Handlers-
private extension ViewController {
    
    @objc func handleSceneViewDidTap(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: sceneView)
        
        if let nodeResult = sceneView.hitTest(tapPoint, options: [
            SCNHitTestOption.boundingBoxOnly: true,
            SCNHitTestOption.firstFoundOnly: true
            ]).first,
            let cube = nodeResult.node as? CubeView {
                insertCubeIfNeeded(with: tapPoint, and: cube)
        } else {
            insertCubeIfNeeded(with: tapPoint)
        }
    }
    
    @objc func handleSceneViewLongPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.minimumPressDuration <= 0.1 && !sender.delaysTouchesEnded {
            return
        }
        
        let tapPoint = sender.location(in: sceneView)
        let result = sceneView.hitTest(tapPoint, options: [
            SCNHitTestOption.boundingBoxOnly: true,
            SCNHitTestOption.firstFoundOnly: true
            ])
        
        guard let hitResult = result.first else { return }
        
        if !result.isEmpty {
            let parentNode = hitResult.node
            if let cube = parentNode as? CubeView {
                cube.swapState()
            }
        }
    }
    
    @objc func handleCubeDidSwipe(_ sender: UISwipeGestureRecognizer) {
        let tapPoint = sender.location(in: sceneView)
        let result = sceneView.hitTest(tapPoint, options: [
            SCNHitTestOption.boundingBoxOnly: true,
            SCNHitTestOption.firstFoundOnly: true
            ])
        
        guard let hitResult = result.first else { return }
        
        if !result.isEmpty {
            let parentNode = hitResult.node
            if let cube = parentNode as? CubeView {
                cube.handleCubeDidSwipe(sender)
            }
        }
    }
    
}
