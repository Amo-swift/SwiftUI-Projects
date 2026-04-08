//
//  ContentView.swift
//  AnyUnit
//
//  Created by Amo on 03.04.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var inputValue = 0.0
    @State private var inputUnit = "m"
    @State private var outputUnit = "km"
    @State private var selectedCategory = "Length"
    @FocusState private var isInputFocused: Bool
    
    let categories = ["Length", "Temp", "Volume", "Weight"]
    let temperatureUnits = ["°C", "°F", "K"]
    let lengthUnits = ["m", "km", "mi", "ft", "yd"]
    let volumeUnits = ["mL", "L", "pt", "cups"]
    let weightUnits = ["g", "kg", "oz", "lb"]
    
    var currentUnits: [String] {
        if selectedCategory == "Length" {
            return lengthUnits
        } else if selectedCategory == "Temp" {
            return temperatureUnits
        } else if selectedCategory == "Volume" {
            return volumeUnits
        } else {
            return weightUnits
        }
    }
    
    var finalResult: Double {
        if selectedCategory == "Length" {
            return convertLength()
        } else if selectedCategory == "Temp" {
            return convertTemp()
        } else if selectedCategory == "Volume" {
            return convertVolume()
        } else {
            return convertWeight ()
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    TextField("Value", value: $inputValue, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($isInputFocused)
                }
                
                Section("Convert from") {
                    Picker("Intput Unit", selection: $inputUnit) {
                        ForEach(currentUnits, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Convert to") {
                    Picker("Output Unit", selection: $outputUnit) {
                        ForEach(currentUnits, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                
                Section("Result") {
                    Text(finalResult, format: .number)
                }
            }
            .navigationTitle("AnyUnit")
            .toolbar {
                if isInputFocused {
                    Button("Done") {
                        isInputFocused = false
                    }
                }
            }
            .onChange(of: selectedCategory) {
                inputUnit = currentUnits[0]
                outputUnit = currentUnits[1]
            }
        }
    }
    
    func convertLength() -> Double {
        let lengthMap: [String: UnitLength] = [
            "m": .meters, "km": .kilometers,
            "mi": .miles, "ft": .feet, "yd": .yards
        ]
        
        let sourceUnit = lengthMap[inputUnit] ?? .meters
        let targetUnit = lengthMap[outputUnit] ?? .meters
        
        return Measurement(value: inputValue, unit: sourceUnit)
            .converted(to: targetUnit).value
    }
    
    func convertTemp() -> Double {
        let tempMap: [String: UnitTemperature] = [
          "°C": .celsius, "°F": .fahrenheit, "K": .kelvin
        ]
        
        let sourceUnit = tempMap[inputUnit] ?? .celsius
        let targetUnit = tempMap[outputUnit] ?? .celsius
        
        return Measurement(value: inputValue, unit: sourceUnit)
            .converted(to: targetUnit).value
    }
    
    func convertVolume() -> Double {
        let volumeMap: [String: UnitVolume] = [
            "mL": .milliliters, "L": .liters,
            "pt": .pints, "cups": .cups
        ]
        
        let sourceUnit = volumeMap[inputUnit] ?? .milliliters
        let targetUnit = volumeMap[outputUnit] ?? .milliliters
        
        return Measurement(value: inputValue, unit: sourceUnit)
            .converted(to: targetUnit).value
    }

    func convertWeight() -> Double {
        let weightMap: [String: UnitMass] = [
            "g": .grams, "kg": .kilograms,
            "oz": .ounces, "lb": .pounds
        ]
        
        let sourceUnit = weightMap[inputUnit] ?? .grams
        let targetUnit = weightMap[outputUnit] ?? .grams
        
        return Measurement(value: inputValue, unit: sourceUnit)
            .converted(to: targetUnit).value
    }
}
    
#Preview {
    ContentView()
}
