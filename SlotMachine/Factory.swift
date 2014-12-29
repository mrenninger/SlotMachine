//
//  Factory.swift
//  SlotMachine
//
//  Created by Michael Renninger on 11/25/14.
//  Copyright (c) 2014 Michael Renninger. All rights reserved.
//

import Foundation
import UIKit

class Factory {
    class func createSlots() -> [[Slot]] {
        
        let NUM_SLOTS = 3
        let NUM_CONTAINERS = 3
        var slots: [[Slot]] = []
        
        for var i = 0; i < NUM_CONTAINERS; i++ {
            var slotAr: [Slot] = []
            for var j = 0; j < NUM_SLOTS; j++ {
                //var slot = Slot(value: 0, img: UIImage(named:""), isRed: true)
                var slot = Factory.createSlot(slotAr)
                slotAr.append(slot)
            }
            slots.append(slotAr)
        }
        
        return slots
    }
    
    class func createSlot (currentCards: [Slot]) -> Slot {
        var curCardValues:[Int] = []
        for slot in currentCards {
            curCardValues.append(slot.value)
        }
        
        var randNum = Int(arc4random_uniform(UInt32(13)))
        while contains(curCardValues, randNum + 1) {
            randNum = Int(arc4random_uniform(UInt32(13)))
        }
        
        let cardsAr:[String] = ["Ace","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten","Jack","Queen","King"]
        let isRedAr:[Bool] = [true,true,true,true,false,false,true,false,false,true,false,false,true,true]
        
        return Slot(value: randNum + 1, img: UIImage(named:cardsAr[randNum]), isRed: isRedAr[randNum])
    }
}