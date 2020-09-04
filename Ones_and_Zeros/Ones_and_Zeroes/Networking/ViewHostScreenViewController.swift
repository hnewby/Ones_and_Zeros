//
//  ViewHostScreenViewController.swift
//  Ones_and_Zeroes
//
//  Created by Hannah Newby-Smith on 11/8/18.
//  Copyright © 2018 Jonah Pincetich. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewHostScreenViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    //@IBOutlet weak var btnPlayGame: UIButton!
    
    var advertiser:MCAdvertiserAssistant!
    private var session : MCSession!
    var sendMsg:String = "Connection Complete"
    var hosting:Bool!
    var image:UIImage!
    //var currentPlayer : Player
        //    btnPlayGame.isEnabled = false // KEEP THIS, WHAT MAKES PLAY BUTTON NOT PRESSABLE IF WE DONT WANT IT
    var multipeerSession: MultipeerSession!

    @IBOutlet weak var btnBackNav: UIBarButtonItem!
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var btnHost: UIButton!
    @IBOutlet weak var btnPickDeck: UIButton!
    /**************************************************************************
     Function:       viewDidLoad
     
     Description:    Called when screen loads
     
     Parameters:     none
     
     Returned:       none
     *************************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
       multipeerSession = MultipeerSession(receivedDataHandler: receivedData)
       
        btnJoin.layer.cornerRadius = 15
        btnHost.layer.cornerRadius = 15
        btnJoin.layer.shadowRadius = 2
        btnHost.layer.shadowRadius = 2
        btnJoin.layer.shadowOpacity = 0.7
        btnHost.layer.shadowOpacity = 0.7
        btnJoin.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        btnHost.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)

        btnPickDeck.layer.cornerRadius = 15
        btnJoin.layer.cornerRadius = 15
        

//        
//        UIGraphicsBeginImageContext(self.view.frame.size)
//        UIImage(named: "circut.jpg")?.draw(in: self.view.bounds)
//        
//        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        
//        UIGraphicsEndImageContext()
//        
//        self.view.backgroundColor = UIColor(patternImage: image)
//        
     
        //btnPlayGame.isEnabled = true
        // Do any additional setup after loading the view.
    }
    
    /**************************************************************************
     Function:       prepare
     
     Description:    Called when a segue is about to be called (When the view is about to change)
     
     Parameters:
     
     Returned:       Nothing
     *************************************************************************/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ViewPickGameDeck = segue.destination as? ViewPickGameDeck {
            ViewPickGameDeck.multipeerSession = multipeerSession
        }
    }

  
    /**************************************************************************
     Function:       btnHostConn
     
     Description:    When host button is pressed
     
     Parameters:     sender: Any
     
     Returned:       none
     *************************************************************************/
    @IBAction func btnHostConn(_ sender: Any) {
        self.advertiser = MCAdvertiserAssistant(serviceType: "OZService", discoveryInfo: nil, session: multipeerSession.session)
        self.advertiser.start()
        self.hosting = true
        multipeerSession.host = true
        sendMsg = "Connection Complete from Host!"
    }
    /**************************************************************************
     Function:       btnJoinToConn
     
     Description:    When join button is pressed
     
     Parameters:     sender: Any
     
     Returned:       none
     *************************************************************************/
    @IBAction func btnJoinToConn(_ sender: Any) {
        let browser = MCBrowserViewController(serviceType: "OZService", session: multipeerSession.getSession())// multipeerSession.session)
        browser.delegate = self
        self.present(browser, animated: true, completion: nil)
        multipeerSession.host = false
    }
    
    /**************************************************************************
     Function:       btnPlayGamefn
     
     Description:    when play is hit after connection is established
     
     Parameters:     sender: Any
     
     Returned:       none
     *************************************************************************/
