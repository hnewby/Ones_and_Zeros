//
//  ViewDecksScreen.swift
//  Ones_and_Zeroes
//
//  Created by Hannah Newby-Smith on 11/7/18.
//  Copyright © 2018 Jonah Pincetich. All rights reserved.
//

import UIKit

class ViewDecksScreen: UIViewController {

    @IBOutlet weak var btnSearch: UIButton!
    /**************************************************************************
     Function:       viewDidLoad
     
     Description:    Called when screen loads
     
     Parameters:     none
     
     Returned:       none
     *************************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
         btnSearch.layer.cornerRadius = 15
        
    }
}
