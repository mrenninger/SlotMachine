//
//  SlotBrain.swift
//  SlotMachine
//
//  Created by Michael Renninger on 11/26/14.
//  Copyright (c) 2014 Michael Renninger. All rights reserved.
//

import Foundation

class SlotBrain {
    
    class func unpackSlotsIntoSlotRows (slots:[[Slot]]) -> [[Slot]] {
        
        var row1: [Slot] = []
        var row2: [Slot] = []
        var row3: [Slot] = []
        
        for slotArray in slots {
            for var i = 0; i < slotArray.count; i++ {
                let slot = slotArray[i]
                if i == 0 {
                    row1.append(slot)
                } else if i == 1 {
                    row2.append(slot)
                } else if i == 2 {
                    row3.append(slot)
                } else {
                    println("Error")
                }
            }
        }
        
        return [row1,row2,row3]
    }
    
    class func calculateWinnings (slots:[[Slot]]) -> Int {
        
        var rows = unpackSlotsIntoSlotRows(slots)
        var winnings = 0;
        
        var flushCount = 0
        var threeOfAKindCount = 0
        var straightCount = 0
        
        for row in rows {

            if checkFlush(row) {
                println("Flush")
                winnings += 1
                flushCount += 1
            }
            
            if checkStraight(row) {
                println("Straight")
                winnings += 1
                straightCount += 1
            }
            
            if check3OfAKind(row) {
                println("Three of a Kind")
                winnings += 3
                threeOfAKindCount += 1
            }

        }
        
        if winnings == 0 {
            println("GOOSE EGG!")
        }
        
        if flushCount == 3 {
            println("Royal Flush")
            winnings += 15
        }
        
        if straightCount == 3 {
            println("Epic Straight")
            winnings += 1000
        }
        
        if threeOfAKindCount == 3 {
            println("Threes All Around")
            winnings += 50
        }
        
        return winnings
        
    }
    
    class func checkFlush(row:[Slot]) -> Bool {
        
        let slot1 = row[0]
        let slot2 = row[1]
        let slot3 = row[2]
        
        var result:Bool = false
        
        if (slot1.isRed && slot2.isRed && slot3.isRed) || (!slot1.isRed && !slot2.isRed && !slot3.isRed) {
            result = true
        }
        
        return result
    }
    
    class func checkStraight(row:[Slot]) -> Bool {
    
        let slot1 = row[0]
        let slot2 = row[1]
        let slot3 = row[2]
        
        var result:Bool = false
        
        if ((slot1.value == slot2.value - 1) && (slot1.value == slot3.value - 2))
            || ((slot1.value == slot2.value + 1) && (slot1.value == slot3.value + 2)) {
            result = true
        }
        
        return result
    }
    
    class func check3OfAKind(row:[Slot]) -> Bool {
        
        let slot1 = row[0]
        let slot2 = row[1]
        let slot3 = row[2]
        
        var result:Bool = false
        
        if slot1.value == slot2.value && slot1.value == slot3.value {
            result = true
        }
        
        return result
    }
}
