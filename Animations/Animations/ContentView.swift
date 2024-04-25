//
//  ContentView.swift
//  Animations
//
//  Created by admin on 10.02.2024.
//
import SwiftUI

struct ContentView: View {
    
    let students = ["10 Easy", "15 Medium", "20 Hard", "Infinitely"]
  
    @State private var selectedStudent = "10 Easy"
    
    @State private var examplePositions: [CGPoint] = []

   
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    
    
    let multiplicationExamples = [
        "7 x 8 = ???",
        "6 x 7 = 42",
        "4 x 9 = ???",
        "3 x 5 = ???",
        "2 x 6 = ???",
        "8 x 3 = 24",
        "9 x 2 = 18",
        "5 x 4 = ???",
        "1 x 10 = ???",
        "10 x 1 = 10",
        "7 x 8 = 56",
        "8 x 9 = ???",
        "4 x 4 = 16",
        "2 x 9 = ???",
        "7 x 4 = 28",
        "9 x 9 = 81",
        "5 x 5 = 25"
        
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                
                VStack {
                    //приклади множення
                    ForEach(Array(zip(multiplicationExamples, examplePositions)), id: \.0) { example, position in
                        Text(example)
                            .foregroundColor(.white)
                            .blur(radius: 2)
                            .font(.title)
                            .padding()
                            .position(position)
                            .animation(Animation.linear(duration: 1), value: examplePositions)
                    }
                    
                    Spacer()
                    NavigationLink(destination: SwiftUIView(selectedStudent: $selectedStudent)) {
                        Text("Start")
                            .frame(width: 300, height: 100)
                            .background(Image("snake")
                                .resizable()
                                .frame(width: 100, height: 100))
                            .shadow(radius: 10)
                            .foregroundColor(.white)
                            .padding()
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Image("fon")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                        .blur(radius: 6.0)
                    
                )
                .onAppear {
                    generateExamplePositions()
                }
                .onReceive(timer) { _ in
                    moveExamples()
                }
                
                VStack{
                    //Picker
                    Spacer()
                    Text("Select the number of questions")
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(Color.green.opacity(0.8))
                        .clipShape(.capsule)
                        .font(.title2)
                    
                    Picker("Amount", selection: $selectedStudent) {
                        ForEach(students, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    .frame(height: 50)
                    .pickerStyle(SegmentedPickerStyle())
                    
                    .background(Color.green.opacity(0.9))
                    .padding(1)
                    .clipShape(.capsule)
                    
                    Spacer()
                }
                
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Learning Multiply")
                            .font(.largeTitle)
                            .frame(width: 300, height: 50)
                            .background(Color.green.opacity(0.7))
                            .clipShape(Capsule())
                            .foregroundColor(.white)
                    }
                }
            }
            .background(Color.black)
            .ignoresSafeArea()
        }
    }
    
    
    
    
    func generateExamplePositions() {
        let screenWidth = UIScreen.main.bounds.width
        
        examplePositions = multiplicationExamples.map { _ in
            CGPoint(x: CGFloat.random(in: 0..<screenWidth), y: -50)
        }
    }
    
    func moveExamples() {
        examplePositions = examplePositions.map { position in
            let newY = position.y + 2
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            
            if newY > screenHeight {
                return CGPoint(x: CGFloat.random(in: 0..<screenWidth), y: -50)
            } else {
                return CGPoint(x: position.x, y: newY)
            }
        }
    }
}

#Preview {
    ContentView()
}
