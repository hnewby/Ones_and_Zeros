//
//  ViewControllerAR.swift
//  Ones and Zeroes
//
//  Created by Jonah Pincetich on 10/8/18.
//  Copyright © 2018 Jonah Pincetich. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import MultipeerConnectivity

/**************************************************************************
 Class:        ViewControllerAR
 
 Description:  AR UI for GameBoard Setup
 
 Inherits from: UIViewController, ARSCNViewDelegate, ARSessionDelegate
 *************************************************************************/
class ViewControllerAR: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    

    
    @IBOutlet weak var btnSetBoard: UIButton!
    @IBOutlet weak var boardLabel: UILabel!
    //@IBOutlet weak var btnSetBoard: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    var multipeerSession: MultipeerSession!
    var gameDeck : Deck!
    var mapProvider: MCPeerID?
    var logic = GameLogic()
    var gameBoard = GameBoard ()

    //var configuration : ARWorldTrackingConfiguration!


    
    /**************************************************************************
     Function:       viewDidLoad
     
     Description:    Things that happen on load of screen
     
     Parameters:     none
     
     Returned:       nothing
     *************************************************************************/
    override func viewDidLoad() {
        //print("viewDidLoad() called.")
        super.viewDidLoad()
       
        
        sceneView.delegate = self;

        // Set the scene to the view
        self.sceneView.autoenablesDefaultLighting = true
        if (multipeerSession.host)
        {
            self.sceneView.debugOptions =
                [.showConstraints, .showLightExtents, ARSCNDebugOptions.showFeaturePoints]
        }

     
        //Set already connected multipeersession to a new receivedDataHandler function
        multipeerSession.setReceivedDataHandler(receivedDataHandler: receivedData)
        if(!multipeerSession.host) {
            btnSetBoard.isHidden = true;
        } else {
            boardLabel.isHidden = true
            btnSetBoard.isEnabled = false;
        }
        logic.pThePlayer.setGameDeck(theDeck: gameDeck)
        logic.multipeerSession = self.multipeerSession
        btnSetBoard.layer.cornerRadius = 15
        // set up player to be able to play
    }
    
    /**************************************************************************
     Function:       viewWillAppear
     
     Description:    Notifies the view controller that its view is about to
     be added to a view hierarchy.
     
     Parameters:     animated: Bool - If true, the disappearance of the
     view is being animated.
     
     Returned:       Nothing
     *************************************************************************/
    override func viewWillAppear(_ animated: Bool) {
        //print("viewWillAppear() called.")
        super.viewWillAppear(animated)
        sceneView.delegate = self
    }
    
    /**************************************************************************
     Function:       viewDidAppear
     
     Description:    Notifies the view controller that its view was added to
     a view hierarchy.
     
     Parameters:     animated: Bool - If true, the view was added to the
     window using an animation.
     
     Returned:       none
     *************************************************************************/
    override func viewDidAppear(_ animated: Bool) {
        //print("viewDidAppear called.")
        
        super.viewDidAppear(animated)
        
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("""
                ARKit is not available on this device. For apps that require ARKit
                for core functionality, use the `arkit` key in the key in the
                `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
                the app from installing. (If the app can't be installed, this error
                can't be triggered in a production scenario.)
                In apps where AR is an additive feature, use `isSupported` to
                determine whether to show UI for launching AR experiences.
            """) // For details, see https://developer.apple.com/documentation/arkit
        }
        
        // Start the view's AR session.
        //if (multipeerSession.host)
        //{
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = .horizontal
            sceneView.session.run(configuration)
        //}

        
        //Setup gameBoard object
        gameBoard.initialize(position: nil, scn: sceneView)
        
        // Prevent the screen from being dimmed after a while
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    /**************************************************************************
     Function:       handleSceneTap
     
     Description:   Called when the screen is tapped by the user.
     
     Parameters:    sender: UITapGestureRecgonizer - Object representing
     the tap made by the user
     
     Returned:       none
     *************************************************************************/
    @IBAction func handleSceenTap(_ sender: UITapGestureRecognizer) {
        print("handleSceneTap() called.")
        // Hit test to find a place for a virtual object.
        guard let hitTestResult = sceneView
            .hitTest(sender.location(in: sceneView), types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
            .first
            else { return }
        
        
        //If you're the host then initialize the gameBoard
        if (multipeerSession.host)
        {
            print (multipeerSession.host)
            btnSetBoard.isEnabled = true
            gameBoard.initialize(position: hitTestResult, scn: sceneView)
            shareSession()
            gameBoard.share(session: self.multipeerSession)
        }
        
    }

    /**************************************************************************
     Function:       renderer
     
     Description:    The view calls this method once for each new anchor
     ARKit also calls this method to provide visual
     content for any ARAnchor objects you manually add
     using the session's add(anchor:) method
     
     Parameters:     SCNSceneRenderer, SCNNode, ARAnchor
     
     Returned:       none
     *************************************************************************/
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        //print("renderer() called.")
        
        //The host shares its AR session with all peers
        if (multipeerSession.host)
        {
            shareSession()
        }
        
        //If an anchor name has the prefix GameBoard on it then it will load the board
        if let name = anchor.name, name.hasPrefix("GameBoard") {
            let boardNode = gameBoard.getNode()
            node.addChildNode(boardNode)
            gameBoard.worldPosition = boardNode.worldPosition
            gameBoard.topLocation = boardNode.boundingBox.max.y - boardNode.boundingBox.min.y
        }
    }
    
    /**************************************************************************
     Function:      shareSession
     
     Description:   Sends the current World Map to all of the peers
     
     Parameters:    None
     
     Returned:      Nothing
     *************************************************************************/
    func shareSession() {
        print("shareSession() called.")
        sceneView.session.getCurrentWorldMap { worldMap, error in
            guard let map = worldMap
                else { print("Error: \(error!.localizedDescription)"); return }
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                else { fatalError("can't encode map") }
            self.multipeerSession.sendToAllPeers(data)
        }
    }
    
    
    /**************************************************************************
     Function:       receivedData
     
     Description:   Receives and decodes a Data object to a world map or anchor
     
     Parameters:    data: Data - The data object received
     peer: MCPeerID - The peer that sent the data
     
     Returned:       none
     *************************************************************************/
    func receivedData(_ data: Data, from peer: MCPeerID) {
        print("receivedData() called.")
        do
        {
            //print ("Checking if data is worldMap...")
            let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data)
            if nil != worldMap
            {
                print("Decoding data as worldMap.")
                // Run the session with the received world map.
                let configuration = ARWorldTrackingConfiguration()
                configuration.planeDetection = .horizontal
                configuration.initialWorldMap = worldMap
                sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
                
                // Remember who provided the map
                mapProvider = peer
            }
        }
        catch
        {
            //print("Data received is not a worldMap.")
            if(gameBoard.decodeAnchor(data: data))
            {
                print("Decoded received data as gameBoard Anchor.")
            }
            else
            {
                print ("Received data is not gameBoard Anchor.")
            }
        }
        
    }
    
    /**************************************************************************
     Function:       session
     
     Description:   Informs the delegate of changes to the quality of
     ARKit's device position tracking.
     
     Parameters:    session - The session providing information
     cameraDidChangeTrackingState - Camera with changed
     tracking state
     
     Returned:       none
     *************************************************************************/
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        // print("session() -> cameraDidChangeTrackingState called.")
    }
    
    /**************************************************************************
     Function:       session
     
     Description:   Provides a newly captured camera image and accompanying
     AR information to the delegate. (CheckMappingStatus)
     
     Parameters:    session: ARSession - The session providing information
     frame: ARframe - An object containing the new camera
     image and AR information
     
     Returned:       none
     *************************************************************************/
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        //  print("session() -> didUpdate called.")
    }
    
    /**************************************************************************
     Function:       sessionWasInterrupted
     
     Description:   Tells the delegate that the session has temporarily
     stopped processing frames and tracking device position.
     
     Parameters:    session: ARsession - The session providing information
     
     Returned:       none
     *************************************************************************/
    func sessionWasInterrupted(_ session: ARSession) {
        //print("sessionWasInterrupted() called.")
    }
    
    /**************************************************************************
     Function:       sessionInterruptionEnded
     
     Description:   Tells the delegate that the session has resumed
     processing frames and tracking device position.
     
     Parameters:    session: ARsession - The session providing information
     
     Returned:       none
     *************************************************************************/
    func sessionInterruptionEnded(_ session: ARSession) {
        //print("sessionInterruptionEnded() called.")
    }
    
    /**************************************************************************
     Function:       session
     
     Description:   Tells the delegate that the session has stopped running
     due to an error.
     
     Parameters:    session: ARSession - The session providing information
     error: Error - An object describing the failure
     
     Returned:       none
     *************************************************************************/
    func session(_ session: ARSession, didFailWithError error: Error) {
        print("Session failed: \(error.localizedDescription)")
        //Restarts Tracking
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    /**************************************************************************
     Function:       sessionShouldAttemptRelocalization
     
     Description:   Asks the delegate whether to attempt recovery of
     world-tracking state after an interruption.
     
     Parameters:    session: ARSession - The session providing information.
     
     Returned:       TRUE
     *************************************************************************/
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        //print("sessionShouldAttemptRelocalization() called.")
        return true
    }
    
    /**************************************************************************
     Function:       viewWillDisappear
     
     Description:    Notifies the view controller that its view is about
     to be removed from a view hierarchy.
     
     Parameters:     animated: Bool - If true, the disappearance of the
     view is being animated.
     
     Returned:       none
     *************************************************************************/
    override func viewWillDisappear(_ animated: Bool) {
        //print("viewWillDisappear() called.")
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    
    
    @IBAction func btnSetBoardfn(_ sender: Any) {
        self.performSegue(withIdentifier: "sgBoardPlacedPlay", sender: self)
    }
    
    /**************************************************************************
     Function:       prepare
     
     Description:    Called when a segue is about to be called (When the view is about to change)
     
     Parameters:
     
     Returned:       Nothing
     *************************************************************************/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ViewGameAR = segue.destination as? ViewGameAR {
            ViewGameAR.multipeerSession = self.multipeerSession
            ViewGameAR.logic = self.logic // has person with deck in it
            ViewGameAR.gameBoard = self.gameBoard

            ViewGameAR.sceneView = self.sceneView
            self.sceneView.session.getCurrentWorldMap{ worldMap, error in
                guard let map = worldMap
                    else { print("Error: \(error!.localizedDescription)"); return }
                ViewGameAR.ARMap = map
            }
            
        }
    }
    
    
    // TODO: Move to Login View
    // Auto rotates only between landscapes
    override var shouldAutorotate: Bool
    {
        if (UIInterfaceOrientation.landscapeLeft.isLandscape || UIInterfaceOrientation.landscapeRight.isLandscape)
        {
            return true
        } else {
            return false
        }
    }
}
