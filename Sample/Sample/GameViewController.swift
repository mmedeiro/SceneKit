//
//  GameViewController.swift
//  Sample
//
//  Created by Mariana Medeiro on 11/05/15.
//  Copyright (c) 2015 Mariana Medeiro. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
     var myView : SCNView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        let myView = SCNView(frame: self.view.frame)
        let myScene = SCNScene()
        myView.scene = myScene
//        myView.autoenablesDefaultLighting = true
//        myView.showsStatistics = false
        myView.allowsCameraControl = true
        
        self.view.addSubview(myView)
        
        // Create a box and put it at the center of the scene
        let myBox = SCNBox(width: 15, height: 10, length: 12, chamferRadius: 0)
        let myBoxNode = SCNNode(geometry: myBox)
        myBoxNode.position = SCNVector3(x: 0, y: 0, z: 0)
        myBoxNode.rotation = SCNVector4(x: 1, y: 1, z: 0.5, w: 0.6)
        myScene.rootNode.addChildNode(myBoxNode)
        
        let myLight = SCNLight()
        let myLightNode = SCNNode()
        myLight.type = SCNLightTypeOmni
        myLight.color = UIColor.yellowColor()
        myLightNode.light = myLight
        myLightNode.position = SCNVector3(x: -30, y: 30, z: 60)
        myScene.rootNode.addChildNode(myLightNode)
    
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.dae")!
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)
        
        let myCamera = SCNCamera()
        myCamera.xFov = 40
        myCamera.yFov = 40
        let myCameraNode = SCNNode()
        myCameraNode.camera = myCamera
        myCameraNode.position = SCNVector3(x: -25, y: 20, z: 30)
        myCameraNode.orientation = SCNQuaternion(x: -0.26, y: -0.32, z: 0, w: 0.91)
        myScene.rootNode.addChildNode(myCameraNode)
        
//        let myOmniLight = SCNLight()
//        let myOmniLightNode = SCNNode()
//        myOmniLight.type = SCNLightTypeOmni
//        myOmniLight.color = UIColor.yellowColor()
//        myOmniLightNode.light = myOmniLight
//        myOmniLightNode.position = SCNVector3(x: -30, y: 30, z: 60)
//        myScene.rootNode.addChildNode(myOmniLightNode)

//        let myAmbientLight = SCNLight()
//        myAmbientLight.type = SCNLightTypeAmbient
//        myAmbientLight.color = UIColor.yellowColor()
//        let myAmbientLightNode = SCNNode()
//        myAmbientLightNode.light = myAmbientLight
//        myScene.rootNode.addChildNode(myAmbientLightNode)
        
//        let myDirectLight = SCNLight()
//        myDirectLight.type = SCNLightTypeDirectional
//        myDirectLight.color = UIColor.yellowColor()
//        let myDirectLightNode = SCNNode()
//        myDirectLightNode.light = myDirectLight
//        myDirectLightNode.orientation = SCNQuaternion(x: 0, y: 0, z: 1, w: 0)
//        myScene.rootNode.addChildNode(myDirectLightNode)
        
        let mySpotLight = SCNLight()
        mySpotLight.type = SCNLightTypeSpot
        mySpotLight.color = UIColor.yellowColor()
        let mySpotLightNode = SCNNode()
        mySpotLightNode.light = mySpotLight
        mySpotLightNode.position = SCNVector3(x: 0, y: 0, z: 20)
        mySpotLightNode.orientation = SCNQuaternion(x: 0, y: 0, z: 1, w: 0.5)
        myScene.rootNode.addChildNode(mySpotLightNode)

        
        // retrieve the ship node
        let ship = scene.rootNode.childNodeWithName("ship", recursively: true)!
        
        // animate the 3d object
        ship.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 1)))
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.blackColor()
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        var gestureRecognizers = [AnyObject]()
        gestureRecognizers.append(tapGesture)
        if let existingGestureRecognizers = scnView.gestureRecognizers {
            gestureRecognizers.extend(existingGestureRecognizers)
        }
        scnView.gestureRecognizers = gestureRecognizers
    }
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.locationInView(scnView)
        if let hitResults = scnView.hitTest(p, options: nil) {
            // check that we clicked on at least one object
            if hitResults.count > 0 {
                // retrieved the first clicked object
                let result: AnyObject! = hitResults[0]
                
                // get its material
                let material = result.node!.geometry!.firstMaterial!
                
                // highlight it
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(0.5)
                
                // on completion - unhighlight
                SCNTransaction.setCompletionBlock {
                    SCNTransaction.begin()
                    SCNTransaction.setAnimationDuration(0.5)
                    
                    material.emission.contents = UIColor.blackColor()
                    
                    SCNTransaction.commit()
                }
                
                material.emission.contents = UIColor.redColor()
                
                SCNTransaction.commit()
            }
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
//    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
//       
//        let quaternion = myView?.pointOfView.orientation
//        let position = myView?.pointOfView.position
//            println("Orientation: (\(quaternion?.x),\(quaternion?.y),\(quaternion?.z),\(quaternion?.w)) Position: (\(position?.x),\(position?.y),\(position?.z)")
//        }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    
    

}
