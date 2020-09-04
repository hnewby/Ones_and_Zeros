//
//  ViewSettingsScreen.swift
//  Ones_and_Zeroes
//
//  Created by Hannah Newby-Smith on 11/7/18.
//  Copyright © 2018 Jonah Pincetich. All rights reserved.
//

import UIKit

class ViewSettingsScreen: UIViewController {
    
    @IBOutlet weak var btnStore: UIButton!
    /**************************************************************************
     Function:       viewDidLoad
     
     Description:    Called when screen loads
     
     Parameters:     none
     
     Returned:       none
     *************************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
         btnStore.layer.cornerRadius = 15
        
    }

}
