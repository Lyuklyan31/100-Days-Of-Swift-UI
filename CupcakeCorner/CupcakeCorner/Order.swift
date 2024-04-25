//
//  Order.swift
//  CupcakeCorner
//
//  Created by admin on 06.03.2024.
//

import Foundation

struct Address: Codable {
    var name: String
    var streetAddress: String
    var city: String
    var zip: String
}

class Order: ObservableObject, Codable {
    static let types = [
        "Vanilla",
        "Strawberry",
        "Chocolate",
        "Rainbow"
    ]
    
    @Published var type = 0
    @Published var quantity = 3
    
    @Published var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    @Published var extraFrosting = false
    @Published var addSprinkles = false
    
    @Published var address = Address(name: "", streetAddress: "", city: "", zip: "") {
        didSet {
            saveAddress()
        }
    }
    
    init() {
        loadAddress()
    }
    
    func saveAddress() {
        if let encoded = try? JSONEncoder().encode(address) {
            UserDefaults.standard.set(encoded, forKey: "Address")
        }
    }
    
    func loadAddress() {
        if let savedAddress = UserDefaults.standard.data(forKey: "Address") {
            if let loadedAddress = try? JSONDecoder().decode(Address.self, from: savedAddress) {
                address = loadedAddress
                return
            }
        }
        address = Address(name: "", streetAddress: "", city: "", zip: "")
    }
    
    var hasValidAddress: Bool {
        let fields = [address.name, address.streetAddress, address.city, address.zip]
        
        for field in fields {
            if field.isEmpty || field.contains(" ") || field.contains("\n") {
                return false
            }
        }
        return true
    }
    
    var cost: Double {
        var cost = Double(quantity) * 2
        cost += (Double(type) / 2)
        if extraFrosting {
            cost += Double(quantity)
        }
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        return cost
    }
    
    enum CodingKeys: CodingKey {
        case type
        case quantity
        case extraFrosting
        case addSprinkles
        case name
        case streetAddress
        case city
        case zip
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)
        try container.encode(address.name, forKey: .name)
        try container.encode(address.streetAddress, forKey: .streetAddress)
        try container.encode(address.city, forKey: .city)
        try container.encode(address.zip, forKey: .zip)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)
        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
        address.name = try container.decode(String.self, forKey: .name)
        address.streetAddress = try container.decode(String.self, forKey: .streetAddress)
        address.city = try container.decode(String.self, forKey: .city)
        address.zip = try container.decode(String.self, forKey: .city)
    }
}
