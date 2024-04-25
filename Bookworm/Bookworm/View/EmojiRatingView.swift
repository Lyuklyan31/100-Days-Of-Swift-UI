//
//  EmojiRatingView.swift
//  Bookworm
//
//  Created by admin on 08.03.2024.
//

import SwiftUI

struct EmojiRatingView: View {
    let rating: Int16
    var body: some View {
        switch rating{
        case 1:
            Text("🙈")
        case 2:
            Text("😔")
        case 3:
            Text("🙂")
        case 4:
            Text("😊")
        default:
            Text("🤩")
        }
    }
}

#Preview {
        EmojiRatingView(rating: 2)
}
