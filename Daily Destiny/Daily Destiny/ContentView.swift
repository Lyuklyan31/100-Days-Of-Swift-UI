//  ContentView.swift
//  DailyDestiny
//  Created by admin on 26.02.2024.

import SwiftUI
import Observation

struct DestinyItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var description: String
    var emoji: String
}
//почитати
class Destinys: ObservableObject {
   @Published var items = [DestinyItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([DestinyItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    @StateObject private var destinys = Destinys()
    @State private var title = "Daily Destiny"
    @State private var showingSheet = false
    @State private var amount = 0 // New state variable
    
    let columns: [GridItem] = [
        GridItem(.flexible(minimum: 100, maximum: .infinity))
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    VStack {
                        Text("Good Day")
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(Color.primary)
                        Text("What are your plans for today?")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.primary)
                    }
                    .padding()
                    Spacer()
                    Image(.tree)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 170)
                }
                .background(Color.primary.opacity(0.6))
                .clipShape(.rect(cornerRadius: 20))
                .padding()
                
                ZStack {
                  
                        List{
                            
                            ForEach(destinys.items) { item in
                                NavigationLink(destination: DetailView(item: item, amount: $amount)) {
                                    HStack {
                                        Text(item.emoji)
                                            .font(.system(size: 40))
                                            .padding(.trailing)
                                        
                                        VStack{
                                            Text(item.name)
                                                .font(.headline)
                                                .foregroundStyle(.white)
                                            Rectangle()
                                                .frame(height: 0.5)
                                                .foregroundStyle(.white)
                                            
                                            Text(item.description)
                                                .font(.headline)
                                                .foregroundStyle(.white)
                                        }
                                       

                                    }
                                   
                                    
                                    .clipShape(.rect(cornerRadius: 20))
                                }
                                .listRowBackground(Color.primary.opacity(0.6))
                                .listRowSeparatorTint(.white)
                                
                            }
                            .onDelete(perform: removeRows)
                            
                        }
                       
                        .clipShape(.rect(cornerRadius: 20))
                        
                       
                    
                    
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            Button(action: {
                                withAnimation(.easeInOut(duration: 1.0)){
                                    showingSheet = true
                                }
                            }) {
                                Text("+")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.white)
                                    .frame(width: 70, height: 70)
                                    .background(Color.green)
                                    .clipShape(Circle())
                                    .shadow(radius: 1)
                                    .padding()
                            }
                            .sheet(isPresented: $showingSheet) {
                                AddView(destinys: destinys)
                            }
                        }
                        
                    }
                   
                }
                .ignoresSafeArea()
                .navigationTitle($title)
                .navigationBarTitleDisplayMode(.inline)
            }
            .background(Color.primary.opacity(0.2))
        }
    }
    func removeRows(at offsets: IndexSet) {
        destinys.items.remove(atOffsets: offsets)
    }
}


#Preview {
    ContentView()
}
