//
//  ViewLoadingScreenViewController.swift
//  Ones_and_Zeroes
//
//  Created by Hannah Newby-Smith on 12/2/18.
//  Copyright © 2018 Jonah Pincetich. All rights reserved.
//

import UIKit
import Foundation

class ViewLoadingScreen: UIViewController {//}, CardID1QueryProtocol {


    /**************************************************************************
     Function:       viewDidLoad
     
     Description:    Called when screen loads
     
     Parameters:     none
     
     Returned:       none
     *************************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after Connecting to each other.
        //let cardQuery = CardID1Query()
      //  cardQuery.delegate = self
       // cardQuery.downloadCards()
    }
    
    func itemsDownloaded(items: NSArray) {
        //This array is the cards from the CardID1 Query
        //let scene = SCNScene(named: (NSArray[1]).cardImage)!
       
        
    }
    
    /**************************************************************************
     Function:       btnPlayAR
     
     Description:    Called when AR button hit. Calls seague to move to AR screen
     next screen
     
     Parameters:     sender: Any
     
     Returned:       none
     *************************************************************************/
    @IBAction func btnPlayAR(_ sender: Any) {
        self.performSegue(withIdentifier: "sgLoadAR", sender: self)     }

}
