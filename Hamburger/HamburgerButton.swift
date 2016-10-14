//
//  HamburgerButton.swift
//
//  Created by Kurt Jensen on 10/12/16.
//

import CoreGraphics
import QuartzCore
import UIKit

class PathShapeLayer: CAShapeLayer {
    
    fileprivate (set) var size: CGFloat = 44
    fileprivate let padding: CGFloat = 10
    fileprivate var side: CGFloat {
        return size - padding
    }
    fileprivate var isOn: Bool = false
    
    var startPath: UIBezierPath? {
        return nil
    }
    var endPath: UIBezierPath? {
        return nil
    }
    
    var previousPath: UIBezierPath? {
        return isOn ? startPath : endPath
    }
    
    var currentPath: UIBezierPath? {
        return isOn ? endPath : startPath
    }
    
    convenience init(size: CGFloat) {
        self.init()
        self.size = size
    }
    
}

class TopMenuShapeLayer: PathShapeLayer {
    
    override var startPath: UIBezierPath? {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: padding, y: size/3))
        path.addLine(to: CGPoint(x: side, y: size/3))
        return path
    }
    
    override var endPath: UIBezierPath? {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: size/4+padding, y: size/4 + padding))
        path.addLine(to: CGPoint(x: size/2+HamburgerButton.lineWidth/4, y: padding))
        return path
    }
}

class MiddleMenuShapeLayer: PathShapeLayer {
    override var startPath: UIBezierPath? {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: padding, y: size/2))
        path.addLine(to: CGPoint(x: side, y: size/2))
        return path
    }
    
    override var endPath: UIBezierPath? {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: size/2-HamburgerButton.lineWidth/4, y: padding))
        path.addLine(to: CGPoint(x: size*3/4-padding, y: size/4 + padding))
        return path
    }
}

class BottomMenuShapeLayer: PathShapeLayer {
    override var startPath: UIBezierPath? {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: padding, y: size*2/3))
        path.addLine(to: CGPoint(x: side, y: size*2/3))
        return path
    }
    
    override var endPath: UIBezierPath? {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: size/2, y: padding))
        path.addLine(to: CGPoint(x: size/2, y: side))
        return path
    }
}

public class HamburgerButton: UIButton {
    
    static let lineWidth: CGFloat = 2
    
    public var color: UIColor = UIColor.white {
        didSet {
            for shapeLayer in shapeLayers {
                shapeLayer.strokeColor = color.cgColor
            }
        }
    }
    
    private var top: PathShapeLayer!
    private var middle: PathShapeLayer!
    private var bottom: PathShapeLayer!
    private var shapeLayers: [PathShapeLayer] {
        return [top, middle, bottom]
    }
    private var size: CGFloat {
        return max(bounds.width, bounds.height)
    }
    
    var isMenu = false {
        didSet {
            animate(toMenu: isMenu)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        top = TopMenuShapeLayer(size: size)
        middle = MiddleMenuShapeLayer(size: size)
        bottom = BottomMenuShapeLayer(size: size)
        
        for shapeLayer in shapeLayers {
            shapeLayer.path = shapeLayer.startPath?.cgPath
            shapeLayer.lineWidth = HamburgerButton.lineWidth
            shapeLayer.strokeColor = color.cgColor
            
            shapeLayer.actions = [
                "path": NSNull()
            ]
            
            layer.addSublayer(shapeLayer)
        }
    }
    
    func animate(toMenu: Bool) {
        for shapeLayer in shapeLayers {
            shapeLayer.isOn = toMenu
            shapeLayer.path = shapeLayer.previousPath?.cgPath
            let animation = CABasicAnimation(keyPath: "path")
            animation.toValue = shapeLayer.currentPath?.cgPath
            animation.duration = 0.4
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            animation.fillMode = kCAFillModeBoth
            animation.isRemovedOnCompletion = false
            shapeLayer.add(animation, forKey: animation.keyPath)
        }
        
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        for shapeLayer in shapeLayers {
            shapeLayer.size = size
        }
    }
    
}

