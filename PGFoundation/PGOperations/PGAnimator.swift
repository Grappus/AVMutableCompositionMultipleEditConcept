//
//  PGAnimator.swift
//  PGFoundation
//
//  Created by Puneet Gurtoo on 12/18/16.
//  Copyright © 2016 Puneet Gurtoo. All rights reserved.
//

import UIKit

class PGAnimator: NSObject,UIViewControllerAnimatedTransitioning {
    
    let duration    = 0.5
    var presenting  = true
    var originFrame = CGRect.zero

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?)-> TimeInterval {
        return duration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)
        let operationView = presenting ? toView : fromView
        setAlpha(forView: operationView)
        containerView.addSubview(toView!)
        containerView.bringSubview(toFront: operationView!)
        UIView.animate(withDuration: duration, animations: {
          
            if self.presenting == true{
                operationView?.alpha = 1.0
            }
            else if self.presenting == false{
                operationView?.alpha = 0.1
            }
        }, completion: {(Bool)in
            transitionContext.completeTransition(true)
        })
    }
    fileprivate func setAlpha(forView operationView_:UIView?){
        if presenting == true {
            operationView_?.alpha = 0.1
        }
        else if presenting == false{
            operationView_?.alpha = 1.0
        }
    }
}
