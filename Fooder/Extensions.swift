//
//  Extensions.swift
//  Fooder
//
//  Created by Pablo Gomez Basanta on 7/12/16.
//  Copyright © 2016 Shifting Mind. All rights reserved.
//

import UIKit

extension Collection {
    /// Return a copy of `self` with its elements shuffled
    func shuffled() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffle()
        return list
    }
}

extension MutableCollection where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffle() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in startIndex ..< endIndex - 1 {
            let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

extension UIColor {
    class func colorForGradient(percent:CGFloat, startColor:UIColor, endColor:UIColor) -> UIColor {
        var red1:CGFloat = 0.0, red2:CGFloat = 0.0
        var green1:CGFloat = 0.0, green2:CGFloat = 0.0
        var blue1:CGFloat = 0.0, blue2:CGFloat = 0.0
        var alpha1:CGFloat = 0.0, alpha2:CGFloat = 0.0
        
        startColor.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
        endColor.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
        
        let red = red1 + percent * (red2 - red1)
        let green = green1 + percent * (green2 - green1)
        let blue = blue1 + percent * (blue2 - blue1)
        let alpha = alpha1 + percent * (alpha2 - alpha1)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
