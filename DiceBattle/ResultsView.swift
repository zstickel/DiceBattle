//
//  ResultsView.swift
//  DiceBattle
//
//  Created by Stickel, Zane on 5/14/22.
//

import SwiftUI

struct ResultsView: View {
    var diceOneWins: Int
    var diceTwoWins: Int
    var allTimeWins: AllTimeWins
    var body: some View {
        VStack{
            Text("Dice one wins this game: \(diceOneWins)")
            Text("Dice two wins this game: \(diceTwoWins)")
            Text("Dice one all time wins: \(allTimeWins.diceOneWins)")
            Text("Dice two all time wins: \(allTimeWins.diceTwoWins)")
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(diceOneWins: 0, diceTwoWins: 0, allTimeWins: AllTimeWins())
    }
}
