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
    
    // array of the buildings. Allows us to undo last building placement
    var cityObjectArray = [SCNNode]()
    
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
//

//        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    @IBAction func addCityObject(_ sender: UIBarButtonItem) {
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
    
    
    // where we'll be recieving touches from the user. Use ARKit to convert touches
    // to real world location
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            // in: is where the location was detected
            // the touch occurs in sceneView, so pass that in
            let touchLocation = touch.location(in: sceneView)
            
            // convert touchLocation into a 3d location using hitTest
            // searches for real world objects/ar anchors corresponding to in
            // the SceneKit view
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent) // types: passing in a point in 3D space
            
            // if we didnt get a result back, we didnt hit an existing plane
            
            // check if there was a hitTest result that came back and and first result isn't nill
            if let hitResult = results.first {
                // uncomment this out to see how coordinates gathered for diceNode.position vectors
                // print(hitResult)
                
                // create new Dice scene
                let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
                
                if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
                    
                    // use hitResult coordinates in SCNVector3 to place Dice onto the grid
                    // add the raidus of the dice onto the y coordinate in order to make the dice sit on top of grid
                    diceNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius, hitResult.worldTransform.columns.3.z)
                    
                    // Add the object to the cityObjectArray
                    cityObjectArray.append(diceNode)
        
                    sceneView.scene.rootNode.addChildNode(diceNode)
                    
                    
        
                }
            }
        }
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
