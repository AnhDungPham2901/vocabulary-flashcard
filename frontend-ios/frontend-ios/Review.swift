//
//  Review.swift
//  frontend-ios
//
//  Created by PHAM ANH DUNG on 25/8/25.
//

import SwiftUI

struct ReviewBoxData {
    let number: Int
    let wordCount: Int
    let color: Color
}

struct Review: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var boxes: [ReviewBoxData] = [
        ReviewBoxData(number: 1, wordCount: 15, color: .red),
        ReviewBoxData(number: 2, wordCount: 8, color: .orange),
        ReviewBoxData(number: 3, wordCount: 12, color: .yellow),
        ReviewBoxData(number: 4, wordCount: 5, color: .green),
        ReviewBoxData(number: 5, wordCount: 3, color: .blue),
        ReviewBoxData(number: 6, wordCount: 1, color: .purple)
    ]
    
    @State private var currentFlashcard = FlashcardModel(
        id: 1,
        word: "Serendipity",
        definition: "The occurrence and development of events by chance in a happy or beneficial way",
        exampleSentence: "A fortunate stroke of serendipity brought the old friends together after many years.",
        box: 1
    )
    
    @State private var showTaskList = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Top Boxes Row
                HStack(spacing: 12) {
                    ForEach(boxes, id: \.number) { box in
                        ReviewBoxIcon(box: box)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                
                Spacer()
                
                // Flashcard
                FlashcardView(flashcard: currentFlashcard)
                
                Spacer()
                
                // Bottom Action Buttons
                HStack(spacing: 40) {
                    // Task Button
                    Button(action: {
                        showTaskList = true
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: "list.clipboard")
                                .font(.title2)
                                .foregroundColor(.blue)
                                .frame(width: 56, height: 56)
                                .background(
                                    Circle()
                                        .fill(Color.blue.opacity(0.1))
                                )
                            
                            Text("Tasks")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    // End Button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: "xmark.circle")
                                .font(.title2)
                                .foregroundColor(.red)
                                .frame(width: 56, height: 56)
                                .background(
                                    Circle()
                                        .fill(Color.red.opacity(0.1))
                                )
                            
                            Text("End")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding(.bottom, 40)
            }
            .sheet(isPresented: $showTaskList) {
                TaskList()
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

struct ReviewBoxIcon: View {
    let box: ReviewBoxData
    
    var body: some View {
        ZStack {
            // Box circle
            Circle()
                .fill(box.color.opacity(0.2))
                .frame(width: 40, height: 40)
            
            // Box number
            Text("\(box.number)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(box.color)
            
            // Word count bubble
            if box.wordCount > 0 {
                VStack {
                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(box.color)
                                .frame(width: 20, height: 20)
                            
                            Text("\(box.wordCount)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .offset(x: 8, y: -8)
                    }
                    Spacer()
                }
                .frame(width: 40, height: 40)
            }
        }
    }
}

#Preview {
    Review()
}
