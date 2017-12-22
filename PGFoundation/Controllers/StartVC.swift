//
//  StartVC.swift
//  PGFoundation
//
//  Created by Puneet Gurtoo on 12/4/16.
//  Copyright © 2016 Puneet Gurtoo. All rights reserved.
//

import UIKit

class StartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       // UIDatePicker
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func start_Action(_ sender: AnyObject) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SecondVC") as? SecondVC
        navigationController?.pushViewController(vc!, animated: true)
    }
}
