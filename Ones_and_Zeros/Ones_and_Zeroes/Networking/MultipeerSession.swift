//
//  MultipeerConnectivity.swift
//  Ones_and_Zeroes
//
//  Created by Hannah Newby-Smith on 12/2/18.
//  Copyright © 2018 Jonah Pincetich. All rights reserved.
//

import MultipeerConnectivity

class MultipeerSession: NSObject {
    
    
    private let peerID = MCPeerID(displayName: UIDevice.current.name) // The current device name 'Jonahs Iphone'
    var session:MCSession! // MultiPeer Session
    private var receivedDataHandler: (Data, MCPeerID) -> Void
    var host: Bool
    
    
    /**************************************************************************
     Function:       init
     
     Description:    Initializer Function
     
     Parameters:    receivedDataHandler
     
     Returned:       Nothing
     *************************************************************************/
    init (receivedDataHandler: @escaping (Data, MCPeerID) -> Void ) {
        self.receivedDataHandler = receivedDataHandler
        self.host = false
        
        super.init()

        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
       // session.disconnect()
        
    }
    
    /**************************************************************************
     Function:       setReceivedDataHandler
     
     Description:    Sets a new receivedDataHandler function
     
     Parameters:    receivedDataHandler
     
     Returned:       Nothing
     *************************************************************************/
    func setReceivedDataHandler(receivedDataHandler: @escaping (Data, MCPeerID) -> Void ) {
        self.receivedDataHandler = receivedDataHandler
        
    }
    
    /**************************************************************************
     Function:       getSession
     
     Description:    returns active session
     
     Parameters:     none
     
     Returned:       MCSession
     *************************************************************************/
    func getSession () -> MCSession
    {
        return session
    }
    
    
    /**************************************************************************
     Function:      sendToAllPeers
     
     Description:    send data to all connected peers on session
     
     Parameters:     _data: Data
     
     Returned:       none
     *************************************************************************/
    func sendToAllPeers(_ data: Data) {
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("error sending data to peers: \(error.localizedDescription)")
        }
    }
   
    var connectedPeers: [MCPeerID] {
        return session.connectedPeers // returning all connected peers on current session
    }
}




extension MultipeerSession: MCSessionDelegate {

    /**************************************************************************
     Function:       session
     
     Description:
     
     Parameters:     _ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState
     
     Returned:       none
     *************************************************************************/
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        // not used
    }
    /**************************************************************************
     Function:       session
     
     Description:
     
     Parameters:     _ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
     receivedDataHandler(data, peerID
     
     Returned:       none
     *************************************************************************/
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        receivedDataHandler(data, peerID)
    }
    /**************************************************************************
     Function:       session
     
     Description:
     
     Parameters:     _ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID
     
     Returned:       none
     *************************************************************************/
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        fatalError("This service does not send/receive streams.")
    }
    /**************************************************************************
     Function:       session
     
     Description:
     
     Parameters:     _ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress
     
     Returned:       none
     *************************************************************************/
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        fatalError("This service does not send/receive resources.")
    }
    /**************************************************************************
     Function:       session
     
     Description:
     
     Parameters:     _ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?
     
     Returned:       none
     *************************************************************************/
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        fatalError("This service does not send/receive resources.")
    }

}
