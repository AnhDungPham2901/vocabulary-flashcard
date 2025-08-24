//
//  Home.swift
//  frontend-ios
//
//  Created by PHAM ANH DUNG on 24/8/25.
//

import SwiftUI

struct BoxData {
    let number: Int
    let wordCount: Int
    let color: Color
    let title: String
}

struct Home: View {
    @State private var boxes: [BoxData] = [
        BoxData(number: 1, wordCount: 15, color: .red, title: "Review Daily"),
        BoxData(number: 2, wordCount: 8, color: .orange, title: "Review Bi-Daily"),
        BoxData(number: 3, wordCount: 12, color: .yellow, title: "Review Weekly"),
        BoxData(number: 4, wordCount: 5, color: .green, title: "Review Bi-Weekly"),
        BoxData(number: 5, wordCount: 3, color: .blue, title: "Review Monthly"),
        BoxData(number: 6, wordCount: 1, color: .purple, title: "Review Bi-Monthly")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemBackground),
                        Color(.secondarySystemBackground)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Vocabulary Flashcards")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("Leitner System Learning")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Boxes Grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                        ForEach(boxes, id: \.number) { box in
                            BoxView(box: box)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Start Review Button
                    Button(action: {
                        // Handle start review
                        print("Start Review tapped")
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "brain.head.profile")
                                .font(.title2)
                            Text("Start Review")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 20)
                    
                    // Add Button
                    Button(action: {
                        // Handle add new card
                        print("Add new card tapped")
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "plus")
                                .font(.title2)
                            Text("Add New Card")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.green, .mint]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct BoxView: View {
    let box: BoxData
    
    var body: some View {
        VStack(spacing: 12) {
            // Box icon and number
            ZStack {
                Circle()
                    .fill(box.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Text("\(box.number)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(box.color)
            }
            
            // Box title
            Text(box.title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            // Word count with icon
            HStack(spacing: 4) {
                Image(systemName: "doc.text")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("\(box.wordCount) words")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(box.color.opacity(0.3), lineWidth: 1)
        )
        .onTapGesture {
            print("Box \(box.number) tapped")
        }
    }
}

#Preview {
    Home()
}
