//
//  scene4x4.swift
//  numberTiles
//
//  Created by Josh Jaslow on 6/17/17.
//  Copyright © 2017 Jaslow Enterprises. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreData

class scene4x4: SKScene {
    
    var gameBoard: [[tile]] = [[]]
    var row: [tile] = []
    var canMoveTile: Bool = true
    
    var gameBoardExtra: [[tile]] = [[]]
    
    var moves: [String] = []
    
    var backButton = SKSpriteNode()
    var backText = SKLabelNode()
    
    weak var timer: Timer?
    var start: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    var timerIsGoing: Bool = false
    var timeMinute = SKLabelNode()
    var timeSecond = SKLabelNode()
    var timeMillisecond = SKLabelNode()
    var startStop = SKLabelNode()
    
    var reset = SKSpriteNode()
    var randomize = SKSpriteNode()
    var solvingInProcess: Bool = false
    var randomized: Bool = false
    var tile31Pos = CGPoint(x: 300, y: 450)
    var tile32Pos = CGPoint(x: 450, y: 450)
    
    var tile00 = SKSpriteNode()
    var tile01 = SKSpriteNode()
    var tile02 = SKSpriteNode()
    var tile03 = SKSpriteNode()
    var tile10 = SKSpriteNode()
    var tile11 = SKSpriteNode()
    var tile12 = SKSpriteNode()
    var tile13 = SKSpriteNode()
    var tile20 = SKSpriteNode()
    var tile21 = SKSpriteNode()
    var tile22 = SKSpriteNode()
    var tile23 = SKSpriteNode()
    var tile30 = SKSpriteNode()
    var tile31 = SKSpriteNode()
    var tile32 = SKSpriteNode()
    
    var number00 = SKLabelNode()
    var number01 = SKLabelNode()
    var number02 = SKLabelNode()
    var number03 = SKLabelNode()
    var number10 = SKLabelNode()
    var number11 = SKLabelNode()
    var number12 = SKLabelNode()
    var number13 = SKLabelNode()
    var number20 = SKLabelNode()
    var number21 = SKLabelNode()
    var number22 = SKLabelNode()
    var number23 = SKLabelNode()
    var number30 = SKLabelNode()
    var number31 = SKLabelNode()
    var number32 = SKLabelNode()
    
    //MARK: - didMove
    override func didMove(to view: SKView) {
        reset = self.childNode(withName: "reset") as! SKSpriteNode
        randomize = self.childNode(withName: "randomize") as! SKSpriteNode
        
        backButton = self.childNode(withName: "backButton") as! SKSpriteNode
        backText = self.childNode(withName: "backText") as! SKLabelNode
        
        timeMinute = self.childNode(withName: "timeMinute") as! SKLabelNode
        timeSecond = self.childNode(withName: "timeSecond") as! SKLabelNode
        timeMillisecond = self.childNode(withName: "timeMillisecond") as! SKLabelNode
        startStop = self.childNode(withName: "startStop") as! SKLabelNode
        
        tile00 = self.childNode(withName: "tile00") as! SKSpriteNode
        tile01 = self.childNode(withName: "tile01") as! SKSpriteNode
        tile02 = self.childNode(withName: "tile02") as! SKSpriteNode
        tile03 = self.childNode(withName: "tile03") as! SKSpriteNode
        tile10 = self.childNode(withName: "tile10") as! SKSpriteNode
        tile11 = self.childNode(withName: "tile11") as! SKSpriteNode
        tile12 = self.childNode(withName: "tile12") as! SKSpriteNode
        tile13 = self.childNode(withName: "tile13") as! SKSpriteNode
        tile20 = self.childNode(withName: "tile20") as! SKSpriteNode
        tile21 = self.childNode(withName: "tile21") as! SKSpriteNode
        tile22 = self.childNode(withName: "tile22") as! SKSpriteNode
        tile23 = self.childNode(withName: "tile23") as! SKSpriteNode
        tile30 = self.childNode(withName: "tile30") as! SKSpriteNode
        tile31 = self.childNode(withName: "tile31") as! SKSpriteNode
        tile32 = self.childNode(withName: "tile32") as! SKSpriteNode
        
        number00 = self.childNode(withName: "number00") as! SKLabelNode
        number01 = self.childNode(withName: "number01") as! SKLabelNode
        number02 = self.childNode(withName: "number02") as! SKLabelNode
        number03 = self.childNode(withName: "number03") as! SKLabelNode
        number10 = self.childNode(withName: "number10") as! SKLabelNode
        number11 = self.childNode(withName: "number11") as! SKLabelNode
        number12 = self.childNode(withName: "number12") as! SKLabelNode
        number13 = self.childNode(withName: "number13") as! SKLabelNode
        number20 = self.childNode(withName: "number20") as! SKLabelNode
        number21 = self.childNode(withName: "number21") as! SKLabelNode
        number22 = self.childNode(withName: "number22") as! SKLabelNode
        number23 = self.childNode(withName: "number23") as! SKLabelNode
        number30 = self.childNode(withName: "number30") as! SKLabelNode
        number31 = self.childNode(withName: "number31") as! SKLabelNode
        number32 = self.childNode(withName: "number32") as! SKLabelNode
        
        for x in 0...3 {
            gameBoard.append(row)
            for y in 0...3 {
                gameBoard[x].append(tile(posX: x, posY: y, name: "tile\(x)\(y)"))
            }
        }
        gameBoard[3][3].name = "specialTile"
        
        for x in 0...3 {
            gameBoardExtra.append(row)
            for y in 0...3 {
                gameBoardExtra[x].append(tile(posX: x, posY: y, name: "tile\(x)\(y)"))
            }
        }
        gameBoardExtra[3][3].name = "specialTile"
        
        if !textureArr.isEmpty {
            var i = 0
            for x in 0...3 {
                for y in 0...3 {
                    num(name: "number\(x)\(y)").isHidden = true
                    image(name: "tile\(x)\(y)").texture = textureArr[i]
                    i += 1
                }
            }
            tile32.texture = textureArr[0]
        }
    }
    
