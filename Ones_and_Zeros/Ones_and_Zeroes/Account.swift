//
//  Account.swift
//  Ones_and_Zeroes
//
//  Created by Hannah Newby-Smith on 1/7/19.
//  Copyright © 2019 Jonah Pincetich. All rights reserved.
//

import UIKit

class Account: NSObject {
    //properties
    
    var account_id: Int
    var username: String
    var FName: String
    var LName: String
    var NumCoins: Int
    var Email: String
    
    static var sharedAccount = Account()
    override init()
    {
        account_id = -1
        username = "Empty account"
        FName = "NA"
        LName = "NA"
        NumCoins = -1
        Email = "NA"
    }
    
    init(account_id: Int, username: String, FName: String, LName: String, NumCoins: Int, Email: String) {
        
        self.account_id = account_id
        self.username = username
        self.FName = FName
        self.LName = LName
        self.NumCoins = NumCoins
        self.Email = Email
        
    }
    
    class func globalAcct () -> Account {
        return sharedAccount
    }
    
    func setShared (shared: Account)
    {
        Account.sharedAccount = shared
    }
    //A call to print(accountModel) outputs like so:
    override var description: String {
        return "account_id: \(String(describing: account_id)), username: \(String(describing: username)), FName: \(String(describing: FName)), LName: \(String(describing: LName)), NumCoins: \(String(describing: NumCoins)), Email: \(String(describing: Email))"
    }
    
    func getUsername () -> String {
        return self.username
    }
    
    /**************************************************************************
     Function:       checkCredentials
     
     Description:    Check if username and password matches a user in db
     
     Parameters:     none
     
     Returned:       none
     *************************************************************************/
    func checkCredentials (Username:String, Password:String) -> Bool
    {
        var bIsValid = false
        var bTaskComplete = false; //want to wait for task to finish before returning from func
        let requestURL: URL = URL(string: IPaddr + "/php/Ones_and_Zeros/PHP/userAuth.php")!
  
        
        let request = NSMutableURLRequest (url: requestURL as URL)
        request.httpMethod = "POST" // we are posting vars to php
        let un = Username//.text
        let password = Password//.text
        
        let postParam = "username="+un+"&password="+password; //What is the db getting
        request.httpBody = postParam.data(using: String.Encoding.utf8);
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data else {
                
                print ("made it")
                print("request failed \(String(describing: error))")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]{
                    if (json.first?.value as! Int == 1)
                    {
                       
                        bIsValid = true
                    } else {
                        
              
                        
                        // Password and username dont match system throw error
                    }
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
        return bIsValid
       
    }
    /**************************************************************************
     Function:       getAcctFromDB
     
     Description:    create post request to database to get account info
                     after already logged in
     
     Parameters:     username - the username that is currently logged in
     
     Returned:       none
     *************************************************************************/
    func getAcctFromDB (Username:String)
    {
        var bTaskComplete = false; //want to wait for task to finish before returning from func
        let requestURL: URL = URL(string: (IPaddr + "/php/Ones_and_Zeros/PHP/getAccount.php"))!
        
        let request = NSMutableURLRequest (url: requestURL as URL)
        request.httpMethod = "POST" // we are posting vars to php
        let un = Username//.text
        
        let postParam = "username="+un; //What is the db getting
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
                  self.parseAccount(data, jsonResult: json)
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
            // need this because of threads
        }
    }
    
    
    
    /**************************************************************************
     Function:       parseAccount
     
     Description:    Gotten account from db now parse into swift vars
     
     Parameters:     data - data from db
                     jsonResult - result json gave from db
     
     Returned:       none
     *************************************************************************/
    func parseAccount (_ data:Data, jsonResult:NSArray)
    {
        print("Starting to parse Accounts from JSON received from Server\n")
        
        var jsonElement = NSDictionary()
        print (jsonResult.count)
        for i in 0 ..< jsonResult.count
        {
            jsonElement = jsonResult[i] as! NSDictionary
            
            let acct = Account ()
            //the following insures none of the JsonElement values are nil through optional binding
            if  let account_id = jsonElement["account_id"] as? String,
                let username = jsonElement["username"] as? String,
                let firstName = jsonElement["FName"] as? String,
                let lastName = jsonElement["LName"] as? String,
                let numCoins = jsonElement["NumCoins"] as? String,
                let email = jsonElement["EMail"] as? String
            {
                acct.account_id = Int(account_id)!
                acct.username = username
                acct.FName = firstName
                acct.LName = lastName
                acct.NumCoins = Int(numCoins)!
                acct.Email = email
                
                setShared(shared: acct)
            }else{
                print("Error: Not all parts of Account returned")
            }
        }
        
    }}
