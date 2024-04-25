//
//  SwiftUIView.swift
//  Animations
//
//  Created by admin on 15.02.2024.
//

import SwiftUI

struct SwiftUIView: View {
    
    // Параметр для вибору студентом кількості питань
    @Binding var selectedStudent: String
    
    init(selectedStudent: Binding<String>) {
        self._selectedStudent = selectedStudent
    }
    
    // MARK: - Properties
    
    @State private var animationAmount = 0.0
    @State private var selectedItem: Buttons?
    @State private var rotationAmounts: [Buttons: Double] = [:]
    @State private var currentNumber = 3
    @State private var timer: Timer?
    @State private var isTimerRunning = false
    @State private var multiplicationResults: [Int] = []
    @State private var value = ""
    @State private var numbersPressed: [String] = []
    @State private var tx = "Start"
    @State private var score = 0
    @State private var number = Int.random(in: 1...9)
    @State private var numbers = Int.random(in: 1...9)
    @State private var life = 3
    @State private var restart = false
    @State private var goodWork = false
    @State private var record = 0
    
    
    
    // MARK: - Button Arrays
    
    let buttonsArray: [[Buttons]] = [
        [.one, .two, .three],
        [.four, .five, .six],
        [.seven, .eight, .nine],
        [.check, .zero, .clear]
    ]
    
    // MARK: - Body
    
