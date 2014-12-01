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

class CrossView : UIView {
    override func drawRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        
        CGContextSetLineWidth(ctx, 1)
        CGContextSetStrokeColorWithColor(ctx,UIColor.blackColor().CGColor)
        
        CGContextMoveToPoint(ctx,0,0)
        CGContextAddLineToPoint(ctx,self.bounds.size.width,self.bounds.size.height)
        CGContextStrokePath(ctx)
        
        CGContextMoveToPoint(ctx,self.bounds.size.width,0)
        CGContextAddLineToPoint(ctx,0,self.bounds.size.height)
        CGContextStrokePath(ctx)
    }
}

