//
//  PullDownNavigationController.swift
//  PullDownNavigationControllerSample
//
//  Created by Adolfo Rodriguez on 2014-11-23.
//  Copyright (c) 2014 Wircho. All rights reserved.
//

import UIKit

class PullDownNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "pulledNavigationBarDown:")
        
        self.navigationBar.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    var initialNavigationBarFrame:CGRect = CGRectZero
    
    func pulledNavigationBarDown(panGR:UIPanGestureRecognizer) {
        switch panGR.state {
        case .Began:
            initialNavigationBarFrame = self.navigationBar.frame
        case .Changed:
            let translationY = panGR.translationInView(self.view).y
            self.navigationBar.frame = CGRectMake(
                initialNavigationBarFrame.origin.x,
                initialNavigationBarFrame.origin.y,
                initialNavigationBarFrame.size.width,
                initialNavigationBarFrame.size.height + translationY
            )
        case .Cancelled:
            fallthrough
        case .Ended:
            break
        default:
            break
        }
    }

}
