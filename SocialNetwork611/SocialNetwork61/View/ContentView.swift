//
//  ContentView.swift
//  SocialNetwork61
//
//  Created by admin on 14.03.2024.
//
import SwiftUI
import CoreData
import Kingfisher

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "id >= %d", 1)) var friends: FetchedResults<Friend>
    
    @State private var didLoadData = false
    @State private var muteUnMute = ["bell.fill", "bell.slash"]
    @State private var selectionMod = false
    @State private var pickerArray = ["All", "Online🟢", "Offline🔴"]
    @State private var selectionSort = "All"
    @State private var search = ""
    
    var sortedFriends: [Friend] {
        switch selectionSort {
        case "Online🟢": return friends.filter { $0.network_status == true }
        case "Offline🔴": return friends.filter { $0.network_status == false }
        default: return Array(friends)
        }
    }
    
    var filteredFriends: [Friend] {
        if search.isEmpty {
            return sortedFriends
        } else {
            return sortedFriends.filter { friend in
                let searchText = search.lowercased()
                return (friend.firstname?.lowercased().contains(searchText) ?? false) || (friend.lastname?.lowercased().contains(searchText) ?? false)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Filters")) {
                    Picker("", selection: $selectionSort) {
                        ForEach(pickerArray, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    TextField("\(Image(systemName: "magnifyingglass")) Search (\(Image(systemName:"command"))K)", text: $search)
                }
                
                Section(header: Text("Your friends")) {
                    List(filteredFriends, id: \.self) { friend in
                        NavigationLink(destination: DetailView(friend: .init(with: friend))) {
                            VStack(alignment: .leading) {
                                HStack {
                                    KFImage(URL(string: friend.photo ?? ""))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                        .shadow(radius: 20)
                                        .overlay(Circle().stroke(.purple))
                                        
                                        
//                                    AsyncImage(url: URL(string: friend.photo ?? "")) { image1 in
//                                        image1
//                                            .resizable()
//                                            .clipShape(Circle())
//                                            .scaledToFill()
//                                            .frame(width: 80, height: 80)
//                                            .shadow(radius: 20)
//                                            .overlay(Circle().stroke(.purple))
//                                    } placeholder: {
//                                        ProgressView()
//                                    }
                                    
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        Picker("", selection: $selectionMod) {
                                            ForEach(muteUnMute, id: \.self) { imageName in
                                                Image(systemName: imageName)
                                            }
                                        }
                                        .pickerStyle(MenuPickerStyle())
                                        
                                        HStack {
                                            Text(friend.firstname ?? "Unknown")
                                            Text(friend.lastname ?? "Unknown")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 5)
                                        .background(.regularMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .shadow(radius: 10)
                                        .font(.title2)
                                        .lineLimit(nil)
                                    
                                    }
                                    
                                }
                                
                                HStack {
                                    Text(friend.email ?? "")
                                        .font(.footnote)
                                        .padding(6)
                                        .background(.regularMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    Spacer()
                                    
                                    Text(status(friend.network_status))
                                        .foregroundColor(friend.network_status ? Color.green : Color.red)
                                        .font(.system(size: 15))
                                        .padding(6)
                                        .background(.regularMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                
                                Text(friend.message ?? "Unknown")
                                    .font(.system(size: 12))
                                    .lineLimit(3)
                                    .padding(6)
                                    .background(.regularMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .padding()
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparatorTint(.purple)
                }
            }
            .padding(.horizontal, -15)
            .navigationTitle("Friends")
            .ignoresSafeArea(.all, edges: .bottom)
            .task {
                if !didLoadData {
                    await loadData()
                    didLoadData = true
                }
                
            }
        }
    }
    
    func status(_ some: Bool) -> String {
        return some ? "online" : "offline"
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, DataController(inMemory: true).container.viewContext)
}
