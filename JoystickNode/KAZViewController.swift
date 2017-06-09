//
//  KAZViewController.swift
//  JoystickNode
//
//  Created by Carlos Villanueva Ousset on 6/8/17.
//  Copyright © 2017 Villou. All rights reserved.
//

import UIKit
import SpriteKit

class KAZViewController: UIViewController {
    
    override var shouldAutorotate: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let skView = view as? SKView {
            // Configure view
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            // Create and configure scene
            let scene = KAZDynamicControllerScene(size: skView.bounds.size)
            scene.scaleMode = .aspectFill
            
            // Present scene
            skView.presentScene(scene)
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    @IBAction func changeScene(_ sender: UISegmentedControl) {
        guard let skView = view as? SKView else { return }
        
        let scene: SKScene
        if sender.selectedSegmentIndex == 0 {
            scene = KAZDynamicControllerScene(size: skView.bounds.size)
        } else {
            // TODO: present fixed controller scene
            scene = KAZFixedControllerScene(size: skView.bounds.size)
        }
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }
}
