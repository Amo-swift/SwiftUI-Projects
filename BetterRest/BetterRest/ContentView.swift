//
//  ContentView.swift
//  BetterRest
//
//  Created by Amo on 30.04.2026.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationStack {
                Form {
                Section {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                    Picker("Number of cups", selection: $coffeeAmount) {
                        ForEach(1...20, id: \.self) { amount in
                            Text("^[\(amount) cup](inflect: true)")
                            Text(recommendedBedtime)
                        }
                    }
                }
                    Section("Recommended Bedtime") {
                        Text(recommendedBedtime)
                            .font(.largeTitle)
                    }

                    Section {
                        HStack {
                            Spacer()
                            Image("BetterRest")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 32))
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.clear)
            }
            .navigationTitle("BetterRest")
        }
    }
    
    var recommendedBedtime: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)

            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60

            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

            let sleepTime = wakeUp - prediction.actualSleep

            return sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            return "Sorry, there was a problem."
        }
    }
}

#Preview {
    ContentView()
}
