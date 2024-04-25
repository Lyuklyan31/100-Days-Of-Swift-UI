//
//  SwiftUIView.swift
//  WeSplit
//
//  Created by admin on 02.02.2024.
//

import SwiftUI

struct SwiftUIView: View {
    
    @State private var checkAmount = 0.0
    @State private var unitOfMeasurement = ""
    @State private var resultConvertation = 0.0
    @State private var inUnit = ""
    
    let unitOfMeasurements = ["Meters", "Kilometers", "Feet", "Yards", "Miles"]
    let inUnins = ["Centimeter"]
    
    var convertedValue: Double {
        switch unitOfMeasurement {
        case "Meters":
            return checkAmount * 100
        case "Kilometers":
            return checkAmount / 1000
        case "Feet":
            return checkAmount * 328.084
        case "Yards":
            return checkAmount * 109.361
        case "Miles":
            return checkAmount / 1609.34
        default:
            return 0.0
        }
    }
    var body: some View {
        NavigationStack{
            Section {
                Form {
                    TextField("Number", value: $checkAmount, formatter: NumberFormatter() )
                    
                    Picker("Unit", selection: $unitOfMeasurement) {
                        ForEach(unitOfMeasurements, id: \.self) {
                            Text($0)
                        }
                    }
                }
            }

            Section {
                Form{
                
                    Text("Centimeter")
                       
                    
                    Text(convertedValue.formatted())
                }
            }
            .navigationTitle("Unit Converter")
        }
    }
}

    #Preview {
        SwiftUIView()
    }

