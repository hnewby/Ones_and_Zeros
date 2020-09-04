//
//  ViewLogIn.swift
//  Ones_and_Zeroes
//
//  Created by Hannah Newby-Smith on 12/19/18.
//  Copyright © 2018 Jonah Pincetich. All rights reserved.
//

import UIKit

public var IPaddr = "http://10.2.5.162:8080"

class ViewLogIn: UIViewController, UITextFieldDelegate {
    
    //Variables in this class
    var un:String = "NA"
    var password:String = "NA"
  
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnCreate: UIButton!
    // Variables from screen -- i.e the textfield on the screen is called 'Username'
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    /**************************************************************************
     Function:       viewDidLoad
     
     Description:    Called when screen loads
     
     Parameters:     none
     
     Returned:       none
     *************************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
         Username.delegate = self
        Password.delegate = self

        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "circut.jpg")?.draw(in: self.view.bounds)
        
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
         btnLogin.layer.cornerRadius = 15
         btnCreate.layer.cornerRadius = 15
        // Do any additional setup after loading the view, typically from a nib.
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
    /**************************************************************************
     Function:       btnCreateUser
     
     Description:    Called when create user button is hit. Calls seague to move to
     next screen
     
     Parameters:     sender: Any
     
     Returned:       none
     *************************************************************************/
    @IBAction func btnCreateUser(_ sender: Any) {
        self.performSegue(withIdentifier: "sgCreateUser", sender: self)
    }
    /**************************************************************************
     Function:       btnLogIn
     
     Description:    Called when Login button is hit. Calls seague to move to
     next screen
     
     Parameters:     sender: Any
     
     Returned:       none
     *************************************************************************/
    @IBAction func btnLogIn(_ sender: Any) {
        let acct = Account.globalAcct ()
        //let per = Person ()
        
        if (acct.checkCredentials(Username: Username.text!, Password: Password.text!) == true)
        {
            acct.getAcctFromDB(Username: Username.text!)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MenuPage") as! MenuPageViewController
            self.present(controller, animated: true, completion: nil)
           // acct.getPersonsFromDB(username: Username.text!)
        }
        else
        {
            // create the alert
            let alert = UIAlertController(title: "Incorrect data", message: "Incorrect username or password", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                let vc = ViewLogIn ()
//                self.present(vc, animated: true, completion: nil)
                self.Username.text = ""
                self.Password.text = ""
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }

}


