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
    var planeArray = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //allows to find feature points
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        

        sceneView.autoenablesDefaultLighting = true
        
//        // Create a new scene
//

//        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    @IBAction func addCityObject(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "goToMenu", sender: self)
    }
    
    // if user wants to remove the grid and place one in a new spot, they press
    // New Grid and activate this function
    @IBAction func removeGrid(_ sender: UIBarButtonItem) {
        // if the array is occupied with planeNodes
        if !planeArray.isEmpty {
            // iterate through array and remove each node from the parent
            // node and scene
            for plane in planeArray {
                plane.removeFromParentNode()
            }
            // empty the array
            planeArray.removeAll()
        }
    }
    
    // if user wants to undo the last action of adding a new city object,
    // they press undo
    @IBAction func undoAddCityObject(_ sender: UIBarButtonItem) {
        // won't pass through this logic gate without an object available to
        // assign to cityObject
        if let cityObject = cityObjectArray.last {
            // remove node from parent node and subsequently the scene
            cityObject.removeFromParentNode()
            cityObjectArray.removeLast()
        }
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToMenu" {
            let destinationVC = segue.destination as! MenuViewController
            if destinationVC.objectSelection != nil {
                
            }
        }
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
                print(hitResult)
                
                // create new city object scene
                let cityObjectScene = SCNScene(named: "art.scnassets/tram.scn")!
                
                if let cityObjectNode = cityObjectScene.rootNode.childNode(withName: "Tram", recursively: true) {
                    
                    // use hitResult coordinates in SCNVector3 to place Dice onto the grid
                    // add the raidus of the dice onto the y coordinate in order to make the dice sit on top of grid
                    cityObjectNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
                    
                    // Add the object to the cityObjectArray
                    cityObjectArray.append(cityObjectNode)
                    
                    sceneView.scene.rootNode.addChildNode(cityObjectNode)
                    
                    
        
                }
            }
        }
    }
    
    
    // tells delegate(current view controller) that a scenekit node corresponding to a new AR ahcnor has been
    // added to the scene. We will anchor objects to this AR anchor
    // when a new horizontal plane is detected, this function will be called
    // Can use for placing buildings and structures
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor && planeArray.isEmpty {
            
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
            
            planeArray.append(planeNode)
            
        } else {
            return
        }
    }
}




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
