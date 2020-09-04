//
//  GameLogic.swift
//  Ones_and_Zeroes
//
//  Created by Hannah Newby-Smith on 2/25/19.
//  Copyright © 2019 Jonah Pincetich. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class GameLogic {
    var pThePlayer: Player
    //var gameDeck : Deck
    //var hand : Hand
    var multipeerSession : MultipeerSession!
    //var turn : Bool
    //var cardsInHand : int
   // Board *pTheBoard
 
    init () {
        pThePlayer = Player ()
        //gameDeck = Deck ()
        //hand = Hand()
        //self.multipeerSession = multipeerSession
        //turn = false
       // hand = [Card](repeating: Card, count: 5)
    }
    
//    func setGameDeck (theDeck: Deck){
//        gameDeck = theDeck
//    }
    
    func startGame () {
        print (pThePlayer.gameDeck)
        pThePlayer.gameDeck = pThePlayer.gameDeck.shuffleDeck();
        print(pThePlayer.gameDeck)
        pThePlayer.hand.fillHandToStart(theDeck: pThePlayer.gameDeck)
        print (pThePlayer.hand)
        if (multipeerSession.host)
        {
            pThePlayer.turn = true;
        }
        
        
        
    }
//    func getGameDeck () -> Deck {
//        return gameDeck
//    }
//    func draw () {
//        var newCard : Card
//        newCard = gameDeck.draw()
//
//    }
    
    
}
