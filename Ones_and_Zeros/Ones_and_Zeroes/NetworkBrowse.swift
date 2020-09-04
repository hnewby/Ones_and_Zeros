//
//  NetworkBrowse.swift
//  Ones_and_Zeroes
//
//  Created by Hannah Newby-Smith on 11/19/18.
//  Copyright © 2018 Jonah Pincetich. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class NetworkBrowse : NSObject {
     private let serviceBrowser : MCNearbyServiceBrowser //Browsing for Connection
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
      private let OZServiceType = "ones_zeroes_service"
    
    override init() {
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType:
            OZServiceType)
        
        super.init()
        
        self.serviceBrowser.delegate = self 
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        
        self.serviceBrowser.stopBrowsingForPeers()
    }
}
extension NetworkBrowse : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
    }
}