//    @IBAction func btnPlayGamefn(_ sender: Any) {
//        if (btnPlayGame.isEnabled)
//        {
//            self.performSegue(withIdentifier: "sgHostToLoadDBConnection", sender: self)
//        }
//    }
    
    /**************************************************************************
     Function:       btnAR
     
     Description:    when AR button is pressed jumps to AR screen
     
     Parameters:     sender: Any
     
     Returned:       none
     *************************************************************************/
    @IBAction func btnAR(_ sender: Any) {
        self.performSegue(withIdentifier: "sgAR", sender: self)
        
    }
    
    /**************************************************************************
    Function:       btnPickDeck
    
    Description:    Button to pick game deckp
    
    Parameters:     sender: Any
    
    Returned:       none
    *************************************************************************/
    @IBAction func btnPickDeck(_ sender: Any) {
        self.performSegue(withIdentifier: "sgPickDeck", sender: self)
    }
    /**************************************************************************
     Function:       recievedData
     
     Description:    Not sure what it does but we have to have it
     
     Parameters:     _ data: Data, from peer: MCPeerID
     
     Returned:       none
     *************************************************************************/
    func receivedData(_ data: Data, from peer: MCPeerID) {
        
       // Just need to have
    }
    /**************************************************************************
     Function:       session
     
     Description:   Join screen tells us whether or not two devices are connected
     
     Parameters:     none
     
     Returned:       none
     *************************************************************************/
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state //What connective state are we in?
        {
        case MCSessionState.connected:
            print ("Connected: \(peerID.displayName)")
         //   btnPlayGame.isEnabled = true //KEEP
        case MCSessionState.connecting:
            print ("Connecting: \(peerID.displayName)")
         //   btnPlayGame.isEnabled = false //Cant play game until connected with another player // KEEP
        case MCSessionState.notConnected:
            print ("Not Connected: \(peerID.displayName)")
           // btnPlayGame.isEnabled = false //Cant play game until connected with another player //KEEP
        }
        
    }
    
    /**************************************************************************
     Function:       sendImage
     
     Description:   Trying to send something to other peers
     
     Parameters:    img: UIImage
     
     Returned:       none
     *************************************************************************/
    func sendImage(img: UIImage) {
        if multipeerSession.session.connectedPeers.count > 0 {
            if let imageData = img.pngData() {
                do {
                    try multipeerSession.session.send(imageData, toPeers: multipeerSession.session.connectedPeers, with: .reliable)
                } catch let error as NSError {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    /**************************************************************************
     Function:       session
     
     Description:
     
     Parameters:    _ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID
     
     Returned:       none
     *************************************************************************/
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if UIImage(data: data) != nil {
            DispatchQueue.main.async { //[unowned self] in
                // do something with the image
            }
        }
    }
    /**************************************************************************
     Function:       session
     
     Description:
     
     Parameters:     _ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID
     
     Returned:       none
     *************************************************************************/
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    /**************************************************************************
     Function:       session
     
     Description:
     
     Parameters:     _ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress
     
     Returned:       none
     *************************************************************************/
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    /**************************************************************************
     Function:       session
     
     Description:
     
     Parameters:     _ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?
     
     Returned:       none
     *************************************************************************/
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    /**************************************************************************
     Function:       browserViewControllerDidFinish
     
     Description:   Have to have it
     
     Parameters:    _ browserViewController: MCBrowserViewController) {
     dismiss(animated: true, completion: nil
     
     Returned:       none
     *************************************************************************/
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    /**************************************************************************
     Function:       browserViewControllerWasCancelled
     
     Description:   Have to have it
     
     Parameters:    _ browserViewController: MCBrowserViewController) {
     dismiss(animated: true, completion: nil
     
     Returned:       none
     *************************************************************************/
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /**************************************************************************
     Function:       back
     
     Description:    goes to last screen when back button hit,
                     breaks advertising connections
     
     Parameters:     _sender: Any
     
     Returned:       none
     *************************************************************************/
    @IBAction func btnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "sgBack", sender: self)
        //session.disconnect()
        if (self.hosting == true)
        {
            self.advertiser.stop()
        }
        
    }
    
    }

