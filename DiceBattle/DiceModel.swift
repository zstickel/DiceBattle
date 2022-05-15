//
//  DiceModel.swift
//  DiceBattle
//
//  Created by Stickel, Zane on 5/13/22.
//

import Foundation

struct Dice: Identifiable {
    var id = UUID()
    var numSides: Int
    var numShowing = 1
    mutating func roll(){
        numShowing = Int.random(in: 1...numSides)
    }
}

class DiceGame: ObservableObject {
    @Published var diceOne = Dice(numSides: 20)
    @Published var diceTwo = Dice(numSides: 20)
    func battle(){
        diceOne.roll()
        diceTwo.roll()
    }
}

struct AllTimeWins: Codable {
    var diceOneWins = 0
    var diceTwoWins = 0
}
