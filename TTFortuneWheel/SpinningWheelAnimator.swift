//
//  SpinningWheelAnimator.swift
//  TTFortuneWheel
//
//  Created by Efraim Budusan on 10/3/17.
//  Copyright © 2017 Efraim Budusn. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

protocol SpinningAnimatorProtocol: class  {
    var layerToAnimate:CALayer { get }
}


class SpinningWheelAnimator : NSObject, CAAnimationDelegate {
    
    
    weak var animationObject:SpinningAnimatorProtocol!
    
    internal var completionBlocks = [CAAnimation: (Bool) -> Void]()
    internal var updateLayerValueForCompletedAnimation : Bool = false
    
    //Configuration properties
    var fullRotationsUntilFinish:Int = 13
    var rotationTime: CFTimeInterval = 5.000
    
    init(withObjectToAnimate animationObject:SpinningAnimatorProtocol) {
        self.animationObject = animationObject
    }
    
    
    func addIndefiniteRotationAnimation() {
        
        let fillMode : String = CAMediaTimingFillMode.forwards.rawValue
        let starTransformAnim      = CAKeyframeAnimation(keyPath:"transform.rotation.z")
        starTransformAnim.values   = [0, 7000 * CGFloat.pi/180]
        starTransformAnim.keyTimes = [0, 1]
        starTransformAnim.duration = rotationTime
        
        let starRotationAnim : CAAnimationGroup = TTUtils.group(animations: [starTransformAnim], fillMode:fillMode)
        starRotationAnim.repeatCount = Float.infinity
        animationObject.layerToAnimate.add(starRotationAnim, forKey:"starRotationIndefiniteAnim")
        
    }
    
    func addRotationAnimation(completionBlock: ((_ finished: Bool) -> Void)? = nil, rotationOffset:CGFloat = 0.0){
        if completionBlock != nil{
            let completionAnim = CABasicAnimation(keyPath:"completionAnim")
            completionAnim.duration = rotationTime
            completionAnim.delegate = self
            completionAnim.setValue("rotation", forKey:"animId")
            completionAnim.setValue(false, forKey:"needEndAnim")
            let layer = animationObject.layerToAnimate
            layer.add(completionAnim, forKey:"rotation")
            if let anim = layer.animation(forKey: "rotation"){
                completionBlocks[anim] = completionBlock
            }
        }
        
        let fillMode : String = CAMediaTimingFillMode.forwards.rawValue
        
        let rotation:CGFloat = CGFloat(fullRotationsUntilFinish) * 360.0 + rotationOffset
        
        ////Star animation
        let starTransformAnim            = CAKeyframeAnimation(keyPath:"transform.rotation.z")
        starTransformAnim.values         = [0, rotation * CGFloat.pi/180]
        starTransformAnim.keyTimes       = [0, 1]
        starTransformAnim.duration       = 5
        starTransformAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.0256, 0.874, 0.675, 1)
        
        let starRotationAnim : CAAnimationGroup = TTUtils.group(animations: [starTransformAnim], fillMode:fillMode)
        animationObject.layerToAnimate.add(starRotationAnim, forKey:"starRotationAnim")
    }
    
    //MARK: - Animation Cleanup
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        if let completionBlock = completionBlocks[anim]{
            completionBlocks.removeValue(forKey: anim)
            if (flag && updateLayerValueForCompletedAnimation) || anim.value(forKey: "needEndAnim") as! Bool{
                updateLayerValues(forAnimationId: anim.value(forKey: "animId") as! String)
                removeAnimations(forAnimationId: anim.value(forKey: "animId") as! String)
            }
            completionBlock(flag)
        }
    }
    
    func updateLayerValues(forAnimationId identifier: String){
        if identifier == "rotation"{
            TTUtils.updateValueFromPresentationLayer(forAnimation: animationObject.layerToAnimate.animation(forKey: "starRotationAnim"), theLayer:animationObject.layerToAnimate)
        }
    }
    
    func removeAnimations(forAnimationId identifier: String){
        if identifier == "rotation"{
            animationObject.layerToAnimate.removeAnimation(forKey: "starRotationAnim")
        }
    }
    
    func removeIndefiniteAnimation() {
        animationObject.layerToAnimate.removeAnimation(forKey: "starRotationIndefiniteAnim")
    }
    
    func removeAllAnimations(){
        animationObject.layerToAnimate.removeAllAnimations()
    }
    
}
