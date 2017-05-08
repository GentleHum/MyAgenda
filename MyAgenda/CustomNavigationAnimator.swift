//
//  CustomNavigationAnimator.swift
//  MyAgenda
//
//  Created by Michael Vork on 5/8/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import Foundation

//
//  CustomNavigationAnimator.swift
//  CustomTransitionDemo
//
//  Created by Mike Vork on 4/15/17.
//  Copyright © 2017 CareerFoundy. All rights reserved.
//

import UIKit

class CustomNavigationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var pushing = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
                return
        }
        
        let toViewControllerEndFrame = transitionContext.finalFrame(for: toViewController)
        var toViewControllerStartFrame = toViewControllerEndFrame
        
        if pushing {
            toViewControllerStartFrame.origin.y -= UIScreen.main.bounds.height
        }
        
        toViewController.view.frame = toViewControllerStartFrame
        transitionContext.containerView.addSubview(toViewController.view)
        transitionContext.containerView.sendSubview(toBack: toViewController.view)
        
        let snapshotView: UIView
        let snapshotViewFinalFrame: CGRect
        
        if (pushing) {
            snapshotView = toViewController.view.snapshotView(afterScreenUpdates: true)!
            snapshotView.frame = fromViewController.view.frame.insetBy(dx: fromViewController.view.frame.size.width / 2, dy: fromViewController.view.frame.size.height / 2)
            snapshotViewFinalFrame = toViewControllerEndFrame
        } else {
            snapshotView = fromViewController.view.snapshotView(afterScreenUpdates: false)!
            snapshotView.frame = fromViewController.view.frame
            snapshotViewFinalFrame = fromViewController.view.frame.insetBy(dx: fromViewController.view.frame.size.width / 2, dy: fromViewController.view.frame.size.height / 2)
            fromViewController.view.isHidden = true
        }
        
        transitionContext.containerView.addSubview(snapshotView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            snapshotView.frame = snapshotViewFinalFrame
        }, completion: {
            finished in
            
            let cancelled = transitionContext.transitionWasCancelled
            
            if self.pushing {
                toViewController.view.frame = toViewControllerEndFrame
            } else if cancelled {
                fromViewController.view.isHidden = false
            }
            
            snapshotView.removeFromSuperview()
            transitionContext.completeTransition(!cancelled)
        })
    }
}
