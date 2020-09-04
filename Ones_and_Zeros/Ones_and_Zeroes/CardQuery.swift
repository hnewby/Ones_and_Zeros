////
////  CardQuery.swift
////  Ones_and_Zeroes
////
////  Created by Hannah Newby-Smith on 1/7/19.
////  Copyright © 2019 Jonah Pincetich. All rights reserved.
////
//
//import UIKit
//
//class CardQuery: NSObject {
//
//    func checkCredentials ()
//    {
//        let requestURL: URL = URL(string: "http://64.59.233.250/PHP/login.php")!
//
//        var request:NSMutableURLRequest = NSMutableURLRequest(url:requestURL as URL)
//        request.httpMethod = "POST"
//        let un = Username.text
//        let password = Password.text
//
//        let postParam = "username="+un!+"password="+password!;
//
//
//        request.httpBody = postParam.data(using: String.Encoding.utf8);
//        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
//
//
//
//        let task = defaultSession.dataTask(with: requestURL) { (data, response, error) in
//
//            if error != nil{
//                print("error")
//                return;
//            }else{
//                // You can print out response object
//                print ("worked");
//            }
//
//        }
//
//        task.resume()
//
//
//        //so I can see func working
//        print ("Button Pressed")
//    }
//
//    func parseUser (_data:Data)
//    {
//
//    }
//
//}
