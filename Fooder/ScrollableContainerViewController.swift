//
//  ViewController.swift
//  Fooder
//
//  Created by Pablo Gomez Basanta on 7/6/16.
//  Copyright © 2016 Shifting Mind. All rights reserved.
//

import UIKit

class ScrollableContainerViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var profileButtonXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var reservationsButton: UIButton!
    @IBOutlet weak var reservationsButtonXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dummyPlate1: UIImageView!
    @IBOutlet weak var dummyPlate2: UIImageView!
    
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var logoButton: UIButton!
    @IBOutlet weak var logoLabelXConstraint: NSLayoutConstraint!
    
    var buttonTintColor:UIColor!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // This is not the proper place for this. But the proper place for this is not really worth it for just a demo.
        scrollView.contentOffset = CGPoint(x: scrollView.contentSize.width / 3.0, y: 0.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let plateImage = #imageLiteral(resourceName: "plate").withRenderingMode(.alwaysTemplate)
        
        dummyPlate1.image = plateImage
        dummyPlate2.image = plateImage
        
        buttonTintColor = logoLabel.textColor
        
        let fullplateImage = #imageLiteral(resourceName: "fullplate").withRenderingMode(.alwaysTemplate)
        let profileImage = #imageLiteral(resourceName: "profile").withRenderingMode(.alwaysTemplate)
        let reservationsImage = #imageLiteral(resourceName: "reservations").withRenderingMode(.alwaysTemplate)
        
        logoButton.setImage(fullplateImage, for: .normal)
        profileButton.setImage(profileImage, for: .normal)
        reservationsButton.setImage(reservationsImage, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showProfile(sender:UIButton) {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func showCards(sender:UIButton) {
        scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width / 3.0, y: 0.0), animated: true)
    }
    
    @IBAction func showReservations(sender:UIButton) {
        scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width * 2.0 / 3.0, y: 0.0), animated: true)
    }
    
    // UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) { // fdr-scroll
        let offset = scrollView.contentOffset.x
        let screenWidth = scrollView.contentSize.width / 3.0
        
        let leftTransitionProgress = TimingFunctions.linear(t: mapFromRange(value: offset, targetMin: 0, targetMax: screenWidth))
        let rightTransitionProgress = TimingFunctions.linear(t: mapFromRange(value: offset, targetMin: screenWidth, targetMax: screenWidth * 2.0))
        
        let centerOffset = (screenWidth / 2.0) - 20.0 - 4.0 // (screenWidth / 2.0) is the center between screens, 20.0 is half the button width, and 4.0 is the margin.
        
        // Profile x center should move between -screenWidth and -centerOffset
        profileButtonXConstraint.constant = mapToRange(value: leftTransitionProgress, targetMin: -screenWidth, targetMax: -centerOffset)
        profileButton.tintColor = UIColor.colorForGradient(percent: leftTransitionProgress, startColor: buttonTintColor, endColor: UIColor.lightGray())
        if leftTransitionProgress == 0 { profileButton.isEnabled = false }
        else { profileButton.isEnabled = true }
        
        // Reservations x center should move between centerOffset and screenWidth
        reservationsButtonXConstraint.constant = mapToRange(value: rightTransitionProgress, targetMin: centerOffset, targetMax: screenWidth)
        reservationsButton.tintColor = UIColor.colorForGradient(percent: rightTransitionProgress, startColor:UIColor.lightGray() , endColor: buttonTintColor)
        if rightTransitionProgress == 1 { reservationsButton.isEnabled = false }
        else { reservationsButton.isEnabled = true }
        
        // (screenWidth / 2.0) is the center between screens, 47.0 is the offset from the center of the plate to the center of the logo, 23.0 is half of the button width, and 8.0 is the margin.
        let logoOffsetLeft = (-screenWidth / 2.0) + 47.0 - 23.0 - 8.0
        let logoOffsetRight = (screenWidth / 2.0) + 47.0 + 23.0 + 8.0
        
        
        // Logo x center should move between logoOffsetLeft and 0 when contentOffset is between 0 and screenWidth, and between 0 and logoOffsetRight when contentOffset is between screenWidth and screenWidth * 2
        if leftTransitionProgress < 1.0 {
            logoLabelXConstraint.constant = mapToRange(value: leftTransitionProgress, targetMin: logoOffsetLeft, targetMax: 0)
            logoLabel.alpha = leftTransitionProgress
            dummyPlate1.alpha = leftTransitionProgress
            dummyPlate2.alpha = leftTransitionProgress
            logoButton.alpha = 1.0 - leftTransitionProgress
        } else {
            logoLabelXConstraint.constant = mapToRange(value: rightTransitionProgress, targetMin: 0, targetMax: logoOffsetRight)
            logoLabel.alpha = 1.0 - rightTransitionProgress
            dummyPlate1.alpha = 1.0 - rightTransitionProgress
            dummyPlate2.alpha = 1.0 - rightTransitionProgress
            logoButton.alpha = rightTransitionProgress
        }
    }
}

