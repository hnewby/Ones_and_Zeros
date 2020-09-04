////
////  CardID1Query.swift
////  Ones_and_Zeroes
////
////  Created by Jonah Pincetich on 12/3/18.
////  Copyright © 2018 Jonah Pincetich. All rights reserved.
////
//
//import Foundation
//
//protocol CardID1QueryProtocol: class {
//    func itemsDownloaded(items: NSArray)
//}
//
//
//class CardID1Query: NSObject, URLSessionDataDelegate {
//    
//    //properties
//    
//    weak var delegate: CardID1QueryProtocol!
//    
//    //Thiis query only returns the card where card_id = 1
//    let urlPath = "http://64.59.233.250/PHP/cardID1Query.php"
//    
//    //Gets called by ViewDidLoad()
//    func downloadCards() {
//        
//        let url: URL = URL(string: urlPath)!
//        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
//        
//        let task = defaultSession.dataTask(with: url) { (data, response, error) in
//            
//            if error != nil {
//                print("Failed to download data")
//            }else {
//                print("Data downloaded\n")
//                self.parseCardsJSON(data!)
//            }
//            
//        }
//        
//        task.resume()
//    }
//    
//    //Gets called by downloadCards()
//    func parseCardsJSON(_ data:Data) {
//        print("Starting to parse Cards from JSON received from Server\n")
//        
//        var jsonResult = NSArray()
//        
//        do{
//            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
//            
//        } catch let error as NSError {
//            print(error)
//            
//        }
//        
//        var jsonElement = NSDictionary()
//        let cards = NSMutableArray()
//        
//        for i in 0 ..< jsonResult.count
//        {
//            
//            jsonElement = jsonResult[i] as! NSDictionary
//            
//            let card = Card()
//            
//            //the following insures none of the JsonElement values are nil through optional binding
//            if let card_id = jsonElement["card_id"] as? String,
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
//           cards.add(card)
//            
//        }
//        
//        DispatchQueue.main.async(execute: { () -> Void in
//            
//            self.delegate.itemsDownloaded(items: cards)
//            
//        })
//    }
//    
//    
//    
//}
