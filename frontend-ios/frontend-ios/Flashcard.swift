//
//  Flashcard.swift
//  frontend-ios
//
//  Created by PHAM ANH DUNG on 24/8/25.
//

import SwiftUI

struct FlashcardModel {
    let id: Int
    let word: String
    let definition: String
    let exampleSentence: String
    let box: Int
}

struct FlashcardFrontView: View {
    let flashcard: FlashcardModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Word")
                .font(.caption)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .tracking(1)
            
            Text(flashcard.word)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
    }
}

struct FlashcardBackView: View {
    let flashcard: FlashcardModel
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text("Definition")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .tracking(1)
                
                Text(flashcard.definition)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            
            Divider()
                .background(Color.gray.opacity(0.3))
            
            VStack(spacing: 8) {
                Text("Example")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .tracking(1)
                
                Text(flashcard.exampleSentence)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .italic()
            }
        }
        .scaleEffect(x: -1, y: 1) // Fix reversed text
    }
}

struct FlashcardTapView: View {
    let flashcard: FlashcardModel
    @Binding var isFlipped: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Box indicator
            HStack {
                Spacer()
                Text("Box \(flashcard.box)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.blue.opacity(0.1))
                    )
            }
            
            Spacer()
            
            if !isFlipped {
                FlashcardFrontView(flashcard: flashcard)
            } else {
                FlashcardBackView(flashcard: flashcard)
            }
            
            Spacer()
            
            // Flip indicator
            HStack {
                Spacer()
                Image(systemName: "arrow.triangle.2.circlepath")
                    .foregroundColor(.blue)
                    .font(.caption)
                    .opacity(0.6)
                Text("Tap to flip")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(24)
        .onTapGesture {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isFlipped.toggle()
            }
        }
    }
}

struct FlashcardView: View {
    let flashcard: FlashcardModel
    @State private var isFlipped = false
    @State private var dragOffset = CGSize.zero
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            // Card container
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(.systemBackground),
                            Color(.secondarySystemBackground)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(
                    color: Color.black.opacity(0.1),
                    radius: 15,
                    x: 0,
                    y: 8
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.blue.opacity(0.3),
                                    Color.purple.opacity(0.2)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
            
            FlashcardTapView(flashcard: flashcard, isFlipped: $isFlipped)
        }
        .frame(width: 300, height: 400)
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .offset(dragOffset)
        .rotationEffect(.degrees(rotationAngle))
        .scaleEffect(dragOffset == .zero ? 1.0 : 0.95)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isFlipped)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: dragOffset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation
                    rotationAngle = Double(value.translation.width / 10)
                }
                .onEnded { value in
                    withAnimation(.spring()) {
                        dragOffset = .zero
                        rotationAngle = 0
                    }
                    
                    // Handle swipe actions (left/right for difficulty feedback)
                    if abs(value.translation.width) > 100 {
                        // Add your swipe action logic here
                        print(value.translation.width > 0 ? "Swiped right (easy)" : "Swiped left (hard)")
                    }
                }
        )
    }
}

#Preview {
    FlashcardView(
        flashcard: FlashcardModel(
            id: 1,
            word: "Serendipity",
            definition: "The occurrence and development of events by chance in a happy or beneficial way",
            exampleSentence: "A fortunate stroke of serendipity brought the old friends together after many years.",
            box: 2
        )
    )
    .preferredColorScheme(.light)
}

