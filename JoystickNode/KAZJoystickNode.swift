//
//  KAZJoystickNode.swift
//  JoystickNode
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/7/17.
//  Copyright © 2017 Villou. All rights reserved.
//

import SpriteKit

class KAZJoystickNode: SKNode {
    
    var isMoving = false
    var autoShowHide = true { didSet { alpha = autoShowHide ? 0.0 : 1.0 } }
    var moveSize = CGSize.zero
    var startTouch: UITouch?
    var movePoints: CGFloat?
    var angle: CGFloat?
    var defaultAngle: CGFloat? { didSet { angle = defaultAngle } }
    
    fileprivate var outerControl: SKSpriteNode?
    fileprivate var innerControl: SKSpriteNode?
    fileprivate var startPoint: CGPoint?
    
    // Interface
    
    func setInnerControl(withImageName imageName: String, alpha: CGFloat, nodeName: String? = nil) {
        innerControl?.removeFromParent()
        innerControl = SKSpriteNode(imageNamed: imageName)
        
        guard let innerControl = innerControl else { return }
        
        innerControl.alpha = alpha
        innerControl.name = nodeName
        addChild(innerControl)
    }
    
    func setOuterControl(withImageName imageName: String, alpha: CGFloat) {
        outerControl?.removeFromParent()
        outerControl = SKSpriteNode(imageNamed: imageName)
        
        guard let outerControl = outerControl else { return }
        
        outerControl.alpha = alpha
        addChild(outerControl)
    }
    
    func startControl(fromTouch: UITouch, location: CGPoint) {
        if autoShowHide {
            alpha = 1.0
            position = location
        }
        
        startTouch = fromTouch
        startPoint = location
        isMoving = true
    }
    
    func moveControl(toTouch: UITouch, location: CGPoint) {
        guard
            let outerControl = outerControl,
            let innerControl = innerControl,
            let movePoints = movePoints,
            let startPoint = startPoint
            else { return }
        
        // Get the outer ring radius
        let outerRadius = outerControl.size.width/2
        
        var newMovePoints = movePoints
        // Get the change in X
        let deltaX = location.x - startPoint.x
        // Get the change in Y
        let deltaY = location.y - startPoint.y
        // Calculate the distance the stick is from the center point
        let distance = sqrt((deltaX * deltaX) + (deltaY * deltaY))
        // Get the angle of movement
        angle = atan2(deltaY, deltaX) * 180.0 / CGFloat.pi
        // Is it moving left?
        let isLeft = abs(angle!) > 90.0
        // Convert the angle to radians
        let radians = angle! * CGFloat.pi / 180.0
        
        if distance < outerRadius {
            // If the distance is less than the radius, it moves freely
            innerControl.position = toTouch.location(in: self)
            newMovePoints = distance / outerRadius * movePoints
        } else {
            // If the distance is greater than the radius, we'll lock it to bounds of the outer size radius
            let maxY = outerRadius * sin(radians)
            var maxX = sqrt((outerRadius * outerRadius) - (maxY * maxY))
            if isLeft {
                maxX *= -1
            }
            innerControl.position = CGPoint(x: maxX, y: maxY)
        }
        
        // Calculate Y Movement
        let moveY = newMovePoints * sin(radians)
        // Calculate X Movement
        var moveX = sqrt((movePoints * movePoints) - (moveY * moveY))
        // Adjust if it's going left
        if isLeft {
            moveX *= -1;
        }
        
        moveSize = CGSize(width: moveX, height: moveY)
    }
    
    func endControl() {
        isMoving = false
        reset()
    }
    
    func reset() {
        if autoShowHide {
            alpha = 0.0
        }
        
        moveSize = CGSize.zero
        angle = defaultAngle
        innerControl?.position = CGPoint.zero
    }
}
