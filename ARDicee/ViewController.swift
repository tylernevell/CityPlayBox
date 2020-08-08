//
//  ViewController.swift
//  ARDicee
//
//  Created by Tyler Nevell on 8/7/20.
//  Copyright © 2020 Tyler Nevell. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //allows to find feature points
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
//        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
//
//        let material = SCNMaterial()
//
//        material.diffuse.contents = UIColor.red
//
//        cube.materials = [material]
//
//        let node = SCNNode()
//
//        node.position = SCNVector3(0, 0.1, -0.5)
//        node.geometry = cube
//
//        sceneView.scene.rootNode.addChildNode(node)
        sceneView.autoenablesDefaultLighting = true
        
//        // Create a new scene
//        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
//
//        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
//
//            diceNode.position = SCNVector3(0.0, 0.0, -0.1)
//
//            sceneView.scene.rootNode.addChildNode(diceNode)
//
//        }
//        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // tells delegate(current view controller) that a scenekit node corresponding to a new AR ahcnor has been
    // added to the scene. We will anchor objects to this AR anchor
    // when a new horizontal plane is detected, this function will be called
    // Can use for placing buildings and structures
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            
            // downcast anchor into the type ARPlanceAnchor
            let planeAnchor = anchor as! ARPlaneAnchor
            
            // use the planeAnchor's dimensions to measure out size of plane
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            // create the node for the plane and give its position
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0.0, z: planeAnchor.center.z)
            
            // transform and rotate planeNode to make horizontal
            // angle measured in radians, counterclockwise.
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1.0, 0.0, 0.0)
            planeNode.geometry = plane

            // lets build a grid
            let gridMaterial = SCNMaterial()
            // import grid image into gridMaterial to make it usable
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            // apply gridMaterial texture to plane
            plane.materials = [gridMaterial]
            
            // add planeNode onto the scene
            node.addChildNode(planeNode)
            
        } else {
            return
        }
    }
}
