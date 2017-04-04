//
//  GameScene.swift
//  arkanoid
//
//  Created by Dmitry Kolesnichenko on 4/4/17.
//  Copyright © 2017 Dmitry K. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ball:SKSpriteNode!
    var racket:SKSpriteNode!
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score:\(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "Ball") as! SKSpriteNode
        racket = self.childNode(withName: "Racket") as! SKSpriteNode
        scoreLabel = self.childNode(withName: "Score") as! SKLabelNode
        
        ball.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 50))
        let border = SKPhysicsBody(edgeLoopFrom: (view.scene?.frame)!)
        border.friction = 0
        self.physicsBody = border
        
        self.physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.location(in: self)
            racket.position.x = touchLocation.x
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.location(in: self)
            racket.position.x = touchLocation.x
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyAName = contact.bodyA.node?.name
        let bodyBName = contact.bodyB.node?.name
        
        if bodyAName == "Ball" && bodyBName == "Block" || bodyAName == "Block" && bodyBName == "Ball"{
            if bodyAName == "Block" {
                contact.bodyA.node?.removeFromParent()
                score += 1
            } else if bodyBName == "Block"{
                contact.bodyB.node?.removeFromParent()
                score += 1
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (score == 9){
            scoreLabel.text = "You won the game."
            self.view?.isPaused = true
        }
        
        if(ball.position.y < racket.position.y){
            scoreLabel.text = "You lost the game."
            self.view?.isPaused = true
        }
    }
}
