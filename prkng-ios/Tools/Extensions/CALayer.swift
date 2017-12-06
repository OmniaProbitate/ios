//
//  CALayer.swift
//  prkng-ios
//
//  Created by Antonino Urbano on 2015-06-19.
//  Copyright (c) 2015 PRKNG. All rights reserved.
//

import UIKit

extension CALayer {

    func addScaleAnimation() {
        let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        animation.values = [0,1]
        
        animation.duration = 0.4
        var timingFunctions: Array<CAMediaTimingFunction> = []
        
        for _ in 0...animation.values!.count {
            timingFunctions.append(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        }
        
        animation.timingFunctions = timingFunctions
        animation.isRemovedOnCompletion = true
        
        self.add(animation, forKey: "scale")
        
        //        NSLog("Added a scale animation")
    }

    func addCrossFadeAnimationFromImage(_ fromImage: UIImage, toImage: UIImage) {
        let crossFade = CABasicAnimation(keyPath: "contents")
        crossFade.duration = 0.3
        crossFade.fromValue = fromImage.cgImage!
        crossFade.toValue = toImage.cgImage
        self.add(crossFade, forKey: "animateContents")
    }
    
    func addFadeAnimation() {
        let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "opacity")
        
        animation.values = [0,1]
        
        animation.duration = 0.3
        var timingFunctions: Array<CAMediaTimingFunction> = []
        
        for _ in 0...animation.values!.count {
            timingFunctions.append(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        }
        
        animation.timingFunctions = timingFunctions
        animation.isRemovedOnCompletion = true
        
        self.add(animation, forKey: "opacity")
    }

    func addRightSlideAnimation() {
        let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        
        animation.values = [self.frame.width, 0]
        
        animation.duration = 0.3
        var timingFunctions: Array<CAMediaTimingFunction> = []
        
        for _ in 0...animation.values!.count {
            timingFunctions.append(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        }
        
        animation.timingFunctions = timingFunctions
        animation.isRemovedOnCompletion = true
        
        self.add(animation, forKey: "slidein")
    }
    
    func addLeftSlideAnimation() {
        let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        
        animation.values = [0, self.frame.width]
        
        animation.duration = 0.3
        var timingFunctions: Array<CAMediaTimingFunction> = []
        
        for _ in 0...animation.values!.count {
            timingFunctions.append(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        }
        
        animation.timingFunctions = timingFunctions
        animation.isRemovedOnCompletion = true
        
        self.add(animation, forKey: "slidein")
    }
    
    func wigglewigglewiggle() {
        
        if let _ = self.animation(forKey: "wigglewigglewiggle") {
            self.removeAnimation(forKey: "wigglewigglewiggle")
        }
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = M_PI / 75.0
        animation.toValue = -M_PI / 75.0
        animation.duration = 0.2
        animation.autoreverses = true
        animation.repeatCount = MAXFLOAT
        self.add(animation, forKey: "wigglewigglewiggle")
        
    }
    
    func addTopBorder(_ width: CGFloat, color: UIColor) {
        
        let border = CALayer()
        border.borderColor = color.cgColor
        
        border.frame = CGRect(x: 0, y: 1, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.addSublayer(border)
        
    }

    func addBottomBorder(_ width: CGFloat, color: UIColor) {
        
        let border = CALayer()
        border.borderColor = color.cgColor
        
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.addSublayer(border)

    }

}
