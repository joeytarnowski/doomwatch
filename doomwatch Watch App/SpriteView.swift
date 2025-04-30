//
//  SpriteView.swift
//  doomwatch Watch App
//
//  Created by Joey Tarnowski on 4/16/25.
//

import SwiftUI
import SpriteKit
import WatchKit

class DoomScene: SKScene {
    let doomRunner = DoomRunner()
    var texture: SKTexture?

    override func sceneDidLoad() {
        doomRunner.startDoom()

        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run { [weak self] in self?.renderFrame() },
            SKAction.wait(forDuration: 1.0 / 30.0)
        ])))
    }

    func renderFrame() {
        doomRunner.startDoom()

        if let buffer = doomRunner.getFramebuffer() {
            let width = Int(getDoomScreenWidth())
            let height = Int(getDoomScreenHeight())
            let data = Data(bytes: buffer, count: width * height * 4)
            texture = SKTexture(data: data, size: CGSize(width: width, height: height))
            texture?.filteringMode = .nearest

            removeAllChildren()

            let sprite = SKSpriteNode(texture: texture)
            sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            sprite.position = CGPoint(x: size.width / 2, y: size.height / 2) // Fix incorrect anchor point

            let verticalPaddingFactor: CGFloat = 0.8 // Force vertical size to be slightly smaller than full
            sprite.size = CGSize(width: size.width, height: size.height * verticalPaddingFactor) // Fix scaling
            sprite.yScale *= -1 // Fix vertical inversion

            addChild(sprite)
        }
    }
}
