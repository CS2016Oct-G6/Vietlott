//
//  CircleAnimator.swift
//  Vietlott
//
//  Created by CongTruong on 11/20/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import UIKit

class CircleAnimator: NSObject {
    let duration: TimeInterval = 0.5
    var isPresenting = false
}

extension CircleAnimator: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    // 2. implement 2 protocols for UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        
        return self
    }
    
    // 3.
    // This is used for percent driven interactive transitions, as well as for
    // container controllers that have companion animations that might need to
    // synchronize with the main animation.
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        
        
        if isPresenting {
            //3
            containerView.addSubview((toViewController?.view)!)
            
            UIView.animate(withDuration: duration, animations: {() -> Void in
                
                let frame = CGRect(x: Constance.pointToDraw.0, y: Constance.pointToDraw.1, width: 50, height: 50)
                //4
                let circleMaskPathInitial = UIBezierPath(ovalIn: frame)
                let extremePoint = CGPoint(x: Constance.pointToDraw.0 - 0, y: Double((toViewController?.view.bounds.height)!))
                let radius = sqrt((extremePoint.x*extremePoint.x) + (extremePoint.y*extremePoint.y))
                let circleMaskPathFinal = UIBezierPath(ovalIn: frame.insetBy(dx: -radius, dy: -radius))
                
                //5
                let maskLayer = CAShapeLayer()
                maskLayer.path = circleMaskPathFinal.cgPath
                toViewController?.view.layer.mask = maskLayer
                
                //6
                let maskLayerAnimation = CABasicAnimation(keyPath: "path")
                maskLayerAnimation.fromValue = circleMaskPathInitial.cgPath
                maskLayerAnimation.toValue = circleMaskPathFinal.cgPath
                maskLayerAnimation.duration = self.transitionDuration(using: transitionContext)
                maskLayerAnimation.delegate = self
                maskLayer.add(maskLayerAnimation, forKey: "path")
            }, completion: {(Bool) -> Void in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: duration, animations: {() -> Void in
                
                fromViewController?.view.alpha = 0
            }, completion: {(Bool) -> Void in
                transitionContext.completeTransition(true)
                fromViewController?.view.removeFromSuperview()
            })
        }
    }
    
}
