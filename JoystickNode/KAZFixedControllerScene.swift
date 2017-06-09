//
//  KAZFixedControllerScene.swift
//  JoystickNode
//
//  Created by Carlos Villanueva Ousset on 6/8/17.
//  Copyright © 2017 Villou. All rights reserved.
//

import SpriteKit

class KAZFixedControllerScene: SKScene {
    
    private struct NodeName {
        static let moveJoystick = "MoveJoystick"
        static let shootJoystick = "ShootJoystick"
        static let spaceship = "spaceship"
        static let bullet = "bullet"
    }
    
    fileprivate var sprite: SKSpriteNode
    fileprivate var moveJoystick: KAZJoystickNode
    fileprivate var shootJoystick: KAZJoystickNode
    fileprivate var lastUpdate: TimeInterval = 0
    
    override init(size: CGSize) {
        sprite = SKSpriteNode(imageNamed: NodeName.spaceship)
        moveJoystick = KAZJoystickNode()
        shootJoystick = KAZJoystickNode()
        
        super.init(size: size)
        
        backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.3, alpha: 1.0)
        
        sprite.setScale(0.5)
        sprite.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(sprite)
        
        moveJoystick.setOuterControl(withImageName: "outer", alpha: 0.25)
        moveJoystick.setInnerControl(withImageName: "inner", alpha: 0.5,
                                     nodeName: NodeName.moveJoystick)
        moveJoystick.movePoints = 8
        moveJoystick.autoShowHide = false
        moveJoystick.position = CGPoint(x: 150, y: 180)
        addChild(moveJoystick)
        
        shootJoystick.setOuterControl(withImageName: "outer", alpha: 0.25)
        shootJoystick.setInnerControl(withImageName: "inner", alpha: 0.5,
                                      nodeName: NodeName.shootJoystick)
        shootJoystick.autoShowHide = false
        shootJoystick.position = CGPoint(x: frame.width - 150, y: frame.height - 180)
        shootJoystick.defaultAngle = 90 // Default angle to report straight up for firing towards top
        addChild(shootJoystick)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            let touchedNodes = nodes(at: location)
            
            if let _ = (touchedNodes.filter { $0.name == NodeName.moveJoystick }).first {
                moveJoystick.startControl(fromTouch: touch, location: location)
            } else if let _ = (touchedNodes.filter { $0.name == NodeName.shootJoystick }).first {
                moveJoystick.startControl(fromTouch: touch, location: location)
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

    fileprivate func destinationPoint(forAngle angle: CGFloat) -> CGPoint {
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
        
        let bullet = SKSpriteNode(imageNamed: NodeName.bullet)
        bullet.position = sprite.position
        addChild(bullet)
        
        let movePoint = destinationPoint(forAngle: angle)
        let adjustedPoint = CGPoint(x: sprite.position.x + movePoint.x,
                                    y: sprite.position.y + movePoint.y)
        
        let moveAction = SKAction.move(to: adjustedPoint, duration: 1)
        let removeAction = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([moveAction, removeAction]))
    }
}




