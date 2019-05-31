//
//  SimpleOver.swift
//  Homescape
//
//  Created by David G Chopin on 5/29/19.
//  Copyright © 2019 David G Chopin. All rights reserved.
//

import UIKit

class SimpleOver: NSObject, UIViewControllerAnimatedTransitioning {
    
    //
    //This was code grabbed form the internet. It is a custom animated transition between view controllers. I admittantly haven't really looked at this code
    //
    
    
    var popStyle: Bool = false
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.20
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if popStyle {
            
            animatePop(using: transitionContext)
            return
        }
        
        let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let f = transitionContext.finalFrame(for: tz)
        
        let fOff = f.offsetBy(dx: f.width, dy: 0)
        tz.view.frame = fOff
        
        transitionContext.containerView.insertSubview(tz.view, aboveSubview: fz.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                tz.view.frame = f
                for subview in fz.view.subviews {
                    subview.alpha = 0
                }
        }, completion: {_ in
            transitionContext.completeTransition(true)
        })
    }
    
    func animatePop(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let f = transitionContext.initialFrame(for: fz)
        let fOffPop = f.offsetBy(dx: f.width, dy: 0)
        
        transitionContext.containerView.insertSubview(tz.view, belowSubview: fz.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                fz.view.frame = fOffPop
                for subview in tz.view.subviews {
                    subview.alpha = 1
                }
        }, completion: {_ in
            transitionContext.completeTransition(true)
        })
    }
}
