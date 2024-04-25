//  DetailView.swift
//  SocialNetwork61
//
//  Created by admin on 14.03.2024.
//

import SwiftUI
import CoreData

struct PushButton: View {
    let title: String
    @Binding var isOn: Bool
    
    
    var body: some View {
        Button(title) {
            isOn.toggle()
        }
        .frame(width: 150, height: 30)
        .background(isOn ? Color.green : Color.red)
        .foregroundColor(.white)
        .clipShape(Capsule())
        .shadow(radius: 20)
    }
}


struct DetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var friends: FetchedResults<Friend>
    var friend: FriendData
    
    @State private var follow = true
    
    var body: some View {
        
        ZStack{
            Image(.city)
                .resizable()
                .blur(radius: 3)
            
            ScrollView {
                
                VStack{
                    AsyncImage(url: URL(string: friend.photo )) { image1 in
                        image1.resizable()
                            .scaledToFill()
                            .frame(width: 300, height: 300)
                            .clipShape(.circle)
                            .overlay {
                                Circle()
                                    .strokeBorder(Color.primary, lineWidth: 5)
                                
                            }
                            .shadow(radius: 10)
                            .padding(.top, 60)
                        
                    } placeholder: {
                        ProgressView()
                    }
                    VStack {
                        Text(status(friend.network_status))
                            .foregroundColor(friend.network_status ? Color.green : Color.red).bold()
                            .shadow(radius: 10)
                    }
                    
                    HStack {
                        Text(friend.firstname)
                        Text(friend.lastname)
                    }
                    .lineLimit(1)
                    .font(.system(size: 30))
                    .foregroundStyle(.white)
                    .shadow(radius: 10)
                    
                    HStack {
                        withAnimation {
                            PushButton(title: titlee(follow), isOn: $follow)
                        }
                        
                        Button("Message"){ }
                            .frame(width: 150, height: 30)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(radius: 20)
                    }
                    HStack{
                        
                        Image(systemName: "person.bubble")
                            .font(.system(size: 30))
                        Text("About")
                            .font(.title)
                            .bold()
                        Spacer()
                    }
                    .padding(.leading, 25)
                    .foregroundStyle(.white)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            ProfileDescriptionItemView(title: "Sex:", description: friend.sex)
                            ProfileDescriptionItemView(title: "Age:", description: friend.age.formatted())
                            ProfileDescriptionItemView(title: "Phone:", description: friend.number)
                            ProfileDescriptionItemView(title: "Email:", description: friend.email)
                            ProfileDescriptionItemView(title: "Date of registered:", description: friend.date_registered)
                            ProfileDescriptionItemView(title: "Address:", description: friend.address)
                        }
                        .padding()
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                        .padding(.bottom)
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Image(systemName: "text.bubble")
                            .font(.system(size: 30))
                        Text("Posts")
                            .font(.title)
                            .bold()
                    }
                    .foregroundStyle(.white)
                    .padding()
                    
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing) {
                            
                            Text(friend.message)
                        }
                        .padding()
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                        .padding(.bottom)
                        
                    }
                    Spacer()
                }
            }
        }
        .ignoresSafeArea()
        
        
    }
    func titlee(_ OnOff: Bool) -> String {
        return OnOff ? "Following" : "Follow"
    }
    
    func status(_ some: Bool) -> String {
        return some ? "Online" : "Offline"
    }
    
}

#Preview {
    DetailView(friend: FriendData(id: 1, firstname: "John", lastname: "Doe", age: 30, address: "123 Main St", date_registered: "2024-03-14", number: "123456789", message: "Hello", sex: "male", email: "lyuclyan.oleg14@gmail.com", photo: "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2", network_status: true))
        .environment(\.managedObjectContext, DataController(inMemory: true).container.viewContext)
}
