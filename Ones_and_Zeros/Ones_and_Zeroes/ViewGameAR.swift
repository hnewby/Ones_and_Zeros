//
//  ViewGameAR.swift
//  Ones_and_Zeroes
//
//  Created by Hannah Newby-Smith on 3/5/19.
//  Copyright © 2019 Jonah Pincetich. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import MultipeerConnectivity

/**************************************************************************
 Class:        ViewControllerAR
 
 Description:  AR UI for Game
 
 Inherits from: UIViewController, ARSCNViewDelegate, ARSessionDelegate
 *************************************************************************/
class ViewGameAR: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    //@IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var sceneView: ARSCNView!
    var multipeerSession: MultipeerSession!
    var mapProvider: MCPeerID?
    var logic : GameLogic!
    var gameBoard : GameBoard!
    var ARMap : ARWorldMap!
    
    @IBOutlet weak var btnDraw: UIButton!
    @IBOutlet weak var btnPlaceCard: UIButton!
    
    //@IBOutlet var singleCard: [UIButton]!
    @IBOutlet var hand: [UIButton]!
    var handButton: Array<UIButton> = []
    var selectedCard: Int!
    
    

    
    /**************************************************************************
     Function:       viewDidLoad
     
     Description:    Things that happen on load of screen
     
     Parameters:     none
     
     Returned:       nothing
     *************************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        //sceneView.delegate = self;
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
  
        logic.startGame()
        
        //Can't draw if not your turn
        if (logic.pThePlayer.turn == false) {
            btnDraw.isEnabled = false
            btnDraw.isHidden = true
        }
        
        //Can't play a card until one is selected
        btnPlaceCard.isEnabled = false
        btnPlaceCard.isHidden = true
        
        for i in 0 ..< hand.count
        {
            stackView.addArrangedSubview(hand[i])
        }
        

//        var card1 = (logic.pThePlayer.hand).currentHand[0];
//        var img1 = card1.getImage()
//        imgView.image = img1
        for i in 0 ..< hand.count
        {
            let card = (logic.pThePlayer.hand).currentHand[i];
            let img = card.getImage()
            hand[i].setBackgroundImage(img, for: .normal)
            
           hand[i].contentMode = .center
            hand[i].imageView?.contentMode = .scaleAspectFit
 
        }
        
        btnDraw.layer.cornerRadius = 8
        btnPlaceCard.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
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
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.initialWorldMap = ARMap
        sceneView.session.run(configuration)//, options: [.resetTracking, .removeExistingAnchors])
        sceneView.session.add(anchor: gameBoard.anchor)
        
        
        // Prevent the screen from being dimmed after a while
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func gameLoop () {
        
    }
    
    func setHandPictures() {
//        for i in 0 ..< 5 {
//            handImgs[i] =
//        }
    }
    func setSinglePicure (arrayIndex: Int, img : UIImageView) {
       // handImgs[arrayIndex] = img
    }
    
    @IBAction func selectCard(_ sender: UIButton) {
        for i in 0 ..< hand.count {
            hand[i].layer.borderWidth = 0
        }
      
        hand[sender.tag].layer.borderWidth = 2
        hand[sender.tag].layer.borderColor = UIColor.orange.cgColor
        selectedCard = sender.tag
        
        print (logic.unsafelyUnwrapped.pThePlayer.hand.currentHand[selectedCard])
        
        btnPlaceCard.isHidden = false
        btnPlaceCard.isEnabled = true
    }
    
    
    
    /**************************************************************************
     Function:       cardPlacement
     
     Description:    Called when btnPlaceCard is clicked, places the selected card onto the board
     
     Parameters:     sender -
     
     Returned:       nothing
     *************************************************************************/
    @IBAction func cardPlacement(_ sender: UIButton) {
        //print("cardPlacement called...\n")
        
        //Card Stuff
        let cardURL =
            URL(string: logic.unsafelyUnwrapped.pThePlayer.hand.currentHand[selectedCard].cardSCNImageURL)!
        let cardNode = SCNReferenceNode(url: cardURL)!
        
        gameBoard.referenceNode.addChildNode(cardNode)
        cardNode.position = SCNVector3(gameBoard.worldPosition.x, (gameBoard.worldPosition.y + gameBoard.topLocation) / 2, gameBoard.worldPosition.z + 0.5)
        
        cardNode.load()
        
        //Character Stuff
        let characterURL =
            URL(string: logic.unsafelyUnwrapped.pThePlayer.hand.currentHand[selectedCard].characterImageURL)!
        let characterNode = SCNReferenceNode(url: characterURL)!
        
        

        characterNode.position = SCNVector3(gameBoard.worldPosition.x,
                                            (((gameBoard.worldPosition.y + gameBoard.topLocation) / 2) + 0.30),
                                            gameBoard.worldPosition.z + 0.5)
        gameBoard.referenceNode.addChildNode(characterNode)
        
        characterNode.load()
        
        //remove image and card from hand once placed
        //hand.remove(at: sender.tag)
       
//        logic.unsafelyUnwrapped.pThePlayer.hand.currentHand.remove(at: sender.tag)
//        //hand[sender.tag].setBackgroundImage( for: .normal)//        hand.remove(at: selectedCard)
//        hand[sender.tag].backgroundColor = UIColor.gray
////        hand[selectedCard].layer.borderWidth = 0
//        btnPlaceCard.isHidden = true
//        btnPlaceCard.isEnabled = false
        
    }
    
    
    
    //    @IBAction func getTappedCard(_ sender: UIButton) {
//        //singleCard[sender.tag].
//    }
   
//    @IBAction func draw(_ sender: Any) {
//        let newCard = logic.gameDeck.draw()
//        singleCard[sender.tag].setTitle("\(newCard.cardImageURL)", for: UIControl.State.normal)
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
        print("renderer() called.")
        
        //The host shares its AR session with all peers
        if (multipeerSession.host)
        {
            shareSession()
        }
        
        //If an anchor name has the prefix GameBoard on it then it will load the board
        if let name = anchor.name, name.hasPrefix("GameBoard") {
            let boardNode = gameBoard.getNode()
            node.addChildNode(boardNode)
            //gameBoard.worldPosition = boardNode.worldPosition
            //gameBoard.topLocation = boardNode.boundingBox.max.y - boardNode.boundingBox.min.y
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
}
