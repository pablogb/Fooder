//
//  EasingFunctions.swift
//  Fooder
//
//  Created by Pablo Gomez Basanta on 7/8/16.
//  Copyright © 2016 Shifting Mind. All rights reserved.
//

import UIKit

// Maps from [0,1] to [targetMin, targetMax]
func mapToRange(value:CGFloat, targetMin: CGFloat, targetMax: CGFloat) -> CGFloat {
    var value = value
    if value < 0.0 { value = 0.0 }
    else if value > 1.0 { value = 1.0 }
    
    return targetMin + (value * (targetMax - targetMin))
}

// Maps from [targetMin, targetMax] to [0,1]
func mapFromRange(value:CGFloat, targetMin: CGFloat, targetMax: CGFloat)  -> CGFloat {
    var value = value
    if value < targetMin { value = targetMin }
    else if value > targetMax { value = targetMax }
    
    return (value - targetMin) / (targetMax - targetMin)
}

struct TimingFunctions {
    // no easing, no acceleration
    static func linear(t: CGFloat) -> CGFloat {
        return t
    }
    // accelerating from zero velocity
    static func easeInQuad(t: CGFloat) -> CGFloat {
        return t * t
    }
    // decelerating to zero velocity
    static func easeOutQuad(t: CGFloat) -> CGFloat {
        return t * (2.0 - t)
    }
    // acceleration until halfway, then deceleration
    static func easeInOutQuad(t: CGFloat) -> CGFloat {
        if t < 0.5 {
            return 2.0 * t * t
        } else {
            return -1.0 + (4.0 - 2.0 * t) * t
        }
    }
    // accelerating from zero velocity
    static func easeInCubic(t: CGFloat) -> CGFloat {
        return t * t * t
    }
    // decelerating to zero velocity
    static func easeOutCubic(t: CGFloat) -> CGFloat {
        return t * t * t + 1.0
    }
    // acceleration until halfway, then deceleration
    static func easeInOutCubic(t: CGFloat) -> CGFloat {
        if t < 0.5 {
            return 4.0 * t * t * t
        } else {
            let num = (2.0 * t - 2.0)
            return (t - 1.0) * num * num + 1.0
        }
    }
    // accelerating from zero velocity
    static func easeInQuart(t: CGFloat) -> CGFloat {
        return t * t * t * t
    }
    // decelerating to zero velocity
    static func easeOutQuart(t: CGFloat) -> CGFloat {
        return 1.0 - t * t * t * t
    }
    // acceleration until halfway, then deceleration
    static func easeInOutQuart(t: CGFloat) -> CGFloat {
        if t < 0.5 {
            return 8.0 * t * t * t * t
        } else {
            return 1.0 - 8.0 * t * t * t * t
        }
    }
    // accelerating from zero velocity
    static func easeInQuint(t: CGFloat) -> CGFloat {
        return t * t * t * t * t
    }
    // decelerating to zero velocity
    static func easeOutQuint(t: CGFloat) -> CGFloat {
        return 1.0 + t * t * t * t * t
    }
    // acceleration until halfway, then deceleration
    static func easeInOutQuint(t: CGFloat) -> CGFloat {
        if t < 0.5 {
            return 16.0 * t * t * t * t * t
        } else {
            return 1.0 + 16.0 * t * t * t * t * t
        }
    }
}
