//
//  KAZDynamicControllerScene.swift
//  JoystickNode
//
//  Created by Carlos Villanueva Ousset on 6/7/17.
//  Copyright © 2017 Villou. All rights reserved.
//

import SpriteKit

class KAZDynamicControllerScene: SKScene {
    
    fileprivate var sprite: SKSpriteNode
    fileprivate var moveJoystick: KAZJoystickNode
    fileprivate var shootJoystick: KAZJoystickNode
    fileprivate var lastUpdate: TimeInterval = 0
    
    override init(size: CGSize) {
        sprite = SKSpriteNode(imageNamed: "Spaceship")
        moveJoystick = KAZJoystickNode()
        shootJoystick = KAZJoystickNode()
        
        super.init(size: size)
        
        backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.3, alpha: 1.0)
        
        sprite.setScale(0.5)
        sprite.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(sprite)
        
        moveJoystick.setOuterControl(withImageName: "outer", alpha: 0.25)
        moveJoystick.setInnerControl(withImageName: "inner", alpha: 0.5)
        moveJoystick.movePoints = 8
        addChild(moveJoystick)
        
        shootJoystick.setOuterControl(withImageName: "outer", alpha: 0.25)
        shootJoystick.setInnerControl(withImageName: "inner", alpha: 0.5)
        shootJoystick.defaultAngle = 90 // Default angle to report straight up for firing towards top
        addChild(shootJoystick)
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            // If the user touches the left side of the screen, use the move joystick
            if location.x < size.width/2 {
                moveJoystick.startControl(fromTouch: touch, location: location)
            } else {
                shootJoystick.startControl(fromTouch: touch, location: location)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if touch == moveJoystick.startTouch {
                moveJoystick.moveControl(toTouch: touch, location: location)
            } else if touch == shootJoystick.startTouch {
                shootJoystick.moveControl(toTouch: touch, location: location)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == moveJoystick.startTouch {
                moveJoystick.endControl()
            } else if touch == shootJoystick.startTouch {
                shootJoystick.endControl()
            }
        }
    }
    
    fileprivate func destinationPointForAngle(_ angle: CGFloat) -> CGPoint {
        let angleInRadians = angle * CGFloat.pi / 180.0
        // For an easy calculation
        let distanceToOffScreen: CGFloat = 1000;
        // Calculate Y Movement
        let moveY = distanceToOffScreen * sin(angleInRadians)
        // Calculate X Movement
        var moveX = sqrt((distanceToOffScreen * distanceToOffScreen) - (moveY * moveY))
        if let angle = shootJoystick.angle, angle > 90 {
            // isLeft
            moveX *= -1
        }
        
        return CGPoint(x: moveX, y: moveY)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Shoot bullets every half second
        if currentTime - lastUpdate >= 0.5 {
            shootBullet()
            lastUpdate = currentTime
        }
        
        if moveJoystick.isMoving {
            var adjustedSpritePosition = CGPoint(x: sprite.position.x + moveJoystick.moveSize.width,
                                                 y: sprite.position.y + moveJoystick.moveSize.height)
            if adjustedSpritePosition.x < 0 {
                adjustedSpritePosition.x = 0
            } else if adjustedSpritePosition.x > size.width {
                adjustedSpritePosition.x = size.width
            }
            
            if adjustedSpritePosition.y < 0 {
                adjustedSpritePosition.y = 0
            } else if adjustedSpritePosition.y > size.height {
                adjustedSpritePosition.y = size.height
            }
            
            sprite.position = adjustedSpritePosition
        }
    }
    
    fileprivate func shootBullet() {
        guard let angle = shootJoystick.angle else { return }
        
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.position = sprite.position
        addChild(bullet)
        
        let movePoint = destinationPointForAngle(angle)
        let adjustedPoint = CGPoint(x: sprite.position.x + movePoint.x,
                                    y: sprite.position.y + movePoint.y)
        
        let moveAction = SKAction.move(to: adjustedPoint, duration: 1)
        let removeAction = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([moveAction, removeAction]))
    }
}


















