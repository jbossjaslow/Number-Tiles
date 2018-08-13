//
//  Menu.swift
//  numberTiles
//
//  Created by Josh Jaslow on 7/21/17.
//  Copyright © 2017 Jaslow Enterprises. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit
import CoreData

class Menu: SKScene {
    weak var VC: GameViewController?
    
    var choice3x3 = SKSpriteNode()
    var choice4x4 = SKSpriteNode()
    var choice5x5 = SKSpriteNode()
    var choiceSettings = SKSpriteNode()
    
    var text3x3 = SKLabelNode()
    var text4x4 = SKLabelNode()
    var text5x5 = SKLabelNode()
    var textSettings = SKLabelNode()
    
    //MARK: - didMove
    override func didMove(to view: SKView) {
        choice3x3 = self.childNode(withName: "choice3x3") as! SKSpriteNode
        choice4x4 = self.childNode(withName: "choice4x4") as! SKSpriteNode
        choice5x5 = self.childNode(withName: "choice5x5") as! SKSpriteNode
        choiceSettings = self.childNode(withName: "choiceSettings") as! SKSpriteNode
        
        text3x3 = self.childNode(withName: "3x3") as! SKLabelNode
        text4x4 = self.childNode(withName: "4x4") as! SKLabelNode
        text5x5 = self.childNode(withName: "5x5") as! SKLabelNode
        textSettings = self.childNode(withName: "settings") as! SKLabelNode
    }
    
    ///MARK: - Touch Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var location: CGPoint? = nil
        for touch in touches {
            location = touch.location(in: self)
        }
        if choice3x3.contains(location!) {
            choice3x3.run(pulse)
            text3x3.run(pulse)
//            let scene: SKScene = scene3x3(fileNamed: "scene3x3")!
//            newScene(toScene: scene)
        }
        else if choice4x4.contains(location!) {
            choice4x4.run(pulse)
            text4x4.run(pulse)
            let scene: SKScene = scene4x4(fileNamed: "scene4x4")!
            newScene(toScene: scene)
        }
        else if choice5x5.contains(location!) {
            choice5x5.run(pulse)
            text5x5.run(pulse)
            //let scene: SKScene = GameScene(fileNamed: "GameScene")!
            //newScene(toScene: scene)
        }
        else if choiceSettings.contains(location!) {
            choiceSettings.run(pulse)
            textSettings.run(pulse)
            if let scene = settings(fileNamed: "Settings") {
                scene.settingsVC = VC
                newScene(toScene: scene)
            }
        }
    }
    
    //MARK: - Update
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    //MARK: - Extra Functions
    func newScene(toScene: SKScene) {
        if deviceIsIpad() {
            toScene.scaleMode = .aspectFit
        }
        else {
            toScene.scaleMode = .aspectFill
        }
        let transition: SKTransition = SKTransition.fade(withDuration: 0.75)
        transition.pausesOutgoingScene = false
        self.view?.presentScene(toScene, transition: transition)
    }
}

//MARK: - Global
var image: UIImage? = nil

func fadeIn(node: SKNode, duration: Double) {
    let fadeIn = SKAction.fadeIn(withDuration: duration)
    node.run(fadeIn)
}

func fadeOut(node: SKNode, duration: Double) {
    let fadeOut = SKAction.fadeOut(withDuration: duration)
    node.run(fadeOut)
}
