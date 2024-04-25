//
//  DetailView.swift
//  DailyDestiny
//
//  Created by admin on 28.02.2024.
//

import SwiftUI


class Count: ObservableObject {
    @Published var items = [Date]()// {
//        didSet {
//            if let encoded = try? JSONEncoder().encode(items) {
//                UserDefaults.standard.set(encoded, forKey: "Items")
//            }
//        }
//    }
//    
//    init() {
//        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
//            if let decodedItems = try? JSONDecoder().decode([Date].self, from: savedItems) {
//                items = decodedItems
//                return
//            }
//        }
//        items = []
//    }
    
    func removeRows(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
    
}
   
struct DetailView: View {
    let item: DestinyItem
    @Binding var amount: Int // Add binding
    
    @StateObject private var count = Count()
    @EnvironmentObject var destinys: Destinys
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    VStack {
                        Text(item.emoji)
                            .font(.system(size: 120))
                            .frame(width: 350,height: 250)
                            .background(Color.gray.opacity(20))
                            .clipShape(Capsule())
                            .overlay{
                                Capsule()
                                    .strokeBorder(.green, lineWidth: 10)
                            }
                            .overlay(alignment: .top){
                                Text(item.name)
                                    .font(.largeTitle)
                                    .bold()
                                    .padding()
                            }
                            .overlay(alignment: .bottom){
                                Button(action: {
                                    let newItem = Date()
                                    count.items.insert(newItem, at: 0 )
                                    amount += 1
                                }){
                                    Text("Track Habit")
                                        .foregroundStyle(.white)
                                        .frame(width: 120,height: 40)
                                        .background(Color.blue)
                                        .clipShape(Capsule())
                                        .shadow(radius: 5)
                                        .padding()
                                }
                            }
                    }
                    VStack {
                        HStack {
                            Text("Description")
                                .font(.title)
                                .padding(.leading)
                            Spacer()
                        }
                        HStack {
                            Text(item.description)
                                .padding(.leading)
                            Spacer()
                        }
                        Text("Number of repetitions \(amount)")
                            .frame(width: 350, height: 40)
                            .background(Color.blue)
                            .clipShape(.rect(cornerRadius: 20))
                        List {
                            ForEach(count.items.indices, id: \.self) { index in
                                HStack {
                                    Text("\(formattedDate(from: count.items[index]))")
                                }
                            }
                            .onDelete(perform: count.removeRows)
                        }
                        .id(UUID())
                    }
                }
            }
     
            .onReceive(count.$items) { _ in
                amount = count.items.count // Pass the count to amount
            }
        }
    }
    
    func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = """
        dd-MM-yyyy
        HH:mm:ss
        """
        return formatter.string(from: date)
    }
}

#Preview {
    DetailView(item: DestinyItem(name: "Running", description: "description", emoji: "🏃"), amount: .constant(0))
}
