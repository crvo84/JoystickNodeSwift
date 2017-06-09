//
//  KAZDynamicControllerScene.swift
//  JoystickNode
//
//  Created by Carlos Villanueva Ousset on 6/7/17.
//  Copyright © 2017 Villou. All rights reserved.
//

import SpriteKit

class KAZDynamicControllerScene: KAZControllerScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        
        shootJoystick.autoShowHide = true
        moveJoystick.autoShowHide = true
        
        createMoveHelper()
        createShootHelper()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func createShootHelper() {
        let shape = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(CGRect(x: size.width/2, y: 0, width: size.width/2, height: size.height))
        shape.path = path
        shape.fillColor = UIColor.green
        shape.strokeColor = UIColor.white
        shape.position = CGPoint.zero
        shape.alpha = 0.25
        addChild(shape)

        let helper = SKLabelNode(fontNamed: "Courier")
        helper.fontColor = UIColor.white
        helper.fontSize = 14
        helper.text = "Tap here to show fire joystick"
        helper.position = CGPoint(x: size.width/2 + size.width/4, y: shape.frame.midY)
        addChild(helper)
    }
    
    fileprivate func createMoveHelper() {
        let shape = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: size.width/2, height: size.height))
        shape.path = path
        shape.fillColor = UIColor.green
        shape.strokeColor = UIColor.white
        shape.position = CGPoint.zero
        shape.alpha = 0.25
        addChild(shape)
        
        let helper = SKLabelNode(fontNamed: "Courier")
        helper.fontColor = UIColor.white
        helper.fontSize = 14
        helper.text = "Tap here to show move joystick"
        helper.position = CGPoint(x: size.width/2/2, y: shape.frame.midY)
        addChild(helper)
    }

    override func handleTouchBegan(_ touch: UITouch, location: CGPoint) {
        // If the user touches the left side of the screen, use the move joystick
        if location.x < size.width/2 {
            moveJoystick.startControl(fromTouch: touch, location: location)
        } else {
            shootJoystick.startControl(fromTouch: touch, location: location)
        }
    }
}


















