//
//  Hand.swift
//  Ones_and_Zeroes
//
//  Created by Hannah Newby-Smith on 2/28/19.
//  Copyright © 2019 Jonah Pincetich. All rights reserved.
//

import Foundation

class Hand {
    let HAND_SIZE = 5
    var currentHand : [Card]
    var cardsInHand : Int
    
    init () {
        currentHand = [Card]()
        cardsInHand = 0
    }
    /**************************************************************************
     Function:       fillHandToStart
     
     Description:    Make initial hand for beginning of game
     
     Parameters:     theDeck - game deck playing with
     
     Returned:       none
     *************************************************************************/
    func fillHandToStart (theDeck : Deck) {
        for _ in 0..<HAND_SIZE {
            var card : Card
            card = theDeck.draw()
            currentHand.append(card)
        }
    }
    
    /**************************************************************************
     Function:       draw
     
     Description:    draw from game deck into hand
     
     Parameters:     theDeck - current game deck
     
     Returned:       none
     *************************************************************************/
    func draw (theDeck : Deck) {
    
    }
    
    func currentCard(index :Int) -> Card {
        return currentHand[index]
    }
    func theHand () -> [Card]{
        return currentHand
    }
    func cardInHand (newCard : Card) {
//        for i in 0 ..< currentHand.count
//        {
//            if currentHand[i]
//        }
    }
}

