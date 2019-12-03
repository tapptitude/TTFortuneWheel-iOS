//
//  TTFortuneWheel.swift
//  TTFortuneWheel
//
//  Created by Efraim Budusan on 9/29/17.
//  Copyright © 2017 Efraim Budusn. All rights reserved.
//

import UIKit

public class TTFortuneWheel: UIControl, CAAnimationDelegate, SpinningAnimatorProtocol {
    
    /// Set to true if you want all slices to be disributed evenly
    open var equalSlices:Bool = false
    
    open var slices:[FortuneWheelSliceProtocol]!
    
    /// UIConfiguration of the main frame
    open var frameStroke:StrokeInfo = StrokeInfo(color: TTUtils.uiColor(from: 0x6E17B3), width: 8)
    open var shadow:NSShadow?
    
    
    /// Set this to start drawing from that offset
    /// The sliced centerd to this offset will be 0 indexed one
    open var initialDrawingOffset:CGFloat = 0.0
    
    open var titleRotation:CGFloat = 0.0
    
    lazy private var animator:SpinningWheelAnimator = SpinningWheelAnimator(withObjectToAnimate: self)
    private(set) var sliceDegree:CGFloat?
    private(set) var wheelLayer:FortuneWheelLayer!

    public init(frame: CGRect, slices:[FortuneWheelSliceProtocol]) {
        super.init(frame: frame)
        self.slices = slices
        self.shadow = defaultShadow
        addWheelLayer()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.layer.needsDisplayOnBoundsChange = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.shadow = defaultShadow
    }
    
    func sliceInfoIsValid() -> Bool {
        if equalSlices{ return true }
        return slices.reduce(0, {$0 + $1.degree}) == 360
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        if let existing = wheelLayer {
            existing.removeFromSuperlayer()
        }
        addWheelLayer()
        assert(sliceInfoIsValid(), "All slices must have a 360 degree combined. Set equalSlices true if you want to distribute them evenly.")
        if equalSlices {
            sliceDegree = 360.0 / CGFloat(slices.count)
        }
    }
    
    private func addWheelLayer() {
        wheelLayer = FortuneWheelLayer(frame:self.bounds,parent:self,initialOffset:initialDrawingOffset)
        self.layer.addSublayer(wheelLayer)
        wheelLayer.setNeedsDisplay()
    }
    
    internal var defaultShadow:NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.5)
        shadow.shadowOffset = CGSize(width: 0, height: 0)
        shadow.shadowBlurRadius = 14
        return shadow
    }
    
    //// Animation conformance
    internal var layerToAnimate: CALayer {
        return self.wheelLayer
    }
    
    open func startAnimating(rotationCompletionOffset:CGFloat = 0.0, _ completion:((Bool) -> Void)?) {
        self.stopAnimating()
        self.animator.addRotationAnimation(completionBlock: completion,rotationOffset:rotationCompletionOffset)
    }
    
    open func startAnimating(fininshIndex:Int = 0, _ completion:((Bool) -> Void)?) {
        let rotation = 360.0 - computeRadian(from: fininshIndex)
        self.startAnimating(rotationCompletionOffset: rotation, completion)
    }
    
    open func startAnimating() {
        self.animator.addIndefiniteRotationAnimation()
    }
    
    open func stopAnimating() {
        self.animator.removeAllAnimations()
    }
    
    open func startAnimating(fininshIndex:Int = 0, offset:CGFloat, _ completion:((Bool) -> Void)?) {
        let rotation = 360.0 - computeRadian(from: fininshIndex) + offset 
        self.startAnimating(rotationCompletionOffset: rotation, completion)
    }
    
    private func computeRadian(from finishIndex:Int) -> CGFloat {
        if equalSlices {
            return CGFloat(finishIndex) * sliceDegree!
        }
        return slices.enumerated().filter({ $0.offset < finishIndex}).reduce(0.0, { $0 + $1.element.degree })
    }
}


