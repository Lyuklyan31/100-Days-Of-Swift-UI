//
//  AddBookView.swift
//  Bookworm
//
//  Created by admin on 08.03.2024.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    
    @State private var title = ""
    @State private var author = ""
    @State private var review = ""
    @State private var rating = 3
    @State private var genre = "not selected"
    @State private var date = Date()
    
    var genres = ["not selected", "Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genere", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a review")
                }
                
                Section {
                    Button("Save") {
                        let newBook = Book(context: moc)
                        newBook.id = UUID()
                        newBook.title = title
                        newBook.author = author
                        newBook.rating = Int16(rating)
                        newBook.genre = genre
                        newBook.review = review
                        newBook.date = date
                        
                        try? moc.save()
                        
                        dismiss()
                    }
                }
                .disabled(title.isEmpty || author.isEmpty)
            }
            .navigationTitle("Add Book")
        }
    }
}

#Preview {
        AddBookView()
}
