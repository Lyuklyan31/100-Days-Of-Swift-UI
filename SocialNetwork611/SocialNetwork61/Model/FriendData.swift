//
//  FriendData.swift
//  SocialNetwork61
//
//  Created by admin on 15.03.2024.
//


import Foundation

struct FriendData: Codable, Hashable {
    let id: Int
    let firstname: String
    let lastname: String
    let age: Int
    let address: String
    let date_registered: String
    let number: String
    let message: String
    let sex: String
    let email: String
    let photo: String
    let network_status: Bool
}

extension FriendData {
    init(with friend: Friend) {
        id = Int(friend.id)
        firstname = friend.firstname ?? ""
        lastname = friend.lastname ?? ""
        age = Int(friend.age)
        address = friend.address ?? ""
        date_registered = friend.date_registered ?? ""
        number = friend.number ?? ""
        message = friend.message ?? ""
        sex = friend.sex ?? ""
        email = friend.email ?? ""
        photo = friend.photo ?? ""
        network_status = friend.network_status
    }
}
