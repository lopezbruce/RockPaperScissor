//
//  ContentView.swift
//  RockPaperScissor
//
//  Created by Bruce Lopez on 7/11/23.
//

import SwiftUI

enum RockPaperScissor: String, Equatable, CaseIterable {
    case rock = "👊"
    case paper = "✋"
    case scissors = "✌️"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
    
    
    enum Results: Int {
        case win = 1
        case lose = -1
        case draw = 0
    }
    
    // Game rule
    // scissors beats paper
    // paper beats rock
    // rock beats scissors
    func gameRules(selection: RockPaperScissor, userSelection: RockPaperScissor) -> Results {
        switch (selection, userSelection) {
        case let (x, y) where x == y:
            return .draw
        case (.scissors, .paper), (.paper, .rock), (.rock, .scissors):
            return .win
        default:
            return .lose
        }
    }
}

struct ContentView: View {
    
    @State var playNumber: Int = 1
    var numberOfPlays = 10
    @State var score: Int = 0
    @State var gameover: Bool = false
    @State var showingPopover: Bool = false
    @State var userSel:RockPaperScissor = .rock
    @State var randomSel:RockPaperScissor = .rock
    @State var roundResult:RockPaperScissor.Results = .draw
    @State var popoverSize = CGSize(width: 300, height: 300)
    
    var body: some View {
        VStack {
            NavigationStack {
                VStack(spacing: 15){
                    
                    HStack(spacing: 15) {
                        ForEach(RockPaperScissor.allCases, id: \.self) { value in
                            
                            Button {
                                playGame (UserSelection:value)
                            } label: {
                                Text(value.localizedName)
                                    .font(.system(size: 100))
                            }
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                        }
                        
                    }
                
                .navigationTitle("Rock, Paper, Scissors")
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Text("Round: \(playNumber)/\(numberOfPlays)")
                                }
                                ToolbarItem(placement: .navigationBarTrailing) {
                                                        Text("Score: \(score)")
                                                    }
                            }
                    }
            
        }
        .padding()
        .alert("Gameover!", isPresented: $gameover) {
            Button("Restart game?", action: restartGame)
        } message: {
            Text("Your final score is \(score)/10")
        }
        .popover(isPresented: $showingPopover) {
            VStack {
                if roundResult == .win {
                    Text("Won").font(.largeTitle.weight(.semibold)).foregroundColor(.green)
                } else if roundResult == .lose {
                    Text("Lost").font(.largeTitle.weight(.semibold)).foregroundColor(.red)
                } else {
                    Text("Draw").font(.largeTitle.weight(.semibold)).foregroundColor(.gray)
                }
                HStack{
                    if roundResult == .lose {
                        Text(userSel.localizedName).font(.system(size: 150))
                    } else {
                        Text(userSel.localizedName).font(.system(size: 75))
                    }
                    
                    Text("vs.").font(.system(size: 25))
                    if roundResult == .win {
                        Text(randomSel.localizedName).font(.system(size: 150))
                    }else {
                        Text(randomSel.localizedName).font(.system(size: 75))
                    }
                }
                }
                Button{
                    showingPopover.toggle()
                }label: {
                    Text("Next Round")
                }.buttonStyle(.borderedProminent)
            }
                        .font(.headline)
                        .padding()
                }
    }
    
    func playGame (UserSelection:RockPaperScissor) {
        let randomSelection = RockPaperScissor.allCases.randomElement() ?? RockPaperScissor.paper
        print("randomSelection: \(randomSelection)")
        print("UserSelection: \(UserSelection)")
        let gameResult = RockPaperScissor.rock.gameRules(selection: randomSelection, userSelection: UserSelection)
        print(gameResult)
        userSel = UserSelection
        randomSel = randomSelection
        roundResult = gameResult
        score += gameResult.rawValue
        playNumber += 1
        
        if playNumber == 10 {
            gameover.toggle()
        }
        
        showingPopover.toggle()
        
    }
    
    func restartGame() {
            gameover = false
            playNumber = 0
            score = 0
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
