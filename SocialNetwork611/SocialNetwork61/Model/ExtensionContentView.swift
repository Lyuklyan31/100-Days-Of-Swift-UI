//
//  ExtansionContentView.swift
//  SocialNetwork61
//
//  Created by admin on 16.03.2024.
//

import Foundation

extension ContentView {
    func loadData() async {
        guard let url = URL(string: "https://mocki.io/v1/d5857911-7ae9-4cda-8877-74165e240045") else {
            print("Invalid URL")
            return
        }
        do {
            for friend in friends {
                moc.delete(friend)
            }
            try? moc.save()
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodeResponse = try? JSONDecoder().decode([FriendData].self, from: data) {
                for friendData in decodeResponse {
                    let friend = Friend(context: moc)
                    friend.update(with: friendData)
                }
                
                if moc.hasChanges {
                    try? moc.save()
                }
            }
        } catch {
            print("Error loading data: \(error)")
        }
    }
}

extension Friend {
    func update(with friend: FriendData) {
        self.id = Int16(friend.id)
        self.firstname = friend.firstname
        self.lastname = friend.lastname
        self.age = Int16(friend.age)
        self.address = friend.address
        self.date_registered = friend.date_registered
        self.number = friend.number
        self.message = friend.message
        self.sex = friend.sex
        self.email = friend.email
        self.photo = friend.photo
        self.network_status = Bool(friend.network_status)
    }
}


