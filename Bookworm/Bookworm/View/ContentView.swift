import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.title), //order: .reverse)  //сортування у алф порядку навпаки
        SortDescriptor(\.author)
    ]) var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false
    var body: some View {
        NavigationView {
            List {
                ForEach(books) { book in
                    NavigationLink {
                        DetailView(book: book)
                    } label: {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text(book.title ?? "Unknow Title")
                                    .font(.headline)
                                    .foregroundColor(textColor(for: Int(book.rating)))
                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            VStack {
                                Text(formattedDate(from: book.date!))
                            }
                        
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("Bookworm")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddScreen.toggle()
                    } label: {
                        Label("Add Book", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
            }
        }
    }
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            // знайдіть цю книгу в нашому запиті на вибірку
            let book = books[offset]
            
            // видалити його з контексту
            moc.delete(book)
        }
        // зберегти контекст
        try? moc.save()
    }
    
    func textColor(for rating: Int) -> Color {
        switch rating {
        case 1:
            return .red
        default:
            return .primary
        }
    }
    
    func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = """
        dd.MM.yyyy
             HH:mm
        """
        return formatter.string(from: date)
    }
}
#Preview {
    
        Group {
            ContentView()
            
        }
        
}
