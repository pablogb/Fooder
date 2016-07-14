//
//  FlipPresentingAnimator.swift
//  Fooder
//
//  Created by Pablo Gomez Basanta on 7/11/16.
//  Copyright © 2016 Shifting Mind. All rights reserved.
//

import UIKit
import pop

class FlipPresentingAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var viewForTransition:UIView!
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        let toVC = transitionContext.viewController(forKey: UITransitionContextToViewControllerKey)!
        
        let toView = toVC.view!
        
        let initialFrame = containerView.convert(viewForTransition.frame, from: viewForTransition.superview)
        
        // Set the final frame.
        toView.frame = initialFrame
        
        // Prepare the snapshot of the original view.
        let fromSnapshotView = viewForTransition.snapshotView(afterScreenUpdates: true)!
        fromSnapshotView.frame = initialFrame
        fromSnapshotView.layer.cornerRadius = 5.0
        fromSnapshotView.layer.masksToBounds = true
        viewForTransition.isHidden = true
        
        
        // Prepare the snapshot view to match the position of the inital view.
        let toSnapshotView = toView.snapshotView(afterScreenUpdates: true)!
        toSnapshotView.frame = initialFrame
        toSnapshotView.layer.cornerRadius = 5.0
        toSnapshotView.layer.masksToBounds = true
        toSnapshotView.isHidden = true
        
        let dimmingView = UIView(frame: containerView.bounds)
        dimmingView.backgroundColor = UIColor.darkGray()
        dimmingView.layer.opacity = 0.0
        dimmingView.layer.transform = CATransform3DMakeTranslation(0.0, 0.0, -containerView.bounds.width / 2.0)
        
        containerView.addSubview(dimmingView)
        containerView.addSubview(toView)
        containerView.addSubview(fromSnapshotView)
        containerView.addSubview(toSnapshotView)
        toView.isHidden = true
                
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
            toView.isHidden = false
            toSnapshotView.removeFromSuperview()
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
            fromSnapshotView.isHidden = true // Keep this snapshot around for the return animation
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
        opacityAnimation.toValue = 0.5
        
        dimmingView.layer.pop_add(opacityAnimation, forKey: "opacity")
        
    }
}
