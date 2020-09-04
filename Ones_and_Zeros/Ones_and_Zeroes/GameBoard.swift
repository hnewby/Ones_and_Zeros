//
//  ARObj.swift
//  Ones_and_Zeroes
//
//  Created by Jonah Pincetich on 1/30/19.
//  Copyright © 2019 Jonah Pincetich. All rights reserved.
//

import Foundation
import ARKit

/**************************************************************************
 Class:        GameBoard
 
 Description:
 
 Inherits from: nothing
 *************************************************************************/
class GameBoard  {
    
    var anchor: ARAnchor!
    var worldPosition : SCNVector3!
    var topLocation : Float!
    var referenceNode : SCNReferenceNode! = nil
    var urlPath : String = IPaddr + "/php/Ones_and_Zeros/scns/gameBoardReal.scn"
    var urlToObject: URL!
    var boardPlaced : Bool = false
    
    /**************************************************************************
     Function:      initialize
     
     Description:   Initializes all the variables in GameBoard
     
     Parameters:    position: simd_float4x4 - position in the view that
                        the object is to be anchored to
                    scnURL: URL - The url of the object
     
     Returned:      Nothing
     *************************************************************************/
    func initialize(position: ARHitTestResult?, scn: ARSCNView) {
        //print("initialize GameBoard called.")
        if (boardPlaced)
        {
            //Removes previous board
            scn.session.remove(anchor: anchor)
        }
        else
        {
            //URL initialization
            urlToObject = URL(string: urlPath)!
        }
        
        //anchor initialized
        if (nil != position)
        {
            anchor = ARAnchor(name: "GameBoard", transform: position!.worldTransform)
            scn.session.add(anchor: anchor)
            boardPlaced = true;
        }
        else
        {
            anchor = nil
        }
        
    }
    
    /**************************************************************************
     Function:      getNode
     
     Description:   downloads the board from the database into a refernce
                        node which gets returned
     
     Parameters:    None
     
     Returned:      SCNReferenceNode - Where the Board has been placed
     *************************************************************************/
    func getNode ()  -> SCNNode {
        //print("getNode() called.")
        if (nil == referenceNode)
        {
            referenceNode = SCNReferenceNode(url: urlToObject)!
        }
        referenceNode.load()
        
        return referenceNode
    }
    
    /**************************************************************************
     Function:      share
     
     Description:   Sends the Board to all peers on the passed in multipeer object
     
     Parameters:    session - The multipeeer session to send the board to
     
     Returned:      Nothing
     *************************************************************************/
    func share (session: MultipeerSession) {
         print("gameBoard.share() called.")
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: self.anchor, requiringSecureCoding: true)
            else { fatalError("can't encode gameBoard to send to peers") }
        session.sendToAllPeers(data)
    }
    
    
    /**************************************************************************
     Function:      decode
     
     Description:   Attempts to decode a new anchor for the gameBoard from the passed in data object
     
     Parameters:    None
     
     Returned:      True if gameboard was decoded, false otherwise
     *************************************************************************/
    func decodeAnchor (data : Data) -> Bool {
        var decodeStatus : Bool = false
        
        do
        {
            let receivedAnchor = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARAnchor.self, from: data)
            if nil != receivedAnchor
            {
                self.anchor = receivedAnchor
                decodeStatus = true
            }
            else
            {
                decodeStatus = false
            }
        }
        catch
        {
            decodeStatus = false
        }
        
        return decodeStatus
    }
    
}