    //MARK: - Touch Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var xCoordinate = -1; var yCoordinate = -1
        var location: CGPoint? = nil
        for touch in touches {
            location = touch.location(in: self)
        }
        canMoveTile = true
        
        if reset.contains(location!) {
            reset.run(pulse)
            resetGame()
            resetTime()
        }
        else if randomize.contains(location!) && !randomized {
            randomize.run(pulse)
            randomizeBoard()
        }
        else if startStop.contains(location!) {
            toggleStartStop()
        }
        else if backButton.contains(location!) {
            backButton.run(pulse)
            backText.run(pulse)
            resetTime()
            let transition: SKTransition = SKTransition.fade(withDuration: 0.75)
            transition.pausesOutgoingScene = false
            let scene: SKScene = Menu(fileNamed: "Menu")!
            if deviceIsIpad() {
                scene.scaleMode = .aspectFit
            }
            else {
                scene.scaleMode = .aspectFill
            }
            self.view?.presentScene(scene, transition: transition)
        }
        else {
            switch Int((location?.x)!) {
            case 75...225:
                xCoordinate = 0
            case 225...375:
                xCoordinate = 1
            case 375...525:
                xCoordinate = 2
            case 525...675:
                xCoordinate = 3
            default:
                print("")//print("Tapping off board in x direction")
            }
            switch Int((location?.y)!) {
            case 375...525:
                yCoordinate = 3
            case 525...675:
                yCoordinate = 2
            case 675...825:
                yCoordinate = 1
            case 825...975:
                yCoordinate = 0
            default:
                print("")//print("Tapping off board in y direction")
            }
            if xCoordinate >= 0 && yCoordinate >= 0 {
                print("xCoor: \(yCoordinate), yCoor: \(xCoordinate)")
                swapArray(Tile: gameBoard[yCoordinate][xCoordinate], duration: 0.2)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*var location: CGPoint? = nil
        for touch in touches {
            location = touch.location(in: self)
        }*/
    }
    
    //MARK: - Update
    override func update(_ currentTime: TimeInterval) {
        for x in 0...3 {
            for y in 0...3 {
                if gameBoard[x][y].name != gameBoardExtra[x][y].name { //Game not finished
                    randomized = true
                    break
                }
                else { //Game is finished
                    randomized = false
                    //stopTime()
                }
            }
        }
    }
    
    //MARK: - Tile Swapping
    func swapArray(Tile: tile, duration: Double) {
        let X = Tile.posX; let Y = Tile.posY
        
        var newX = 0; var newY = 0
        
        if X != 3 && gameBoard[X+1][Y].name == "specialTile" {
            newX = X+1; newY = Y
        }
        else if X != 0 && gameBoard[X-1][Y].name == "specialTile" {
            newX = X-1; newY = Y
        }
        else if Y != 3 && gameBoard[X][Y+1].name == "specialTile" {
            newX = X; newY = Y+1
        }
        else if Y != 0 && gameBoard[X][Y-1].name == "specialTile" {
            newX = X; newY = Y-1
        }
        else {
            print("You can't move that tile")
            canMoveTile = false
        }
        
        if canMoveTile {
            if !solvingInProcess {
                moves.append(Tile.name)
            }
            swap(&gameBoard[newX][newY], &gameBoard[X][Y])
            print("Moving \(Tile.name) from \(X), \(Y) to \(newX), \(newY)")
        
            Tile.moveToPos(posX: newX, posY: newY) //Update chosen tile's coordinates
            gameBoard[X][Y].moveToPos(posX: X, posY: Y) //Update specialTile's coordinates
        
            moveImage(Tile: Tile, duration: duration)//Number and box images follow tile to new spot
        }
        
    }
    
    func moveImage(Tile: tile, duration: Double) {
        let name = Tile.name
        let Image = image(name: Tile.name)
        let Number = num(name: "number\(name.substring(from: name.index(name.endIndex, offsetBy: -2)))")
        let newX = 150 + (Tile.posY * 150); let newY = 900 - (Tile.posX * 150)
        let point = CGPoint(x: newX, y: newY)
        let moveAction = SKAction.move(to: point, duration: duration)
        moveAction.timingMode = .easeInEaseOut
        Image.run(moveAction)
        Number.run(moveAction)
        
    }
    
    func image(name: String) -> SKSpriteNode {
        var sprite = SKSpriteNode()
        for node in self.children {
            if node.name == name {
                sprite = node as! SKSpriteNode
                break
            }
        }
        return sprite
    }
    
    func num(name: String) -> SKLabelNode {
        var number = SKLabelNode()
        for node in self.children {
            if node.name == name {
                number = node as! SKLabelNode
                break
            }
        }
        return number
    }
    
    //MARK: - Reset, Solve, Randomize
    func resetGame() {
        randomized = false
        
        gameBoard.removeAll()
        for x in 0...3 {
            gameBoard.append(row)
            for y in 0...3 {
                gameBoard[x].append(tile(posX: x, posY: y, name: "tile\(x)\(y)"))
            }
        }
        gameBoard[3][3].name = "specialTile"
        for x in 0...3 {
            for y in 0...3 {
                moveImage(Tile: gameBoard[x][y], duration: 0.25)
            }
        }
    }
    
//    func solveGame() {
//        solvingInProcess = true
//        for _ in 0..<moves.count {
//            let moveName = moves.popLast()
//            var Tile = tile(posX: 0, posY: 0, name: "")
//            for x in 0...3 {
//                for y in 0...3 {
//                    if gameBoard[x][y].name == moveName {
//                        Tile = gameBoard[x][y]
//                        break
//                    }
//                }
//            }
//            swapArray(Tile: Tile, duration: 0.75)
//        }
//    }
    
    func randomizeBoard() {
        //Permutation is a swap of 2 pieces (they don't need to be adjacent or next to blank piece
        //In order to be solvable, # of permutations made needs to be even (0, 2, 4, etc...)
        //Odd # of permutations makes it unsolvable
        var count = 20
        
        for _ in 0...count {
            let randX1 = randomInt(num: 4); var randY1 = randomInt(num: 4)
            if randX1 == 3 && randY1 == 3 {
                randY1 = randomInt(num: 3)
            }
            let randX2 = randomInt(num: 4); var randY2 = randomInt(num: 4)
            if randX2 == 3 && randY2 == 3 {
                randY2 = randomInt(num: 3)
            }
            
            let tile1 = findTile(nameIntX: randX1, nameIntY: randY1)
            let tile2 = findTile(nameIntX: randX2, nameIntY: randY2)
            
            if tile1.name != tile2.name {
                tile1.printPos(); tile2.printPos()
                swap(&gameBoard[tile1.posX][tile1.posY], &gameBoard[tile2.posX][tile2.posY])
                
                let a = tile1.posX; let b = tile1.posY
                tile1.moveToPos(posX: tile2.posX, posY: tile2.posY)
                tile2.moveToPos(posX: a, posY: b)
                
                moveImage(Tile: tile1, duration: 0.25)
                moveImage(Tile: tile2, duration: 0.25)
            }
            else {
                count -= 1
            }
        }
        randomized = true
        startTime()
        timerIsGoing = true
    }
    
    //MARK: - Find Tile
    func findTile(nameIntX: Int, nameIntY: Int) -> tile {
        var Tile = tile(posX: 0, posY: 0, name: "")
        for x in 0...3 {
            for y in 0...3 {
                if gameBoard[x][y].name == "tile\(nameIntX)\(nameIntY)" {
                    Tile = gameBoard[x][y]
                }
            }
        }
        return Tile
    }
    
    //MARK: - Timer Stuffs
    func toggleStartStop() {
        if (timerIsGoing) {
            stopTime()
            timerIsGoing = false
        }
        else {
            startTime()
            timerIsGoing = true
        }
    }
    
    func resetTime() {
        
        // Invalidate timer
        timer?.invalidate()
        
        // Reset timer variables
        start = 0
        time = 0
        elapsed = 0
        timerIsGoing = false
        
        // Reset all three labels to 00
        let str = "00"
        timeMinute.text = str
        timeSecond.text = str
        timeMillisecond.text = str
        
    }
    
    func startTime() {
        resetTime()
        start = Date().timeIntervalSinceReferenceDate - elapsed
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    func stopTime() {
        elapsed = Date.timeIntervalSinceReferenceDate - start
        timer?.invalidate()
    }
    
    func updateCounter() {
        // Calculate total time since timer started in seconds
        time = Date.timeIntervalSinceReferenceDate - start
        
        // Calculate minutes
        let minutes = UInt64(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        
        // Calculate seconds
        let seconds = UInt64(time)
        time -= TimeInterval(seconds)
        
        // Calculate milliseconds
        let milliseconds = UInt64(time * 100)
        
        // Format time vars with leading zero
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strMilliseconds = String(format: "%02d", milliseconds)
        
        // Add time vars to relevant labels
        timeMinute.text = strMinutes
        timeSecond.text = strSeconds
        timeMillisecond.text = strMilliseconds
        
    }
}

//MARK: - Global
let pulse = SKAction.init(named: "Pulse")!

//Generates a random number from 0 to num, highest number is num-1
func randomInt(num: Int) -> Int {
    return Int(arc4random_uniform(UInt32(num)))
}
