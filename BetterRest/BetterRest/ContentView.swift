//
//  ContentView.swift
//  BetterRest
//
//  Created by admin on 06.02.2024.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 0
    
    @State private var alertTitle = ""
    @State private var alertMassage = ""
    @State private var showingAlert = false
    
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section(header: Text("When do you want wake up?⏰")
                    .font(.headline)
                    .fontWeight(.bold)){
                        
                        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .font(.title2)
                            .datePickerStyle(.wheel)
                        
                    }
                
                Section(header: Text("Desired amount of sleep").font(.headline).fontWeight(.bold)){
                    
                    Stepper("\(sleepAmount.formatted()) Hours⏰", value: $sleepAmount, in: 4...12, step: 0.25)
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(height: 40)
                }
               
                
                Section(header: Text("Daily coffee intake").font(.headline).fontWeight(.bold)){
                    
                    Picker("^[\(coffeeAmount) Cup](inflect: true)☕️", selection: $coffeeAmount) {
                        ForEach(0...20, id: \.self) { cup in
                            Text("^[\(cup) Cup](inflect: true)☕️")
                            
                        }
                    }
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(height: 40)
                    
                    .onChange(of: coffeeAmount) { newValue in
                        calculateBedtime()
                    }

                    .onChange(of: sleepAmount) { newValue in
                        calculateBedtime()
                    }

                    .onChange(of: wakeUp) { newValue in
                        calculateBedtime()
                    }
                    
                }
                
                
                
                Section(header: Text(alertTitle).font(.title3).bold().frame(maxWidth: .infinity, alignment: .center)){
                    
                    Text(alertMassage)
                    
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 40)
                    
                        .onAppear {
                            calculateBedtime()
                        }
                       
                }
        
               
            }
            .navigationTitle("BetterRest")
            .toolbar {
            
           
        }
           
            
        }
        
        
        
    }
    
    func calculateBedtime() {
        
        do{
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your ideal bedtime is"
            alertMassage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMassage = "Sorry, there was a problem calculating your bedtime."
        }
        showingAlert = true
    }
}

#Preview {
    ContentView()
}
