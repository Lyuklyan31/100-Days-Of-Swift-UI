//
//  ProspectsView.swift
//  HotProspects
//
//  Created by admin on 31.03.2024.
//

import CodeScanner
import SwiftUI
import CoreData
import UserNotifications

struct ProspectsView: View {
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    @EnvironmentObject var prospects: Prospects
    let filter: FilterType
    
    @State private var isShowingScanner = false
    
    @State private var showConfirmationDialog = false
    
    var title: String {
        switch filter {
        case .none:
            "Everyone"
        case .contacted:
            "Contacted people"
        case .uncontacted:
            "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.iscontacted }
        case .uncontacted:
            return prospects.people.filter { !$0.iscontacted }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredProspects) { prospect in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        pictogram(prospect: prospect)
                            .font(.headline)
                    }
                    .swipeActions {
                        if prospect.iscontacted {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Uncontacted", systemImage: "person.crop.badge.xmark")
                            }
                            .tint(.blue)
                        } else {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)
                            
                            Button {
                                addNotification(for: prospect)
                            } label: {
                                Label("Remind Me", systemImage: "bell")
                            }
                            .tint(.orange)
                        }
                    }
                }
               
            }
            
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                       showConfirmationDialog = true
                    } label: {
                        Label("", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
            .confirmationDialog("Change background", isPresented: $showConfirmationDialog) {
                Button("By Name") {  prospects.sortByName() }
                Button("By Data") {  prospects.sortByData() }
            }
            .toolbar {
                Button{
                    isShowingScanner = true
                } label: {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
            }
                .sheet(isPresented: $isShowingScanner) {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
                }
            
        }
    }
    
    private func pictogram(prospect: Prospect) -> some View {
        let imageName = prospect.iscontacted ? "person.fill.checkmark" : "person.fill.xmark"
        return Image(systemName: imageName)
            .foregroundColor(prospect.iscontacted ? .green : .red)
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
       isShowingScanner = false
    
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }

            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]

            prospects.add(person)
           
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()

        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default

            //var dateComponents = DateComponents()
            //dateComponents.hour = 9
            //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }

        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
}

#Preview {
    let prospects = Prospects()
    return ProspectsView(filter: .none)
        .environmentObject(prospects)
}

