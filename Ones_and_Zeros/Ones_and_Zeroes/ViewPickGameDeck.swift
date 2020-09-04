//
//  ViewPickGameDeck.swift
//  Ones_and_Zeroes
//
//  Created by Hannah Newby-Smith on 2/8/19.
//  Copyright © 2019 Jonah Pincetich. All rights reserved.
//

import UIKit
import Foundation

class ViewPickGameDeck: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

   
    @IBOutlet weak var btnCheckDB: UIButton!
    @IBOutlet weak var tableOfDecks: UITableView!
    var acct = Account.globalAcct()
    var decks = [Deck] ()
    var multipeerSession: MultipeerSession!
    var selectedDeck = Deck()
    //let cell : DeckCell
   
    let requestURL: URL = URL(string: (IPaddr + "/php/Ones_and_Zeros/PHP/getAllDeckNames.php"))!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableOfDecks.delegate = self
        self.tableOfDecks.dataSource = self
//        UIGraphicsBeginImageContext(self.view.frame.size)
//        UIImage(named: "circut.jpg")?.draw(in: self.view.bounds)
//        
//        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        
//        UIGraphicsEndImageContext()
//        
//        self.view.backgroundColor = UIColor(patternImage: image)
//        
       downloadJsonDeck(Username: acct.getUsername())
    }
    
    
    func downloadJsonDeck (Username: String)
    {
        let request = NSMutableURLRequest (url: requestURL as URL)
        request.httpMethod = "POST" // we are posting vars to php
        let un = Username//.text
        print ("username giving to deck:")
        print (un)
        let postParam = "username="+un
        request.httpBody = postParam.data(using: String.Encoding.utf8);
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        
        let task = defaultSession.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data else {
                
                print ("Failed to download")
                print("request failed \(String(describing: error))")
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as? NSArray {
                    print ("Got results")
                    print (json)
                    
                    self.parseJsonToNames(data, jsonResult: json)
                }
            } catch let parseError {
                print ("Something wrong after downloaded")
               // print (data)
                print("parsing error: \(parseError)")
                let responseString = String(data: data, encoding: .utf8)
                print("raw response: \(String(describing: responseString))")
            }
        }
            
            task.resume()
        print ("Task start")
    }
    // Parse
    func parseJsonToNames (_ data:Data, jsonResult:NSArray)
    {
        print("Starting to parse Decks from JSON received from Server\n")
        
       // var jsonResult = NSArray()
        var jsonElement = NSDictionary()
        //let decks = NSMutableArray()
        print (jsonResult.count)
        for i in 0 ..< jsonResult.count
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            let deck = Deck ()
            //let decksDisplay = NSMutableArray()
            
            //the following insures none of the JsonElement values are nil through optional binding
            if let name = jsonElement["Name"] as? String
            {
                deck.name = name;
                print(deck.name)
                decks.append(deck)
                
                DispatchQueue.main.async {
                    
                   
                    self.tableOfDecks.reloadData()
                }
                
            }else{
                print("Error: Not all parts of Deck returned")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DeckCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DeckCell  else {
            fatalError("The dequeued cell is not an instance ofDeckCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        cell.textLabel?.text = self.decks[indexPath.row].name
        
        return cell
    
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeckCell", for: indexPath) as? DeckCell  else {
            fatalError("The dequeued cell is not an instance ofDeckCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        cell.textLabel?.text = self.decks[indexPath.row].name
        print ("selected")
        print(cell.textLabel?.text! as Any)
        selectedDeck.downloadSelectedDeckDB(DeckName: self.decks[indexPath.row].name)
    }
    @IBAction func btnPlayAR(_ sender: Any) {
         self.performSegue(withIdentifier: "sgPlayAR", sender: self)
    }
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "sgBackToConn", sender: self)
        
    }
    
    /**************************************************************************
     Function:       prepare
     
     Description:    Called when a segue is about to be called (When the view is about to change)
     
     Parameters:
     
     Returned:       Nothing
     *************************************************************************/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ViewControllerAR = segue.destination as? ViewControllerAR {
            ViewControllerAR.multipeerSession = self.multipeerSession
            ViewControllerAR.gameDeck = self.selectedDeck
            //give selected deck to game logic //not sure this will work how I think
        }
    }

}
