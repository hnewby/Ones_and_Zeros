//
//  ViewCreateAccount.swift
//  Ones_and_Zeroes
//
//  Created by Hannah Newby-Smith on 1/18/19.
//  Copyright © 2019 Jonah Pincetich. All rights reserved.
//

import UIKit

class ViewCreateAccount: UIViewController {

    // Variables
    var un:String = "NA"
    var passwd:String = "NA"
    var fname:String = "NA"
    var lname:String = "NA"
    var email:String = "NA"
    
    // Textfields
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    @IBOutlet weak var btnSubmit: UIButton!
    /**************************************************************************
     Function:       viewDidLoad
     
     Description:    Called when screen loads
     
     Parameters:     none
     
     Returned:       none
     *************************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()

        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "circut.jpg")?.draw(in: self.view.bounds)
        
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        btnSubmit.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
    }
    /**************************************************************************
     Function:       textFieldShouldReturn
     
     Description:    When done is pressed on keyboard, keyboard minimizes
     
     Parameters:     (_ textField: UITextField
     
     Returned:       Bool
     *************************************************************************/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /**************************************************************************
     Function:       btnSubmitUser
     
     Description:    On click try to submit new user to db
     
     Parameters:    _sender: Any
     
     Returned:       none
     *************************************************************************/
    @IBAction func btnSubmitUser(_ sender: Any) {
        if (checkAllEmpty())
        {
            //It takes the title and the alert message and prefferred style
            let alertController = UIAlertController(title: "Empty Field", message: "One of more field is empty.", preferredStyle: .alert)

            //then we create a default action for the alert...
            //It is actually a button and we have given the button text style and handler
            //currently handler is nil as we are not specifying any handler
            let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)

            //now we are adding the default action to our alertcontroller
            alertController.addAction(defaultAction)

            //and finally presenting our alert using this method
            present(alertController, animated: true, completion: nil)
        } else {
            // Do work
            insertUser()
        }
    }
    
    
    /**************************************************************************
     Function:       checkEmpty
     
     Description:    Check if any string is empty
     
     Parameters:     String
     
     Returned:       Bool
     *************************************************************************/
    func checkEmpty (str: String) -> Bool
    {
        if (str.isEmpty)
        {
            return true;
        } else {
            return false;
        }
    }
    /**************************************************************************
     Function:       checkAllEmpty
     
     Description:    Check if any user credentials are empty
     
     Parameters:     none
     
     Returned:       Bool
     *************************************************************************/
    func checkAllEmpty () -> Bool
    {
        if (checkEmpty (str: FirstName.text!) || checkEmpty(str: LastName.text!) || checkEmpty(str: Email.text!) ||
         checkEmpty(str: Username.text!) || checkEmpty(str: Password.text!))
        {
            return true;
        } else {
            return false;
        }
    }
    /**************************************************************************
     Function:       insertUser
     
     Description:    Puts together request for connecting to php
     
     Parameters:     none
     
     Returned:       none
     *************************************************************************/
    func insertUser ()
    {
        let un = Username.text
        let passwd = Password.text
        let fname = FirstName.text
        let lname = LastName.text
        let email = Email.text
        let requestURL: URL = URL(string: (IPaddr + "/php/Ones_and_Zeros/PHP/addUser.php"))!
        //let requestURL: URL = URL(string: "http://10.2.5.162:8080/php/Ones_and_Zeros/PHP/addUser.php")!
        //let requestURL: URL = URL(string: "http://127.0.0.1/PHP/addUser.php")!
        
        let request = NSMutableURLRequest (url: requestURL as URL)
        request.httpMethod = "POST"
        let postParam = "username="+un!+"&Email="+email!+"&password="+passwd!+"&FName="+fname!+"&LName="+lname!
        print(postParam)
        
        request.httpBody = postParam.data(using: String.Encoding.utf8);
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if error != nil{
                print(error!)
               // print("error\(String(describing: error))")
                return;
            }else{
                // You can print out response object
                print ("worked")
               // print(response!)
                //print ("Response\(String(describing: response))")
               let datastring = NSString(data: (data ?? nil)!, encoding : String.Encoding.utf8.rawValue)//"data = %@", data!)
                print(datastring!)
               // self.parseUser(data!)
            }
            
        }
        
        task.resume()
    }
   
    
    /**************************************************************************
     Function:       parseUser
     
     Description:    parse feedback from db and php
     
     Parameters:     _data:  Data
     
     Returned:       none
     *************************************************************************/
    func parseUser (_ data:Data)
    {
        do {
            let myJSON =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
        
        //parsing the json
        if let parseJSON = myJSON {
            
            //creating a string
            var msg : String!
            
            //getting the json response
            msg = parseJSON["message"] as! String?
            
            //printing the response
            print(msg)
        
        }
    } catch {
    print(error)
    }
    
}
}




