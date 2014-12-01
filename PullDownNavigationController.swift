//
//  PullDownNavigationController.swift
//  PullDownNavigationControllerSample
//
//  Created by Adolfo Rodriguez on 2014-11-23.
//  Copyright (c) 2014 Wircho. All rights reserved.
//

import UIKit

class PullDownNavigationController: UINavigationController {

    var temporaryTitle:String!
    weak var temporaryTitleView:UIView!
    var temporaryLeftItem:UIBarButtonItem!
    var temporaryRightItem:UIBarButtonItem!
    var navigationBarOpen:Bool = false
    var initialNavigationBarFrame:CGRect = CGRectZero
    var initialTitleViewFrame:CGRect = CGRectZero
    var largeNavigationBarFrame:CGRect = CGRectZero
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "pulledNavigationBarDown:")
        
        self.navigationBar.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    
    
    func pulledNavigationBarDown(panGR:UIPanGestureRecognizer) {
        switch panGR.state {
        case .Began:
            
            if navigationBarOpen {
                
                largeNavigationBarFrame = self.navigationBar.frame
                
            }else{
                
                initialNavigationBarFrame = self.navigationBar.frame
                
                let navItem = self.navigationBar.items.last! as UINavigationItem
                
                temporaryTitle = navItem.title
                navItem.title = nil
                
                temporaryLeftItem = navItem.leftBarButtonItem
                temporaryRightItem = navItem.rightBarButtonItem
                
                if let titleView = navItem.titleView {
                    let frame = titleView.frame
                    initialTitleViewFrame = frame
                    navItem.titleView = nil
                    temporaryTitleView = titleView
                    titleView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                    self.navigationBar.addSubview(titleView)
                    titleView.frame = initialTitleViewFrame
                }
                
                navItem.leftBarButtonItem = nil
                navItem.rightBarButtonItem = nil
                
                UIView.animateWithDuration(0.15, animations: { () -> Void in
                    if let ttv = self.temporaryTitleView {
                        ttv.frame = self.navigationBar.bounds
                    }
                })
                
            }
        case .Changed:
            let translationY = panGR.translationInView(self.view).y
            
            let firstFrame = navigationBarOpen ? largeNavigationBarFrame : initialNavigationBarFrame
            
            self.navigationBar.frame = CGRectMake(
                firstFrame.origin.x,
                firstFrame.origin.y,
                firstFrame.size.width,
                firstFrame.size.height + translationY
            )
        case .Cancelled:
            fallthrough
        case .Ended:
            
            let maxHeight = UIScreen.mainScreen().bounds.size.height
            
            let currentFrame = self.navigationBar.frame
            let closed = fabs(currentFrame.size.height - initialNavigationBarFrame.size.height)
            let open = fabs(currentFrame.size.height - maxHeight)
            
            let velocity = panGR.velocityInView(self.view)
            
            let speed = min(2.0,max(0.1,fabs(velocity.y)))
            
            let springDuration:Double = 10
            let springDamping:CGFloat = 0.7
            
            if velocity.y > 0 || (velocity.y == 0 && open < closed) {
                navigationBarOpen = true
                let duration = min(0.5,springDuration * Double(open / (open + closed)) / Double(speed))
                UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: springDamping, initialSpringVelocity: speed, options: .CurveLinear,
                    animations: { () -> Void in
                        
                        self.navigationBar.frame = CGRectMake(self.navigationBar.frame.origin.x,self.navigationBar.frame.origin.y, self.navigationBar.frame.size.width, maxHeight)
                        
                    },
                    completion: nil
                )
            } else {
                let duration = min(0.5,springDuration * Double(closed / (open + closed)) / Double(speed))
                
                if let titleView = self.temporaryTitleView {
                    titleView.autoresizingMask = .FlexibleBottomMargin | .FlexibleRightMargin
                }
                
                UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: springDamping, initialSpringVelocity: speed, options: .CurveLinear,
                    animations: { () -> Void in
                        if let titleView = self.temporaryTitleView {
                            titleView.frame = self.initialTitleViewFrame
                        }
                    },
                    completion: {
                        [weak self]
                        (finished:Bool) -> Void in
                        if finished {
                            
                            if let s = self {
                                if let navItem = s.navigationBar.items.last as? UINavigationItem {
                                    navItem.leftBarButtonItem = s.temporaryLeftItem
                                    navItem.rightBarButtonItem = s.temporaryRightItem
                                    s.navigationBarOpen = false
                                    navItem.titleView = s.temporaryTitleView
                                }
                            }
                            
                        }
                    }
                )
                
                UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: springDamping, initialSpringVelocity: speed, options: .CurveLinear,
                    animations: { () -> Void in
                        
                        self.navigationBar.frame = self.initialNavigationBarFrame
                        
                    },
                    completion: nil
                )
            }
            
        default:
            break
        }
    }

}
