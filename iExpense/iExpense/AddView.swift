//
//  AddView.swift
//  iExpense
//
//  Created by admin on 20.02.2024.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @State private var error = false
    
    var expenses: Expenses
    
    let types = ["Business", "Personal"]
    var body: some View {
        NavigationStack{
            Form{
                TextField("Name", text: $name)
               
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", value: $amount, format:.currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
           
            .toolbar {
                Button("Save") {
                    errorr()
                    if error == true{
                        errorr()
                    }else if error == false{
                        let item = ExpenseItem(name: name, type: type, amount: amount)
                        expenses.items.insert(item, at: 0)
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $error){
                Button("OK"){}
            } message: {
                Text(" Name and amount must be filled in!")
                   
            }
        }
       
    }
    func errorr(){
        guard !name.isEmpty && amount > 0.0 else { return error = true}
    }
  
}

#Preview {
    AddView(expenses: Expenses())
}
