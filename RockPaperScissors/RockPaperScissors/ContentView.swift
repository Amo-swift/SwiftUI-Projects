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
        ZStack {
            GameBackground()
            
            VStack(spacing: 30) {
                VStack {
                    Text("Your goal: \(shouldWin ? "Win" : "Lose")")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                    
                    Text("Сomputer chose: \(choices[computerChoice])")
                        .font(.title)
                        .foregroundStyle(.white)
                }
                
                HStack {
                    ForEach(0..<3) { number in
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                checkAnswer(playerChoice: number)
                            }
                        } label: {
                            VStack {
                                Text(choices[number])
                                    .font(.system(size: 80))
                            }
                            .cardDesign()
                        }
                        .buttonStyle(CardButtonStyle())
                    }
                }
                
                HStack(spacing:52) {
                    Text("Round: \(roundCount)")
                    Text("Score: \(score)")
                    
                }
                .font(.title.bold())
                .foregroundStyle(.white)
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
    }
    
    func checkAnswer(playerChoice: Int) {
        let correctAnswer = shouldWin ? (computerChoice + 1) % 3 : (computerChoice + 2) % 3
        if playerChoice == correctAnswer {
            scoreTitle = "Correct! 🥳"
            score += 1
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
        } else {
            scoreTitle = "Wrong! 😅"
            score -= 1
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
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

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct GameBackground: View {
    var body: some View {
        LinearGradient(colors: [.indigo, .purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
}

struct CardDesign: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 120, height: 160)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(.white.opacity(0.5), lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 10)
    }
}

extension View {
    func cardDesign() -> some View {
        modifier(CardDesign())
    }
}

#Preview {
    ContentView()
}
