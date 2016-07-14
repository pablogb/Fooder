//
//  CardViewControllers.swift
//  Fooder
//
//  Created by Pablo Gomez Basanta on 7/12/16.
//  Copyright © 2016 Shifting Mind. All rights reserved.
//

import UIKit

class CardDetailViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl:UIPageControl!
    
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    
    var restaurantName = "tacos"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.layer.cornerRadius = 5.0
        containerView.layer.borderColor = UIColor.lightGray().cgColor
        //containerView.layer.borderWidth = 1.0
        
        containerView.layer.masksToBounds = false
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        containerView.layer.shadowRadius = 2.0
        containerView.layer.shadowOpacity = 0.2
        
        // Setup container view to clip the contents
        scrollView.layer.cornerRadius = 5.0
        scrollView.layer.masksToBounds = true
        
        firstImageView.image = UIImage(named: "images/\(restaurantName)/food1.png")
        secondImageView.image = UIImage(named: "images/\(restaurantName)/food2.png")
        thirdImageView.image = UIImage(named: "images/\(restaurantName)/food3.png")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
    
    @IBAction func viewTapped(tapGR:UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

@IBDesignable
class CardView: UIView {
    var photoImageView: UIImageView
    var logoImageView: UIImageView
    
    var gradientView: UIView
    var gradientLayer: CAGradientLayer
    
    var likeStamp: UIImageView
    var nopeStamp: UIImageView
    
    var restaurantName = "tacos" {
        didSet {
            photoImageView.image = UIImage(named: "images/\(restaurantName)/main.png", in: Bundle(for: self.dynamicType), compatibleWith: nil)
            logoImageView.image = UIImage(named: "images/\(restaurantName)/logo.png", in: Bundle(for: self.dynamicType), compatibleWith: nil)
        }
    }
    
    var stampAlpha:CGFloat = 0.0 {
        didSet {
            if(stampAlpha > 0.0) {
                likeStamp.alpha = stampAlpha
                nopeStamp.alpha = 0.0
            } else {
                likeStamp.alpha = 0.0
                nopeStamp.alpha = -stampAlpha
            }
        }
    }
    
    var tapGR:UITapGestureRecognizer!
    
    override init(frame: CGRect) {
        photoImageView = UIImageView()
        logoImageView = UIImageView()
        gradientView = UIView()
        gradientLayer = CAGradientLayer()
        
        likeStamp = UIImageView(image: UIImage(named: "like", in: Bundle(for: self.dynamicType), compatibleWith: nil))
        nopeStamp = UIImageView(image: UIImage(named: "nope", in: Bundle(for: self.dynamicType), compatibleWith: nil))
        
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        photoImageView = UIImageView()
        logoImageView = UIImageView()
        gradientView = UIView()
        gradientLayer = CAGradientLayer()
        
        likeStamp = UIImageView(image: UIImage(named: "like", in: Bundle(for: self.dynamicType), compatibleWith: nil))
        nopeStamp = UIImageView(image: UIImage(named: "nope", in: Bundle(for: self.dynamicType), compatibleWith: nil))
        
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    func setupView() {
        // Setup the outer view.
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.lightGray().cgColor
        //layer.borderWidth = 1.0
        
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.2
        
        
        gradientLayer.colors = [UIColor.clear().cgColor, UIColor(white: 1.0, alpha: 0.75).cgColor]
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        // Setup container view to clip the contents
        let container = UIView()
        container.layer.cornerRadius = 5.0
        container.layer.masksToBounds = true
        
        container.addSubview(photoImageView)
        container.addSubview(gradientView)
        container.addSubview(logoImageView)
        
        addSubview(container)
        
        // Temporary setup
        photoImageView.image = UIImage(named: "images/\(restaurantName)/waitress.png", in: Bundle(for: self.dynamicType), compatibleWith: nil)
        photoImageView.contentMode = .scaleAspectFill
        
        logoImageView.image = UIImage(named: "images/\(restaurantName)/logo.png", in: Bundle(for: self.dynamicType), compatibleWith: nil)
        logoImageView.contentMode = .scaleAspectFit
        
        likeStamp.alpha = 0.0
        nopeStamp.alpha = 0.0
        
        // Setup constraints.
        
        let views = ["container": container, "photo": photoImageView, "logo": logoImageView, "gradient": gradientView]
        
        container.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        likeStamp.translatesAutoresizingMaskIntoConstraints = false
        nopeStamp.translatesAutoresizingMaskIntoConstraints = false
        
        // Container view
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[container]-0-|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[container]-0-|", options: [], metrics: nil, views: views))
        
        // Photo
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[photo]-0-|", options: [], metrics: nil, views: views))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[photo]-0-|", options: [], metrics: nil, views: views))
        
        // Logo
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[logo(50)]-10-|", options: [], metrics: nil, views: views))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[logo]-10-|", options: [], metrics: nil, views: views))
        
        // Gradient
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[gradient(200)]-0-|", options: [], metrics: nil, views: views))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[gradient]-0-|", options: [], metrics: nil, views: views))
        
        // Stamps
        container.addSubview(likeStamp)
        container.addSubview(nopeStamp)
        
        container.addConstraint(NSLayoutConstraint(item: likeStamp, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 10.0))
        container.addConstraint(NSLayoutConstraint(item: likeStamp, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 10.0))
        
        container.addConstraint(NSLayoutConstraint(item: nopeStamp, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 10.0))
        container.addConstraint(NSLayoutConstraint(item: container, attribute: .trailing, relatedBy: .equal, toItem: nopeStamp, attribute: .trailing, multiplier: 1.0, constant: 10.0))
        
        
        layoutIfNeeded()
        
        tapGR = UITapGestureRecognizer()
        container.addGestureRecognizer(tapGR)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update the gradient.
        gradientLayer.frame = gradientView.bounds
    }
    
    
    // Forward target addition/removal to the GR.
    func addTarget(_ target: AnyObject, action: Selector) {
        tapGR.addTarget(target, action: action)
    }
    
    func removeTarget(_ target: AnyObject?, action: Selector?) {
        removeTarget(target, action: action)
    }
}
