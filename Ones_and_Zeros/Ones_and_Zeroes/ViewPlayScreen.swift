//
//  ViewPlayScreen.swift
//  Ones_and_Zeroes
//
//  Created by Hannah Newby-Smith on 11/7/18.
//  Copyright © 2018 Jonah Pincetich. All rights reserved.
//

import UIKit

class ViewPlayScreen: UIViewController {

    @IBOutlet weak var btnPlay: UIButton!
    
    /**************************************************************************
     Function:       viewDidLoad
     
     Description:    Called when screen loads
     
     Parameters:     none
     
     Returned:       none
     *************************************************************************/
   override func viewDidLoad() {
        super.viewDidLoad()
     btnPlay.layer.cornerRadius = 15
    }
    
    /**************************************************************************
     Function:       btnPlayToConn
     
     Description:    Called when play button is hit. Calls seague to move to
                     next screen
     
     Parameters:     sender: Any
     
     Returned:       none
     *************************************************************************/
    @IBAction func btnPlayToConn(_ sender: Any) {
        self.performSegue(withIdentifier: "sgPlayToConn", sender: self)
        print ("Button Pressed")
        
    }
}

