//
//  ContentView.swift
//  DiceBattle
//
//  Created by Stickel, Zane on 5/13/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var diceGame = DiceGame()
    @State var showWinner = false
    @State var previousOneRolls = [Int]()
    @State var previousTwoRolls = [Int]()
    @State var selectedDieSides = 20
    @State var diceOneWins = 0
    @State var diceTwoWins = 0
    @State var allTimeWins = AllTimeWins()
    @State private var feedback = UINotificationFeedbackGenerator()
    var dieSides = [20,12,10,8,6,4,100]
  
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    VStack{
                        Text("D1 Previous 10 Rolls:")
                        ForEach(previousOneRolls, id: \.self){roll in
                            Text(String(roll))
                        }
                        
                    }
                    VStack{
                        Text("D2 Previous 10 Rolls:")
                        ForEach(previousTwoRolls, id: \.self){roll in
                            Text(String(roll))
                        }
                    }
                }
                .padding()
                HStack{
                    Text("How many sided dice?")
                    Picker("How many sided dice?", selection: $selectedDieSides){
                        ForEach(dieSides, id: \.self){
                            Text(String($0))
                        }
                        
                    }
                }
                Text("Num Sides: \(selectedDieSides)")
                    .padding()
                HStack{
                    ZStack{
                        Rectangle().fill(.white).shadow(radius: 3)
                        Text(String(diceGame.diceOne.numShowing))
                    }
                    .frame(width: 100, height: 100)
                    .padding()
                    ZStack{
                        Rectangle().fill(.white).shadow(radius: 3)
                        Text(String(diceGame.diceTwo.numShowing))
                    }
                    .frame(width: 100, height: 100)
                    .padding()
                }
                Spacer()
                
                
                if showWinner{
                    if diceGame.diceOne.numShowing > diceGame.diceTwo.numShowing {
                        Text("Dice One Wins!")
                            .foregroundColor(.red)
                            .font(.largeTitle)
                    } else if diceGame.diceTwo.numShowing > diceGame.diceOne.numShowing {
                        Text("Dice Two Wins!")
                            .foregroundColor(.yellow)
                            .font(.largeTitle)
                    } else{
                        Text("Tie")
                            .foregroundColor(.blue)
                            .font(.largeTitle)
                    }
                }
                Spacer()
                Button("Battle!"){
                    feedback.prepare()
                    showWinner = false
                    diceGame.diceOne.numSides = selectedDieSides
                    diceGame.diceTwo.numSides = selectedDieSides
                    var runCount = 0
                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                       
                        diceGame.diceOne.numShowing = Int.random(in: 1...selectedDieSides)
                        diceGame.diceTwo.numShowing = Int.random(in: 1...selectedDieSides)
                        runCount += 1
                        if runCount == 10{
                            diceGame.battle()
                            showWinner = true
                            feedback.notificationOccurred(.success)
                            timer.invalidate()
                           
                            if diceGame.diceOne.numShowing > diceGame.diceTwo.numShowing {
                                diceOneWins += 1
                                allTimeWins.diceOneWins += 1
                            } else if diceGame.diceTwo.numShowing > diceGame.diceOne.numShowing{
                                diceTwoWins += 1
                                allTimeWins.diceTwoWins += 1
                            }
                            if previousOneRolls.count < 10 {
                                previousOneRolls.append(diceGame.diceOne.numShowing)
                                previousTwoRolls.append(diceGame.diceTwo.numShowing)
                            }else{
                                previousOneRolls.removeAll()
                                previousTwoRolls.removeAll()
                            }
                            save()
                            
                        }
                       
                    }
                   
                }
                .padding()
                .background(Color(red:0, green: 0, blue: 0.5))
                .foregroundColor(.white)
                .clipShape(Capsule())
                .padding()
                
            }
            .frame(maxWidth: .infinity)
            .background(.green)
            .navigationTitle("Dice Battle!")
            .navigationBarItems(
                trailing:
                    NavigationLink(destination: ResultsView(diceOneWins: diceOneWins, diceTwoWins: diceTwoWins, allTimeWins: allTimeWins)){
                    Text("See Results")
                            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                    .background(Color(red:0, green: 0, blue: 0.5))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                )
        }
        .onAppear(){
            load()
        }
        
    }
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    private func load() {
        let url = getDocumentsDirectory().appendingPathComponent("wins.json")
        
        if let data = try? Data(contentsOf: url){
            if let decoded =
                try? JSONDecoder().decode(AllTimeWins.self, from: data){
                allTimeWins = decoded
                return
            }
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func save(){
        let url = getDocumentsDirectory().appendingPathComponent("wins.json")
        if let encoded = try? JSONEncoder().encode(allTimeWins){
            do{
                try encoded.write(to: url)
            }catch{
                print(error.localizedDescription)
            }
        }
    }
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
