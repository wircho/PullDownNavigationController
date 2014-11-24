//
//  ViewController.swift
//  PullDownNavigationControllerSample
//
//  Created by Adolfo Rodriguez on 2014-11-23.
//  Copyright (c) 2014 Wircho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let v = CrossView(frame: self.navigationController!.navigationBar.bounds)
        v.backgroundColor = UIColor.redColor()
        
        v.frame = self.navigationController!.navigationBar.bounds
        
        self.navigationItem.titleView = v
        
    }
    
    

}

