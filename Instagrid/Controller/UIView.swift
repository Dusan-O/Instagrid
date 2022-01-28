//
//  UIView.swift
//  Instagrid
//
//  Created by Dusan Orescanin on 07/01/2022.
//

import UIKit

extension UIView {
    /// This animation is use to make more fluid the transition between frames
    func flashAnimation() {
        let flash = CABasicAnimation(keyPath: "opacity")
        
        flash.duration = 0.1
        flash.fromValue = 0.6
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        layer.add(flash, forKey: nil)
    }
    /// This animation is use to move an element from a position to another
    func animateAndMove(x: CGFloat,y: CGFloat) {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(translationX: x, y: y)
        })
    }
    
    /// This animation is use to bring back an element from a position to another. It also use device orientation
    func animateBack(x: CGFloat, y: CGFloat, delay: Double) {
        if UIDevice.current.orientation.isLandscape {
            self.transform = CGAffineTransform(translationX: x, y: y)
        } else if UIDevice.current.orientation.isPortrait {
            self.transform = CGAffineTransform(translationX: y, y: x)
        }
        UIView.animate(withDuration: 0.9, delay: delay, usingSpringWithDamping: 1.5, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {
            self.transform = .identity
        })
    }
}
