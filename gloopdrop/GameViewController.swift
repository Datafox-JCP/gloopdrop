//
//  GameViewController.swift
//  gloopdrop
//
//  Created by Juan Carlos Pazos on 24/11/26.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the view
        if let view = self.view as! SKView? {
            // Create the scene
            let scene = GameScene(size: view.bounds.size)
            
            // Set the scale mode to scale to fill the view window
            scene.scaleMode = .aspectFill
            
            // Set the background color
            scene.backgroundColor = UIColor(
                red: 105/255,
                green: 157/255,
                blue: 181/255,
                alpha: 1.0
            )
            
            // Present the scene
            view.presentScene(scene)
            
            // Set the view options
            view.ignoresSiblingOrder = false
            view.showsPhysics = false
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
