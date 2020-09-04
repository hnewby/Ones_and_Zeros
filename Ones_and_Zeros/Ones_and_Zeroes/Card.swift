////
////  Card.swift
////  Ones_and_Zeroes
////
////  Created by Jonah Pincetich on 12/3/18.
////  Copyright © 2018 Jonah Pincetich. All rights reserved.
////
//
//
//import Foundation
//



import Foundation
import UIKit

class Card : NSObject{
    
    //properties
    
    var card_id: Int
    var name: String
    var cardSCNImageURL: String
    var cardStaticImage: String
    var characterImageURL: String
    var attack: Int
    var health: Int
    var burden: Int
    var element:Element
    
    //constructor
    
    override init()
    {
        card_id = -1
        name = "Empty Card"
        attack = -1
        health = -1
        burden = -1
        cardSCNImageURL = "Error no card"
        cardStaticImage = "Error: No Card Image"
        characterImageURL = "Error: No Character Image"
        element = Element ()
    }
    
    //construct with @card_id, @name, @cardImage, @attack, @characterImage, @health, and @burden parameters
    
    init(card_id: Int, name: String, cardImage: String, staticIMG: String, characterImage: String, attack: Int, health: Int, burden: Int, element : Element) {
        
        self.card_id = card_id
        self.name = name
        self.cardSCNImageURL = cardImage
        self.cardStaticImage = staticIMG
        self.characterImageURL = characterImage
        self.attack = attack
        self.health = health
        self.burden = burden
        self.element = element
        
    }
    
    
    //A call to print(cardModel) outputs like so:
    override var description: String {
        return "card_id: \(String(describing: card_id)), name: \(String(describing: name)), cardImageURL: \(String(describing: cardSCNImageURL)), characterImageURL: \(String(describing: characterImageURL)), attack: \(String(describing: attack)), health: \(String(describing: health)), burden: \(String(describing: burden))"
        
    }
    
    
    func getImage () -> UIImage {
        let url = NSURL(string:self.cardStaticImage)
        let data = NSData(contentsOf:url! as URL)
        return UIImage(data: data! as Data)!
    }
}

    func parseCard(jsonElement:NSDictionary) -> Card{
       
        
        var card = Card()
            if let card_id = jsonElement["card_id"] as? String,
                let name = jsonElement["Name"] as? String,
                let cardImage = jsonElement["CardImageSCN_URL"] as? String,
                let cardStatic = jsonElement["CardImageStatic_URL"] as? String,
                let characterImage = jsonElement["CharacterImageURL"] as? String,
                let attack = jsonElement["Attack"] as? String,
                let health = jsonElement["Health"] as? String,
                let burden = jsonElement["Burden"] as? String
            {

                card.card_id = Int(card_id)!
                card.name = name;
                card.cardSCNImageURL = cardImage
                card.cardStaticImage = cardStatic
                card.characterImageURL = characterImage
                card.attack = Int(attack)!
                card.health = Int(health)!
                card.burden = Int(burden)!

                print(card)

            }
            else{
                print("Error: Not all parts of Card returned")
            }

           //cards.add(card)

       // }

        
        return card
        //return card
    }

