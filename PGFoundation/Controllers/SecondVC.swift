//
//  SecondVC.swift
//  PGFoundation
//
//  Created by Puneet Gurtoo on 12/4/16.
//  Copyright © 2016 Puneet Gurtoo. All rights reserved.
//

import UIKit

class SecondVC: UIViewController {
   
    var abc:check?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        abc = check.init()
        
    }
    
    deinit{
        print("in secondvc deinit")
    }
}
