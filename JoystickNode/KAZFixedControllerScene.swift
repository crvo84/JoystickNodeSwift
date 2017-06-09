//
//  KAZFixedControllerScene.swift
//  JoystickNode
//
//  Created by Carlos Villanueva Ousset on 6/8/17.
//  Copyright © 2017 Villou. All rights reserved.
//

import SpriteKit

class KAZFixedControllerScene: KAZControllerScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        
        moveJoystick.autoShowHide = false
        shootJoystick.autoShowHide = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func handleTouchBegan(_ touch: UITouch, location: CGPoint) {
        let touchedNodes = nodes(at: location)
        
        if let _ = (touchedNodes.filter { $0.name == KAZNodeName.moveJoystick }).first {
            moveJoystick.startControl(fromTouch: touch, location: location)
            
        } else if let _ = (touchedNodes.filter { $0.name == KAZNodeName.shootJoystick }).first {
            shootJoystick.startControl(fromTouch: touch, location: location)
        }
    }
}




