//
//  AddView.swift
//  DailyDestiny
//
//  Created by admin on 27.02.2024.
//


import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var description = ""
    @State private var selectedEmoji: String = "🗓️"
    @ObservedObject var destinys: Destinys
    @State private var showingSheetEmoji = false
    @State private var error = false
    var body: some View {
        NavigationStack{
            Form{
                TextField("Name", text: $name)
                    .font(.title)
                    .padding(.leading)
                    
                    
                TextField("Short description", text: $description)
                    .font(.headline)
                    .padding(.leading)
                HStack{
                    Spacer()
                    HStack {
                        Text("Choose a sticker")
                            .font(.title2)
                            .bold()
                          
                        Spacer()
                        Button(action: {
                            withAnimation {
                                showingSheetEmoji = true
                            }
                        }) {
                            Text(selectedEmoji)
                                .font(.system(size: 60))
                                .padding()
                                .background(Color.gray)
                                .clipShape(.circle)
                                .overlay(
                                    Circle()
                                        .strokeBorder(.red, lineWidth: 3)
                                       
                                )
                              
                            
                        }
                    }
                }
                .sheet(isPresented: $showingSheetEmoji) {
                    Emoji(emoji: $selectedEmoji)
                }
            }
            .navigationTitle("Add new habbit")
            .toolbar {
                            Button("Save") {
                                errorr()
                                if error == true{
                                    errorr()
                                }else if error == false{
                                    let item = DestinyItem(name: name, description: description, emoji: selectedEmoji)
                                    destinys.items.insert(item, at: 0)
                                    dismiss()
                                }
                            }
                        }
                        .alert("Error", isPresented: $error){
                            Button("OK"){}
                        } message: {
                            Text(" Name and description must be filled in!")
                               
                        }
                    }
                   
                }
                func errorr(){
                    guard !name.isEmpty && !selectedEmoji.isEmpty && !description.isEmpty else { return error = true}
                
            
        
    }
}

#Preview {
    AddView(destinys: Destinys())
}
