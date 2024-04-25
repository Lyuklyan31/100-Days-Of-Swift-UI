//
//  CardView.swift
//  Flashzilla
//
//  Created by admin on 04.04.2024.
//

import SwiftUI

struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var VoiceOverEnabled
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    @State private var feedBack = UINotificationFeedbackGenerator()
    
    let card: Card
    var removal: (() -> Void)? = nil
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    differentiateWithoutColor
                    ? .white
                    : .white
                        .opacity(1 - Double(abs(offset.width / 50)))
                )
                .background(
                    differentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(offset.width > 0 ? .green : .red)
                    )
                .shadow(radius: 10)
            
            VStack {
                if VoiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width / 50)))
        .gesture(
        DragGesture()
            .onChanged { gesture in
                offset = gesture.translation
                feedBack.prepare()
            }
            .onEnded { _ in
                if abs(offset.width) > 100 {
                    if offset.width > 0 {
                        feedBack.notificationOccurred(.success)
                    } else {
                        feedBack.notificationOccurred(.error)
                    }
                    
                    
                  removal?()
                } else {
                    offset = .zero
                }
            }
        )
        
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.spring, value: offset)
    }
    
}

#Preview {
    CardView(card: Card.example)
}
