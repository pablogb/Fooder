import UIKit
import PlaygroundSupport
import pop

// Para ver las animaciones hay que abrir el Assitant Editor y descomentar alguno de los bloques de código que estan abajoh

let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 800.0, height: 100.0))
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = containerView

let label = UILabel(frame: CGRect(x: 10.0, y: 25.0, width: 100.0, height: 50.0))
label.textColor = UIColor.white()
containerView.addSubview(label)

let square = UIView(frame: CGRect(x: 10.0, y: 25.0, width: 50.0, height: 50.0))
square.backgroundColor = UIColor.orange()
square.layer.cornerRadius = 10.0
containerView.addSubview(square)


//DispatchQueue.main.after(when: .now() + 1.0) {
//    label.text = "\(square.frame.origin.x)"
//}

//UIView.animate(withDuration: 2.0, animations: {
//    square.frame = CGRect(x: 740.0, y: 25.0, width: 50.0, height: 50.0)
//    }, completion: nil)

//let animation = POPBasicAnimation(propertyNamed: kPOPLayerPositionX)!
//animation.toValue = 765.0
//animation.duration = 2.0
//animation.timingFunction  = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
//
//square.layer.pop_add(animation, forKey: "move")

//let animation = POPDecayAnimation(propertyNamed: kPOPLayerPositionX)!
//animation.velocity = NSValue(cgPoint: CGPoint(x: 1000.0, y: 0.00))
//
//square.layer.pop_add(animation, forKey: "move")

//let animation = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)!
//animation.springBounciness = 20.0
//animation.springSpeed = 10.0
//animation.toValue = 765.0
//
//square.layer.pop_add(animation, forKey: "move")


//let animator = UIViewPropertyAnimator(duration: 2.0, curve: .linear) { 
//    square.frame = CGRect(x: 740.0, y: 25.0, width: 50.0, height: 50.0)
//}
//animator.startAnimation()
//
//DispatchQueue.main.after(when: .now() + 1.0) {
//    animator.addAnimations({ 
//        square.layer.transform = CATransform3DMakeRotation(CGFloat.pi / 2.0, 0.0, 0.0, 1.0)
//    })
//}

