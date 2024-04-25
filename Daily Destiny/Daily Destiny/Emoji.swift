//
//  Emoji.swift
//  DailyDestiny
//
//  Created by admin on 27.02.2024.
//

import SwiftUI

struct Emoji: View {
    //MARK: Emojis
    let emojiRanges = [
        0x1F3A0...0x1F3FF,  // Смайлики видів спорту
        0x1F601...0x1F64F, // Емоджі обличчя
        0x1F681...0x1F6C5, // Транспорт та місця
        0x1F30D...0x1F567, // Символи та піктограми
        0x1F3C6...0x1F3CA // Емоджі спортивних захоплень 
    ]
    var stickers: [String] {
        var array: [String] = []
        for range in emojiRanges {
            for i in range {
                let c = String(UnicodeScalar(i)!)
                array.append(c)
            }
        }
        return array
    }
    //MARK: NORM
    @Environment(\.dismiss) var dismiss
    let layout = [
        GridItem(.adaptive(minimum: 80, maximum: 120)),
    ]
    
    @Binding var emoji: String
    
    var body: some View {
        Text("Choose Emojis")
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 4), spacing: 10) {
                ForEach(stickers, id: \.self) { sticker in
                    Button(action: {
                        emoji = sticker
                            
                    }) {
                        Text(sticker)
                            .font(.system(size: 50))
                            .frame(width: 75, height: 60)
                            .background(emoji == sticker ? Color.red : Color.secondary)
                            .clipShape(.rect(cornerRadius: 20))
                            
                            
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    Emoji(emoji: .constant("😀"))
}
