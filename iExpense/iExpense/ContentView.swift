//
//  ContentView.swift
//  iExpense
//
//  Created by admin on 18.02.2024.
//
import SwiftUI
import Foundation


struct ExpenseItem: Identifiable, Codable{
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
    
}

@Observable
class Expenses{
    
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
        init() {
            if let savedItems = UserDefaults.standard.data(forKey: "Items") {
                if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                    items = decodedItems
                    return
                }
            }
            items = []
        }
    
}


struct ContentView: View {
    
    @State private var title = "iExpense"
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    @State private var selectedType = "All"
       
    let types = ["All", "Personal", "Business"]
       
    var filteredExpenses: [ExpenseItem] {
        if selectedType == "All" {
            return expenses.items
        } else {
            return expenses.items.filter{ $0.type == selectedType }
        }
    }
    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("Type")){
                    Picker("Type", selection: $selectedType) {
                        ForEach(types, id: \.self) { type in
                            Text(type)
                            
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(maxWidth: .infinity)
                    .listRowInsets(EdgeInsets())
                }
                ForEach(filteredExpenses) {item in
                    HStack{
                        VStack(alignment: .leading){
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text(item.amount, format:.currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .foregroundColor(textColor(for: item.amount))
                    }
                }
                
                .onDelete(perform: removeItems)
                
            }
            .navigationTitle($title)
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                NavigationLink{
                    AddView(expenses: expenses)
                } label: {
                    Image(systemName: "plus")
                    
                }
               
            
            }
           
        }
        
    }
    
    func textColor(for amount: Double) -> Color {
        switch amount {
        case ..<10:
            return .green
        case 10..<100:
            return .yellow
        default:
            return .red
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