    var body: some View {
        
        VStack{
            Spacer()
            
            HStack {
                
                // Відображення кількості балів
                
                if currentNumber == 0 && !isTimerRunning {
                    Text("Score \(score)")
                        .font(.headline)
                        .shadow(color: .black, radius: 1, x: 1, y: 1)
                        .animation(.easeIn, value: score)
                }
                
                
                Spacer()
                // Відображення кількості життів
                
                if currentNumber == 0 && !isTimerRunning {
                    ForEach(0..<3) { index in
                        Image(systemName: index < life ? "heart.fill" : "heart")
                            .font(.headline)
                            .foregroundStyle(.red)
                            .shadow(color: .black, radius: 1, x: 1, y: 1)
                            .animation(.easeIn, value: score)
                    }
                    
                }
                
            }
            .padding(5)
            
            
            // Відображення питання та варіантів відповіді
            ZStack {
                if isTimerRunning {
                    Image(systemName: "\(currentNumber).circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                    
                    
                    
                }
                
                if currentNumber == 0 && !isTimerRunning {
                    VStack {
                        HStack {
                            
                            Text("\(number) x \(numbers) = ")
                                .font(.custom("Arial", size: 40))
                                .fontWeight(.bold)
                                .animation(.spring, value: number)
                                .animation(.spring, value: numbers)
                            Text(value)
                                .font(.custom("Arial", size: 40))
                                .fontWeight(.bold)
                               
                        }
                        .padding(30)
                        VStack{
                            // Відображення кнопок
                            ForEach(buttonsArray, id: \.self) { row in
                                HStack(spacing: 12) {
                                    ForEach(row, id: \.self) { item in
                                        Button(action: {
                                           
                                            self.didTap(item: item)
                                            withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
                                                rotationAmounts[item] = (rotationAmounts[item] ?? 0) + 360
                                            }
                                            
                                           
                                        }) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.gray)
                                                    .frame(width: 50, height: 50)
                                                HStack {
                                                    if case .clear = item {
                                                        ZStack{
                                                            Image("crocodile")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                            Image(systemName: "delete.left")
                                                                .font(.headline)
                                                                .foregroundStyle(.white)
                                                                .fontWeight(.bold)
                                                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                                                        }
                                                        
                                                    } else if case .check = item {
                                                        ZStack{
                                                            Image("duck")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                            Image(systemName: "checkmark")
                                                                .font(.headline)
                                                                .foregroundStyle(.white)
                                                                .fontWeight(.bold)
                                                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                                                        }
                                                        
                                                    } else if case .zero = item {
                                                        ZStack{
                                                            Image("chick")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                
                                                            Text("0")
                                                                .font(.headline)
                                                                .foregroundStyle(.white)
                                                                .fontWeight(.bold)
                                                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                                                        }
                                                    }else if case .one = item {
                                                        ZStack{
                                                            Image("sloth")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                            Text("1")
                                                                .font(.headline)
                                                                .foregroundStyle(.white)
                                                                .fontWeight(.bold)
                                                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                                                        }
                                                    }else if case .two = item {
                                                        ZStack{
                                                            Image("narwhal")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                            Text("2")
                                                                .font(.headline)
                                                                .foregroundStyle(.white)
                                                                .fontWeight(.bold)
                                                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                                                        }
                                                    }else if case .three = item {
                                                        ZStack{
                                                            Image("chicken")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                            Text("3")
                                                                .font(.headline)
                                                                .foregroundStyle(.white)
                                                                .fontWeight(.bold)
                                                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                                                        }
                                                    }else if case .four = item {
                                                        ZStack{
                                                            Image("panda")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                            Text("4")
                                                                .font(.headline)
                                                                .foregroundStyle(.white)
                                                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                                                        }
                                                    }else if case .five = item {
                                                        ZStack{
                                                            Image("penguin")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                            Text("5")
                                                                .font(.headline)
                                                                .foregroundStyle(.white)
                                                                .fontWeight(.bold)
                                                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                                                        }
                                                    }else if case .six = item {
                                                        ZStack{
                                                            Image("bear")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                            Text("6")
                                                                .font(.headline)
                                                                .foregroundStyle(.white)
                                                                .fontWeight(.bold)
                                                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                                                        }
                                                    }else if case .seven = item {
                                                        ZStack{
                                                            Image("cow")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                            Text("7")
                                                                .font(.headline)
                                                                .foregroundStyle(.white)
                                                                .fontWeight(.bold)
                                                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                                                        }
                                                    }else if case .eight = item {
                                                        ZStack{
                                                            Image("frog")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                            Text("8")
                                                                .font(.headline)
                                                                .foregroundStyle(.white)
                                                                .fontWeight(.bold)
                                                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                                                        }
                                                    }else if case .nine = item {
                                                        ZStack{
                                                            Image("rabbit")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                            Text("9")
                                                                .font(.headline)
                                                                .foregroundStyle(.white)
                                                                .fontWeight(.bold)
                                                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                                                        }
                                                    }
                                                }
                                            }
                                            .rotationEffect(.degrees(selectedItem == item ? (rotationAmounts[item] ?? 0) : 0))
                                            
                                        }
                                        .shadow(color: .black, radius: 3, x: 0, y: 2)
                                        .frame(width: 70, height: 70)
                                        .background(Color.gray)
                                        .clipShape(Circle())
                                       
                                    }
                                }
                            }
                        }
                        .padding()
                        
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            .background(.regularMaterial)
            .clipShape(.rect(cornerRadius: 20))
            //MARK: GIRAF
            Spacer()
            
            VStack {
                Button(action: {
                    withAnimation(.spring(duration: 1, bounce: 0.5)) {
                        animationAmount += 360
                    }
                    withAnimation(.spring(duration: 1)){
                        isTimerRunning.toggle()
                    }
                    self.startTimer()
                }) {
                    ZStack {
                        Image("giraffe")
                            .resizable()
                            .frame(width: 130, height: 130)
                            .shadow(color: .black, radius: 5, x: 1, y: 1)
                            .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
                        
                        Text(tx)
                            .foregroundColor(.white)
                            .font(.title2)
                            .font(.headline)
                            .foregroundStyle(.white)
                            .shadow(color: .black, radius: 3, x: 1, y: 1)
                            .rotationEffect(.degrees(animationAmount), anchor: .center)
                    }
                }
                .alert("GAME OVER", isPresented: $restart) {
                    Button("Restart") {back() }
                } message: {
                    Text("Don't be sad, try again")
                }
                
                .alert("GOOD GAME", isPresented: $goodWork) {
                    Button("Start again") {back()}
                } message: {
                    Text("Don't give up, try a harder level")
                }
                
                
                
            }
            
        }
        .background(
            Image("fon")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 8.0)
            
        )
    }
    
    
    // MARK: - Functions
    
    
    func back(){
        value = ""
        score = 0
        life = 3
        number = Int.random(in: 1...9)
        numbers = Int.random(in: 1...9)
    }
    
    
    
    func selected() {
        if (selectedStudent == "10 Easy" && score == 10) ||
            (selectedStudent == "15 Medium" && score == 15) ||
            (selectedStudent == "20 Hard" && score == 20) ||
            (selectedStudent == "Infinitely" && score == 10000){
            goodWork = true
            back()
        }
    }
    
    //MARK: GAME OVER
    func gameOver() {
        if life == 0 {
            restart = true
            value = ""
        }
    }
    //MARK: CHECKOUT
    func checkOut() {
        let result = number * numbers
        if Int(value) == result {
            number = Int.random(in: 1...9)
            numbers = Int.random(in: 1...9)
            value = ""
            score += 1
            selected()
        } else {
            life -= 1
            gameOver()
            value = ""
            number = Int.random(in: 1...9)
            numbers = Int.random(in: 1...9)
        }
    }
    
    // Функція множення
    func multiply() {
        var results = [Int]()
        for i in 1...9 {
            for j in 1...9 {
                results.append(i * j)
            }
        }
        multiplicationResults = results
    }
    
    // Обробка натискання на кнопки
    func didTap(item: Buttons) {
        
        self.selectedItem = item
        self.rotationAmounts[item] = (self.rotationAmounts[item] ?? 0) + 360
        
        switch item {
        case .check:
            checkOut()
        case .clear:
            if !value.isEmpty {
                value.removeLast()
            }
        default:
            if value.count < 2 {
                if value == "0" {
                    value = item.rawValue
                } else {
                    value += item.rawValue
                }
            }
            
            if numbersPressed.count < 2 {
                numbersPressed.append(item.rawValue)
            }
        }
    }
    
    
    
    // MARK: - Timer
    
    // Функція для запуску таймера
    func startTimer() {
        currentNumber = 3
        isTimerRunning = true
        life = 3
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.currentNumber > 0 {
                self.currentNumber -= 1
            } else {
                withAnimation{
                    timer.invalidate()
                    self.isTimerRunning = false
                }
                
                withAnimation{
                    if currentNumber == 0 && !isTimerRunning {
                        tx = "Restart"
                    }
                }
            }
        }
    }
}

#Preview {
    SwiftUIView(selectedStudent: .constant("10 Easy"))
}
