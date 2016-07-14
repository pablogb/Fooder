//
//  CardPickerViewController.swift
//  Fooder
//
//  Created by Pablo Gomez Basanta on 7/7/16.
//  Copyright © 2016 Shifting Mind. All rights reserved.
//

import UIKit
import pop

class CardPickerViewController: UIViewController, UIViewControllerTransitioningDelegate {
    @IBOutlet weak var firstCard: CardView!
    @IBOutlet weak var secondCard: CardView!
    @IBOutlet weak var thirdCard: CardView!
    @IBOutlet weak var fourthCard: CardView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var nopeBUtton: UIButton!
    
    @IBOutlet weak var firstCardCenterX: NSLayoutConstraint!
    @IBOutlet weak var firstCardCenterY: NSLayoutConstraint!
    
    @IBOutlet weak var secondCardCenterY: NSLayoutConstraint!
    @IBOutlet weak var secondCardWidth: NSLayoutConstraint!
    
    var cards = ["tacos", "hamburger", "icecream", "pizza", "sushi"]
    var nextCard = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstCard.addTarget(self, action: #selector(handleTap))
        
        cards.shuffle()
        
        firstCard.restaurantName = cards[0]
        secondCard.restaurantName = cards[1]
        thirdCard.restaurantName = cards[2]
        fourthCard.restaurantName = cards[3]
        
        let heartImage = #imageLiteral(resourceName: "heart").withRenderingMode(.alwaysTemplate)
        let crossImage = #imageLiteral(resourceName: "cross").withRenderingMode(.alwaysTemplate)
        
        likeButton.setImage(heartImage, for: .normal)
        nopeBUtton.setImage(crossImage, for: .normal)
        
        
        // Animation
        animationDistance = view.bounds.width * 1.25
    }
    
    func showNextCard() {
        firstCard.restaurantName = secondCard.restaurantName
        secondCard.restaurantName = thirdCard.restaurantName
        thirdCard.restaurantName = fourthCard.restaurantName
        fourthCard.restaurantName = cards[nextCard]
        
        nextCard += 1
        if nextCard >= cards.count { nextCard = 0 }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var animationDistance:CGFloat = 0.0
    var shouldBeReversed = false
    var touchOffset:CGPoint = CGPoint.zero
    var likeAnimator: UIViewPropertyAnimator?
    var animationDirection: CGFloat = 1.0 {
        didSet {
            if oldValue != animationDirection {
                likeAnimator?.addAnimations({ [weak self] in
                    self?.performAnimations()
                })
            }
        }
    }
    
    func performAnimations() {
        firstCardCenterX.constant = animationDirection * animationDistance
        firstCard.layer.transform = CATransform3DMakeRotation(animationDirection * CGFloat.pi / 8.0, 0.0, 0.0, 1.0)
        firstCard.stampAlpha = animationDirection * 1.0
        
        secondCardCenterY.constant = -50.0
        secondCardWidth.constant = 0.0
        
        view.layoutIfNeeded()
    }
    
    func resetAnimations() {
        firstCardCenterX.constant = 0.0
        firstCardCenterY.constant = -50.0
        firstCard.layer.transform = CATransform3DIdentity
        firstCard.stampAlpha = 0.0
        
        secondCardCenterY.constant = -40.0
        secondCardWidth.constant = -10.0
        
        view.layoutIfNeeded()
    }
    
    func setupLikeAnimator() {
        // There are many bugs when using UISpringTimingParameters with this animation.
        //let timing = UISpringTimingParameters(dampingRatio: 0.9)
        let timing = UICubicTimingParameters(animationCurve: .linear)
        
        
        likeAnimator = UIViewPropertyAnimator(duration: 0.5, timingParameters: timing)
        
        likeAnimator?.addAnimations({ [weak self] in
            self?.performAnimations()
            })
        
        likeAnimator?.addCompletion({ [weak self] (finalPosition) in
            if finalPosition == .end && self?.shouldBeReversed == false {
                self?.showNextCard()
            }
            self?.resetAnimations()
            self?.likeAnimator = nil
        })
    }
    
    
    @IBAction func like(button:UIButton) {
        animationDirection = 1.0
        setupLikeAnimator()
        likeAnimator!.startAnimation()
    }
    
    @IBAction func nope(button:UIButton) {
        animationDirection = -1.0
        setupLikeAnimator()
        likeAnimator!.startAnimation()
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        var translation = recognizer.translation(in: view)
        // This is needed to adjust the translation coordinates when the gesture recognizer begins by interrupting an animation.h
        translation = CGPoint(x: translation.x + touchOffset.x, y: translation.y + touchOffset.y)
        
        switch(recognizer.state) {
        case .began:
            if likeAnimator == nil {
                setupLikeAnimator()
                likeAnimator!.startAnimation()
                touchOffset = CGPoint.zero
            } else {
                // Animation in progress.
                touchOffset = CGPoint(x: firstCardCenterX.constant * likeAnimator!.fractionComplete, y: 0.0)
            }
            
            likeAnimator!.pauseAnimation()
        case .changed:
            likeAnimator!.startAnimation() // iOS 10 beta bug (addAnimation doesn't work while paused)
            
            // Change y position 
            // This is tecnically wrong. When the animation is not complete, this should place the view somewhere between the initial height and the this height.
            // However when adding this animation, the change in height is applied directly, and reversing the animation no longer works.
            likeAnimator?.addAnimations({ [weak self] in
                self?.firstCardCenterY.constant = -50.0 + translation.y
            })
            
            if translation.x > 0.0 {
                animationDirection = 1.0
            } else {
                animationDirection = -1.0
            }
            
            likeAnimator!.pauseAnimation() // iOS 10 beta bug (addAnimation doesn't work while paused)
            let finalPosition = animationDirection * animationDistance
            likeAnimator!.fractionComplete = 1.0 - (finalPosition - translation.x) / finalPosition
        case .ended, .cancelled:
            let velocity = recognizer.velocity(in: view)
            let squaredSpeed = velocity.x * velocity.x + velocity.y * velocity.y
            
            // We should be able to use the isReversed property to move the animation back to the original destination, but this does now work properly when changing
            // the animation direction while the animation is paused, or with changing the height constraint, so we just change the animation target to be the initial position and complete the animation.h
            if likeAnimator?.fractionComplete < 0.5 && squaredSpeed < 50000 {
                //likeAnimator?.isReversed = true
                shouldBeReversed = true
                likeAnimator!.addAnimations({ [weak self] in
                    self?.resetAnimations()
                })
                // We should be able to use the continueAnimation method instead of startAnimation to change the duration of the remaining animation when we are going backwards, but unfortunately this also creates all kinds of problems :(
                //likeAnimator!.continueAnimation(withTimingParameters: nil, durationFactor: 1.0 - likeAnimator!.fractionComplete)
                
            } else {
                //likeAnimator?.isReversed = false
                shouldBeReversed = false
            }
            
            
            likeAnimator!.startAnimation()
        case .failed, .possible: break
        }
    }
    
    // Show Card Details View
    @IBAction func handleTap(recognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetails" {
            let detailsViewController = segue.destinationViewController as! CardDetailViewController
            
            detailsViewController.restaurantName = firstCard.restaurantName
            detailsViewController.transitioningDelegate = self
            detailsViewController.modalPresentationStyle = .custom


            
        }
    }
    
    // UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationController = FlipPresentingAnimator()
        animationController.viewForTransition = firstCard
        return animationController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationController = FlipDismissingAnimator()
        animationController.viewForTransition = firstCard
        return animationController
    }
    
}
