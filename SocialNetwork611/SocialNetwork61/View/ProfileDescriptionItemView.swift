//
//  ProfileDescriptionItemView.swift
//  SocialNetwork61
//
//  Created by Andrii Boichuk on 23.03.2024.
//

import SwiftUI

struct ProfileDescriptionItemView: View {
    let title: String
    let description: String
    
    var body: some View {
        Text(title + " ") +
        Text(description)
    }
}

//#Preview {
//    ProfileDescriptionItemView()
//}
