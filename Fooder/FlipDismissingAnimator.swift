//
//  FlipPresentingAnimator.swift
//  Fooder
//
//  Created by Pablo Gomez Basanta on 7/11/16.
//  Copyright © 2016 Shifting Mind. All rights reserved.
//

import UIKit
import pop

class FlipDismissingAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var viewForTransition:UIView!
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // fdr-dismissinganimator
        let containerView = transitionContext.containerView()
        let fromVC = transitionContext.viewController(forKey: UITransitionContextFromViewControllerKey)!
        
        let fromView = fromVC.view!
        
        let dimmingView = containerView.subviews[0]
        
        let initialFrame = fromView.frame
        
        let fromSnapshotView = fromView.snapshotView(afterScreenUpdates: true)!
        fromSnapshotView.frame = initialFrame
        fromSnapshotView.layer.cornerRadius = 5.0
        fromSnapshotView.layer.masksToBounds = true
        fromView.removeFromSuperview()
        
        let toSnapshotView = containerView.subviews[1] // This is the snapshot we created when we began the transition.
        
        // Add subviews and hide final view until the transition is over.
        containerView.addSubview(fromSnapshotView)
        containerView.addSubview(toSnapshotView)
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        toSnapshotView.layer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2.0, 0.0, 1.0, 0.0)
        
        let firstSpringVelocity:CGFloat = 10.0
        let firstSpringBounciness:CGFloat = 0.0
        let secondSpringVelocity:CGFloat = 5.0
        let secondSpringBounciness:CGFloat = 10.0
        
        let secondFlipAnimation = POPSpringAnimation(propertyNamed: kPOPLayerRotationY)!
        secondFlipAnimation.velocity = secondSpringVelocity
        secondFlipAnimation.springBounciness = secondSpringBounciness
        secondFlipAnimation.toValue = 0.0
        secondFlipAnimation.completionBlock = {(animation, finished) in
            self.viewForTransition.isHidden = false
            dimmingView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        
        let secondScaleAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)!
        secondScaleAnimation.velocity = NSValue(cgPoint: CGPoint(x: 0.0, y: secondSpringVelocity))
        secondScaleAnimation.springBounciness = secondSpringBounciness
        secondScaleAnimation.fromValue = NSValue(cgSize: CGSize(width: 1.25, height: 1.25))
        
        let firstFlipAnimation = POPSpringAnimation(propertyNamed: kPOPLayerRotationY)!
        firstFlipAnimation.velocity = firstSpringVelocity
        firstFlipAnimation.springBounciness = firstSpringBounciness
        firstFlipAnimation.toValue = CGFloat.pi / 2.0
        firstFlipAnimation.completionBlock = {(animation, finished) in
            fromSnapshotView.removeFromSuperview()
            toSnapshotView.isHidden = false
            
            toSnapshotView.layer.pop_add(secondFlipAnimation, forKey: "secondFlip")
            toSnapshotView.layer.pop_add(secondScaleAnimation, forKey: "secondScale")
        }
        
        let firstScaleAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)!
        firstScaleAnimation.velocity = NSValue(cgPoint: CGPoint(x: 0.0, y: firstSpringVelocity))
        firstScaleAnimation.springBounciness = firstSpringBounciness
        firstScaleAnimation.toValue = NSValue(cgSize: CGSize(width: 1.25, height: 1.25))
        
        fromSnapshotView.layer.pop_add(firstFlipAnimation, forKey: "firstFlip")
        fromSnapshotView.layer.pop_add(firstScaleAnimation, forKey: "firstScale")
        
        
        // Dimming View animation
        let opacityAnimation = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)!
        opacityAnimation.duration = animationDuration
        opacityAnimation.toValue = 0.0
        
        dimmingView.layer.pop_add(opacityAnimation, forKey: "opacity")
    }
}
