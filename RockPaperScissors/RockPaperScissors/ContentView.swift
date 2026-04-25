//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Amo on 25.04.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var choices = ["🪨", "📜", "✂️"]
    @State private var computerChoice = Int.random(in: 0...2)
    
    @State private var roundCount = 1
    @State private var score = 0
    @State private var scoreTitle = ""
    @State private var shouldWin = Bool.random()
    @State private var showingScore = false
    @State private var gameOver = false
    
    
    var body: some View {
        VStack(spacing: 30) {
            VStack {
                Text("Your goal: \(shouldWin ? "Win" : "Lose")")
                    .font(.largeTitle.bold())
                
                Text("Сomputer chose: \(choices[computerChoice])")
                    .font(.title)
                
            }
            
            HStack {
                ForEach(0..<3) { number in
                    Button {
                        checkAnswer(playerChoice: number)
                    } label: {
                        Text(choices[number])
                    }
                    .font(.system(size: 123))
                }
            }
            HStack(spacing:52) {
                Text("Round: \(roundCount)")
                Text("Score: \(score)")
                
            }
            .font(.title.bold())
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score: \(score)")
        }
        .alert("Game over!", isPresented: $gameOver) {
            Button("Restart", action: reset)
        } message: {
            Text("Your final score is \(score)")
        }
        .padding()
    }
    
    func checkAnswer(playerChoice: Int) {
        let correctAnswer = shouldWin ? (computerChoice + 1) % 3 : (computerChoice + 2) % 3
        if playerChoice == correctAnswer {
            scoreTitle = "Correct! 🥳"
            score += 1
        } else {
            scoreTitle = "Wrong! 😅"
            score -= 1
        }
        showingScore = true
    }
    
    func askQuestion() {
        if roundCount == 10 {
            gameOver = true
        } else {
            computerChoice = Int.random(in: 0...2)
            shouldWin = Bool.random()
            roundCount += 1
        }
    }
        
        func reset() {
            score = 0
            roundCount = 1
            computerChoice = Int.random(in: 0...2)
            shouldWin = Bool.random()
            
        }
}

#Preview {
    ContentView()
}
