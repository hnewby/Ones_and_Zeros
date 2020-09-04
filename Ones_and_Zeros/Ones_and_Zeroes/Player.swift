//
//  Player.swift
//  Ones_and_Zeroes
//
//  Created by Hannah Newby-Smith on 11/19/18.
//  Copyright © 2018 Jonah Pincetich. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import simd

class Player: Person {
    var gameDeck: Deck
    var hand : Hand
//    let HAND_SIZE = 5
//    var currentHand = [Card] ()
//    var cardsInHand : Int
    //var decks = [Deck] ()
    //var playerID: Int
    var turn : Bool
    //var acct: Account
    //var host : boolean_t

    override init ()
    {
        turn = false
        gameDeck = Deck ()
        //currentHand = [Card] ()
        //cardsInHand = 0
        hand = Hand ()
       // acct = Account.globalAcct()
    }
    func setGameDeck (theDeck : Deck) {
        gameDeck.fillDeck(prevDeck: theDeck)
    }
    func setUpPlayer (theDeck : Deck, theHand: Hand, isTurn : Bool) {
        gameDeck = theDeck
        hand = theHand
        turn = isTurn
    }
}
