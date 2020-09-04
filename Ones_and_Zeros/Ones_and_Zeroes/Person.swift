//
//  Person.swift
//  Ones_and_Zeroes
//
//  Created by Hannah Newby-Smith on 11/19/18.
//  Copyright © 2018 Jonah Pincetich. All rights reserved.
//

import Foundation

class Person
{
    var Decks = [Deck] ()// ()
    var acct =  Account ()
    func Person ()
    {
       
    }
    
    func getPersonsFromDB ()//username: String)
    {
        //let requestURL: URL = URL(string: "http://127.0.0.1/PHP/getDecksForUser.php")!
        let requestURL: URL = URL(string: IPaddr + "/php/Ones_and_Zeros/PHP/getDecksForUser.php")!
        
        let request = NSMutableURLRequest (url: requestURL as URL)
        request.httpMethod = "POST" // we are posting vars to php
        let un = acct.getUsername()//username//.text
        //let password = Password//.text
        
        let postParam = "username="+un//+"&password="+password; //What is the db getting
        request.httpBody = postParam.data(using: String.Encoding.utf8);
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data else {
                print ("made it")
                print("request failed \(String(describing: error))")
                return
            }
            
            do {
                //parses ()
                if let json = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as? NSArray{
                    print ("in json")
                    //self.parses(data)
//                    if (json.first?.value as! Int == 1)
//                    {
//                        print ("Got Values")
//                        //bIsValid = true
//                    } else {
//                        // Password and username dont match system throw error
//                    }
                }
            } catch let parseError {
                print (data)
                print("parsing error: \(parseError)")
                let responseString = String(data: data, encoding: .utf8)
                print("raw response: \(String(describing: responseString))")
            }
            
        }
        task.resume()
        sleep (3)
    }
    
    
//    func parses(_ data:Data) {
//        print("Starting to parse decks from JSON received from Server\n")
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
//        let decks = NSMutableArray()
//
//        for i in 0 ..< jsonResult.count
//        {
//
//            jsonElement = jsonResult[i] as! NSDictionary
//
//            let deck = Deck()
//
//            //the following insures none of the JsonElement values are nil through optional binding
//            if let account_id = jsonElement["account_id"] as? String,
//                let deck_id = jsonElement["deck_id"] as? Int
////                let name = jsonElement["Name"] as? String,
////                let deckImage = jsonElement["deckImageURL"] as? String,
////                let characterImage = jsonElement["CharacterImageURL"] as? String,
////                let attack = jsonElement["Attack"] as? String,
////                let health = jsonElement["Health"] as? String,
////                let burden = jsonElement["Burden"] as? String
//            {
//
//                deck.deck_id = Int(deck_id)!
//                deck.name = name;
//                deck.deckImageURL = deckImage
//                deck.characterImageURL = characterImage
//                deck.attack = Int(attack)!
//                deck.health = Int(health)!
//                deck.burden = Int(burden)!
//
//                print(deck)
//
//            }
//            else{
//                print("Error: Not all parts of deck returned")
//            }
//
//            decks.add(deck)
//
//        }
//
//        DispatchQueue.main.async(execute: { () -> Void in
//
//            self.delegate.itemsDownloaded(items: decks)
//
//        })
//    }
//
//
//    }
}
