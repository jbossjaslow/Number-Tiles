//
//  tile.swift
//  numberTiles
//
//  Created by Josh Jaslow on 6/17/17.
//  Copyright © 2017 Jaslow Enterprises. All rights reserved.
//

import SpriteKit
import CoreData

class tile {
    var posX: Int
    var posY: Int
    var name: String
    
    init(posX: Int, posY: Int, name: String) {
        self.posX = posX
        self.posY = posY
        self.name = name
    }
    
    func moveToPos(posX: Int, posY: Int) {
        self.posX = posX
        self.posY = posY
    }
    
    func printPos() {
        print("\(name) - X: \(posX), Y: \(posY)")
    }
    
}
