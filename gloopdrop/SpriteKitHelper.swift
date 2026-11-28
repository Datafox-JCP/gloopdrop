//
//  SpriteKitHelper.swift
//  gloopdrop
//
//  Created by Juan Carlos Pazos on 25/11/26.
//

import Foundation
import SpriteKit

// MARK: - SpriteKit helpers

// Set up shared z-positions
enum Layer: CGFloat {
    case background
    case foreground
    case player
    case collectible
    case ui
}

// SpriteKit physics categories
enum PhysicsCategory {
    static let none: UInt32 = 0
    static let player: UInt32 = 0b1 // 1
    static let collectible: UInt32 = 0b10 // 2
    static let foreground: UInt32 = 0b100 // 4
}

// MARK: - SpiteKit extensions

extension SKSpriteNode {
    // Used to create an endless scrolling background
    func endlessScroll(speed: TimeInterval) {
        // Set up actions to move and reset nodes
        let moveAction = SKAction.moveBy(x: -self.size.width, y: 0, duration: speed)
        let resetAction = SKAction.moveBy(x: self.size.width, y: 0, duration: 0.0)
        
        // Set up a sequence of repeating actions
        let sequenceAction = SKAction.sequence([moveAction, resetAction])
        let repeatAction = SKAction.repeatForever(sequenceAction)
        
        // Run the repeatin action
        self.run(repeatAction)
    }
    
   // Used to load texture arrays for animations
    func loadTextures(atlas: String, prefix: String, startsAt: Int, stopsAt: Int) -> [SKTexture] {
        var textureArray = [SKTexture]()
        let textureAtlas = SKTextureAtlas(named: atlas)
        
        for i in startsAt...stopsAt {
            let texttureName = "\(prefix)\(i)"
            let temp = textureAtlas.textureNamed(texttureName)
            textureArray.append(temp)
        }
        
        return textureArray
    }
    
    // Start the animation using a name and a count(0 = repeat forever)
    func startAnimation(textures: [SKTexture], speed: Double, name: String, count: Int, resize: Bool, restore: Bool) {
        // Run animation only if animation key doesn't already exist
        if (action(forKey: name) == nil) {
            let animation = SKAction.animate(with: textures, timePerFrame: speed, resize: resize, restore: restore)
            
            if count == 0 {
                // Run animation until stopped
                let repeatAction = SKAction.repeatForever(animation)
                run(repeatAction, withKey: name)
            } else if count == 1 {
                run(animation, withKey: name)
            } else {
                let repeatAction = SKAction.repeat(animation, count: count)
                run(repeatAction, withKey: name)
            }
        }
    }
}

extension SKScene {
    // Top of view
    func viewTop() -> CGFloat {
        return convertPoint(fromView: CGPoint(x: 0.0, y: 0)).y
    }
    
    // Bottom of view
    func viewBottom() -> CGFloat {
        guard let view = view else { return 0.0 }
        return convertPoint(fromView: CGPoint(x: 0.0, y: view.bounds.size.height)).y
    }
}

extension SKNode {
    // USed to set up an endless scroller
    func setupScrollingView(imageNamed name: String, layer: Layer, emmiterNamed: String?, blocks: Int, speed: TimeInterval) {
        // Create sprite nodes; set positions based on the node's # and with
        for i in 0..<blocks {
            let spriteNode = SKSpriteNode(imageNamed: name)
            spriteNode.anchorPoint = CGPoint.zero
            spriteNode.position = CGPoint(x: CGFloat(i) * spriteNode.size.width, y: 0)
            spriteNode.zPosition = layer.rawValue
            spriteNode.name = name
            
            // Set up optional particles
            if let emmiterNamed = emmiterNamed,
               let particles = SKEmitterNode(fileNamed: emmiterNamed) {
                particles.name = "particles"
                
                // Center the emitter over the top half of the block so the
                // particles spawn on the visible surface of the image
                particles.position = CGPoint(x: spriteNode.size.width / 2, y: spriteNode.size.height * 0.75)
                particles.particlePositionRange = CGVector(dx: spriteNode.size.width, dy: spriteNode.size.height / 2)
                
                spriteNode.addChild(particles)
            }
            
            // Use the custom extension to scroll
            spriteNode.endlessScroll(speed: speed)
            
            // Add the sprite node to the container
            addChild(spriteNode)
        }
    }
}
