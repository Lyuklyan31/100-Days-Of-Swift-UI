//
//  ContentView.swift
//  WordScramble
//
//  Created by admin on 07.02.2024.

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        
        NavigationStack{
            
            List{
                Section{
                    TextField("Enter your word", text: $newWord)
                }
                
                Section{
                    ForEach(usedWords, id: \.self) { evenElement in
                        HStack{
                            Image(systemName: "\(evenElement.count).circle")
                            Text(evenElement)
                        }
                    }
                }
                
                
            }
            .navigationTitle(rootWord)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .toolbar{
                Text("^[Word \(usedWords.count)](inflect: true)")
                    .font(.headline)
                
                Button {
                    startGame()
                    usedWords = [String]()
                } label: {
                    HStack {
                        Spacer()
                        Text("Resset")
                        Spacer()
                    }
                    
                    
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundColor(.primary)
                    .background(Capsule().stroke(.primary, lineWidth: 2))
                }
                
            }
            
            
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
            .alert(errorTitle, isPresented: $showingError) { } message: {
                Text(errorMessage)
            }
            .textInputAutocapitalization(.never)
            
            
            Button {
                addNewWord()
            } label: {
                HStack {
                    Spacer()
                    Text("Add")
                    Spacer()
                }
                .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                
                .font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundColor(.primary)
                .background(Capsule().stroke(.primary, lineWidth: 2))
            }
        }
    }
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard answer.count >= 3 else { wordError(title: "Word is short", message: "Word must be longer")
            return
        }
        
        guard answer != rootWord else { wordError(title: "Word is same!", message: "Word is same!")
            return
        }
            
            
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }

        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        withAnimation{
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
    
                rootWord = allWords.randomElement() ?? "silkworm"
                
                return
            }
        }
        fatalError("Could not load start.txt from bundle.")
    }
    
    
    func isOriginal(word: String) -> Bool {// якшо слово оригінальне поверни так
        !usedWords.contains(word) //слово word міститься у usedWords 1 раз false і потім стає true
    }
    
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord

        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }

        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
}


#Preview {
    ContentView()
}
