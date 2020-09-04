//
//  Deck.swift
//  Ones_and_Zeroes
//
//  Created by Hannah Newby-Smith on 1/31/19.
//  Copyright © 2019 Jonah Pincetich. All rights reserved.
//

import Foundation
import UIKit

class Deck : NSObject{
    private var contents : [Card]
    private var numCards: Int
    var name: String
    
    
    
    override init ()
    {
        contents = [Card] ()
        numCards = 0
        name = "NA"
    }
    init (cards: [Card], numCards: Int, name: String)
    {
        self.contents = cards
        self.numCards = numCards
        self.name = name
    }
    
    func downloadSelectedDeckDB (DeckName: String)
    {
        
        var bTaskComplete = false; //want to wait for task to finish before returning from func
        //let requestURL: URL = URL(string: "http://10.0.0.61:8080/php/Ones_and_Zeros/PHP/userAuth.php")!
        let requestURL: URL = URL(string: IPaddr + "/php/Ones_and_Zeros/PHP/getSelectedDeck.php")!
        //let requestURL: URL = URL(string: "http://127.0.0.1/PHP/userAuth.php")!
        
        let request = NSMutableURLRequest (url: requestURL as URL)
        request.httpMethod = "POST" // we are posting vars to php
        let deckName = DeckName
        
        let postParam = "deckName="+deckName//What is the db getting
        request.httpBody = postParam.data(using: String.Encoding.utf8);
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: request as URLRequest) { data, response, error in
        guard let data = data else {
        
        print ("made it")
        print("request failed \(String(describing: error))")
        return
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as? NSArray {
                print ("Got results")
                print (json)

                self.parseSelectedDeck(data, jsonResult: json)
            }
        } catch let parseError {
        print (data)
        print("parsing error: \(parseError)")
        let responseString = String(data: data, encoding: .utf8)
        print("raw response: \(String(describing: responseString))")
        }
        bTaskComplete = true;
        }
        task.resume()
        while (!bTaskComplete)
        {
        //waiting to get result back from json
        }
        //try a wait function

    
    }


    //Func
    func parseSelectedDeck (_ data:Data, jsonResult:NSArray)
    {
        print("Starting to parse Cards from JSON received from Server\n")
       // let deck = Deck ()
        let count = jsonResult.count
        
        numCards = jsonResult[count - 2] as! Int
        name = jsonResult[count - 1] as! String
    
        
        for i in 0 ..< numCards
        {
            var jsonEl: NSDictionary
            jsonEl = jsonResult[i] as! NSDictionary
            contents.append(parseCard(jsonElement: jsonEl))
        }

}



    func shuffleDeck () -> Deck{
        let shuffled = Deck();
        shuffled.name = name
        shuffled.numCards = numCards
        
        for _ in 0 ..< self.contents.count {
            let rand = Int(arc4random_uniform(UInt32(self.contents.count)))
            
            shuffled.contents.append(self.contents[rand])
            
            self.contents.remove(at: rand)
        }
        return shuffled
    }
    
    func fillDeck (prevDeck : Deck) {
        contents = prevDeck.contents
        numCards = prevDeck.numCards
        name = prevDeck.name
    }
    func draw () -> Card {
        var currentCard : Card
        currentCard = contents[numCards - 1]
        numCards = numCards - 1
        return currentCard
    }
    
//    func getAllUsersDecks (username: String)
//    {
//        var bTaskComplete = false; //want to wait for task to finish before returning from func
//        let requestURL: URL = URL(string: "http://127.0.0.1/PHP/getDecksForUser.php")!
//
//        let request = NSMutableURLRequest (url: requestURL as URL)
//        request.httpMethod = "POST" // we are posting vars to php
//        let un = username//getUsername//Username//.text
//
//        let postParam = "username="+un; //What is the db getting
//        request.httpBody = postParam.data(using: String.Encoding.utf8);
//        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
//
//        let task = defaultSession.dataTask(with: request as URLRequest) { data, response, error in
//            guard let data = data else {
//
//                print ("made it")
//                print("request failed \(String(describing: error))")
//                return
//            }
//
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]{
//                    //parseDeck ()
////                    if (json.first?.value as! Int == 1)
////                    {
////
////                        bIsValid = true
////                    } else {
////
////
////
////                        // Password and username dont match system throw error
////                    }
//                }
//            } catch let parseError {
//                print (data)
//                print("parsing error: \(parseError)")
//                let responseString = String(data: data, encoding: .utf8)
//                print("raw response: \(String(describing: responseString))")
//            }
//            bTaskComplete = true;
//        }
//        task.resume()
//        while (!bTaskComplete)
//        {
//            //waiting to get result back from json
//        }
//        //try a wait function
//    }
//
//    func parseDeck (_ data:Data)
//    {
//        print("Starting to parse Cards from JSON received from Server\n")
//
//        var deckOfCards = NSArray()
//
////        do{
////            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
////
////        } catch let error as NSError {
////            print(error)
////
////        }
//
//        var jsonElement = NSDictionary()
//        let cards = NSMutableArray()
//
//        for i in 0 ..< deckOfCards.count
//        {
//
//            jsonElement = deckOfCards[i] as! NSDictionary
//
//            let card = Card()
//
//            //the following insures none of the JsonElement values are nil through optional binding
//                if let deck_id = jsonElement["deck_id"] as? Int,
//               // let deckName = jsonElement["deckName"]
//                let card_id = jsonElement["card_id"] as? String,
//                let name = jsonElement["Name"] as? String,
//                let cardImage = jsonElement["CardImageURL"] as? String,
//                let characterImage = jsonElement["CharacterImageURL"] as? String,
//                let attack = jsonElement["Attack"] as? String,
//                let health = jsonElement["Health"] as? String,
//                let burden = jsonElement["Burden"] as? String
//            {
//
//                card.card_id = Int(card_id)!
//                card.name = name;
//                card.cardImageURL = cardImage
//                card.characterImageURL = characterImage
//                card.attack = Int(attack)!
//                card.health = Int(health)!
//                card.burden = Int(burden)!
//
//                print(card)
//
//            }
//            else{
//                print("Error: Not all parts of Card returned")
//            }
//
//            cards.add(card)
//
//        }
//
////        DispatchQueue.main.async(execute: { () -> Void in
////
////            //self.delegate.itemsDownloaded(items: cards)
////
////        })
//    }
//
//    }
//
}
