//
//  DataController.swift
//  HotProspects
//
//  Created by admin on 31.03.2024.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var iscontacted = false
}

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    private var originalPeople: [Prospect] = []
    let saveKey = "SavedData"
    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decode = try? JSONDecoder().decode([Prospect].self, from: data) {
                people = decode
                return
            }
        }
        people = []
    }
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.iscontacted.toggle()
        save()
    }
    func sortByName() {
        originalPeople = people
        people.sort { $0.name < $1.name }
    }
    
    func sortByData() {
        people = originalPeople
    }

    
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    func add(_ prospect: Prospect) {
        people.insert(prospect, at: 0)
        save()
    }
}
