//
//  GameScene.swift
//  ColorTouch
//
//  Created by Eric Internicola on 3/2/16.
//  Copyright (c) 2016 Eric Internicola. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var squares = [SKSpriteNode]()
    var lblTitle: SKLabelNode!
    var lblScore: SKLabelNode!
    var lblTimer: SKLabelNode!
    var currentColor: Int!
    var labelColor: Int!
    var currentScore = 0
    var isAlive = true
    var timerCount = 12

    let colors = [
        UIColor.redColor(),
        UIColor.greenColor(),
        UIColor.purpleColor(),
        UIColor.blueColor()
    ]
    let colorNames = [ "Red", "Green", "Purple", "Blue" ]

    let offWhiteColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
    let offBlackColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)

    var boxSize: CGFloat {
        // TODO: Landscape?
        return CGRectGetMaxX(frame) / 2 - 60
    }

    override func didMoveToView(view: SKView) {
        backgroundColor = offBlackColor
        spawnSquares()
        lblTitle = spawnTitle()
        lblScore = spawnScore()
        lblTimer = spawnTimer()
        randomizeColors()
        countDownTimer()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.locationInNode(self)
            if let touchedNode = nodeAtPoint(touchLocation) as? SKSpriteNode {
                for square in squares {
                    if touchedNode == square {
                        if touchedNode.color == colors[currentColor] {
                            addToScore()
                            randomizeColors()
                        } else {
                            gameOver()
                            isAlive = false
                        }
                    }
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}


// MARK: - Spawn Methods

extension GameScene {
    func spawnSquares() {
        squares.append(createSquare(colors[0], size: boxSize, position: CGPoint(x: CGRectGetMidX(frame)-20-boxSize/2, y: CGRectGetMidY(frame) + boxSize / 2 + 20)))
        squares.append(createSquare(colors[1], size: boxSize, position: CGPoint(x: CGRectGetMidX(frame)+20+boxSize/2, y: CGRectGetMidY(frame) + boxSize / 2 + 20)))
        squares.append(createSquare(colors[2], size: boxSize, position: CGPoint(x: CGRectGetMidX(frame)-20-boxSize/2, y: CGRectGetMidY(frame) - boxSize / 2 - 20)))
        squares.append(createSquare(colors[3], size: boxSize, position: CGPoint(x: CGRectGetMidX(frame)+20+boxSize/2, y: CGRectGetMidY(frame) - boxSize / 2 - 20)))
    }

    func spawnTitle() -> SKLabelNode {
        let title = SKLabelNode(fontNamed: "Futura")
        title.fontColor = offWhiteColor
        title.fontSize = 100
        title.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) + boxSize + 50)
        title.text = "Start!"

        addChild(title)

        return title
    }

    func spawnScore() -> SKLabelNode {
        let score = SKLabelNode(fontNamed: "Futura")
        score.fontColor = offWhiteColor
        score.fontSize = 30
        score.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - boxSize - 110)
        score.text = "Score: \(currentScore)"

        addChild(score)


        return score
    }

    func spawnTimer() -> SKLabelNode {
        let timer = SKLabelNode(fontNamed: "Futura")
        timer.fontColor = offWhiteColor
        timer.fontSize = 60
        timer.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - boxSize - 80)
        timer.text = "10"

        addChild(timer)

        
        return timer
    }
}

// MARK: - Helper Methods

extension GameScene {
    func resetGame() {
        let wait = SKAction.waitForDuration(4)
        let transition = SKAction.runBlock {
            if let gameScene = GameScene(fileNamed: "GameScene"), view = self.view {
                gameScene.scaleMode = .ResizeFill
                view.presentScene(gameScene, transition: SKTransition.doorwayWithDuration(0.5))
            }
        }

        runAction(SKAction.sequence([wait, transition]))
    }

    func gameOver() {
        lblTitle.fontColor = offWhiteColor
        lblTitle.text = "Game Over"
        lblTitle.fontSize = lblTitle.fontSize / 2
        lblTimer.text = "Try Again"
        lblTimer.fontSize = lblTimer.fontSize * 2 / 3

        for square in squares {
            square.removeFromParent()
        }

        resetGame()
    }

    func countDownTimer() {
        let wait = SKAction.waitForDuration(1)
        let countDown = SKAction.runBlock {
            guard self.isAlive else {
                return
            }

            self.timerCount = --self.timerCount
            if self.timerCount <= 10 {
                self.lblTimer.text = "\(self.timerCount)"
            }
            if self.timerCount <= 0 {
                self.gameOver()
            }
        }
        runAction(SKAction.repeatAction(SKAction.sequence([wait, countDown]), count: timerCount))
    }

    func randomizeColors() {
        currentColor = Int(arc4random_uniform(UInt32(colorNames.count)))
        labelColor = Int(arc4random_uniform(UInt32(colorNames.count)))
        printColors()
    }

    func printColors() {
        lblTitle.text = "\(colorNames[currentColor])"
        lblTitle.fontColor = colors[labelColor]
    }

    func createSquare(color: UIColor, size: CGFloat, position: CGPoint) -> SKSpriteNode {
        let square = SKSpriteNode(color: color, size: CGSize(width: size, height: size))
        square.position = position

        addChild(square)

        return square
    }

    func addToScore() {
        ++currentScore
        lblScore.text = "Score: \(currentScore)"
    }
}