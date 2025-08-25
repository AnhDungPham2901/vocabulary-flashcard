//
//  BoxDetail.swift
//  frontend-ios
//
//  Created by PHAM ANH DUNG on 24/8/25.
//

import SwiftUI

struct WordListItem {
    let id: Int
    let word: String
    let definition: String
    let exampleSentence: String
    let box: Int
    let createdAt: Date
}

struct BoxDetail: View {
    let boxData: BoxData
    @Environment(\.presentationMode) var presentationMode
    
    @State private var words: [WordListItem] = [
        WordListItem(id: 1, word: "Serendipity", definition: "The occurrence and development of events by chance in a happy or beneficial way", exampleSentence: "A fortunate stroke of serendipity brought the old friends together after many years.", box: 1, createdAt: Date()),
        WordListItem(id: 2, word: "Ephemeral", definition: "Lasting for a very short time", exampleSentence: "The beauty of cherry blossoms is ephemeral, lasting only a few weeks.", box: 1, createdAt: Date()),
        WordListItem(id: 3, word: "Mellifluous", definition: "Sweet or musical; pleasant to hear", exampleSentence: "Her mellifluous voice captivated the entire audience.", box: 1, createdAt: Date()),
        WordListItem(id: 4, word: "Ubiquitous", definition: "Present, appearing, or found everywhere", exampleSentence: "Smartphones have become ubiquitous in modern society.", box: 1, createdAt: Date()),
        WordListItem(id: 5, word: "Quintessential", definition: "Representing the most perfect example of a quality", exampleSentence: "Paris is the quintessential romantic city.", box: 1, createdAt: Date())
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                // Box Info
                HStack {
                    ZStack {
                        Circle()
                            .fill(boxData.color.opacity(0.2))
                            .frame(width: 60, height: 60)
                        
                        Text("\(boxData.number)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(boxData.color)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(boxData.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("\(words.count) words")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemBackground),
                        Color(.secondarySystemBackground)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            Divider()
                .background(Color.gray.opacity(0.3))
            
            // Words List
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(words, id: \.id) { word in
                        NavigationLink(destination: CardDetail(word: word)) {
                            WordRowView(word: word, boxColor: boxData.color)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Color(.systemBackground))
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct WordRowView: View {
    let word: WordListItem
    let boxColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Word and date
            HStack {
                Text(word.word)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(RelativeDateTimeFormatter().localizedString(for: word.createdAt, relativeTo: Date()))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(boxColor.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    BoxDetail(boxData: BoxData(number: 1, wordCount: 15, color: .red, title: "Review Daily"))
}
