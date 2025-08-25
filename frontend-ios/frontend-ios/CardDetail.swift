//
//  CardDetail.swift
//  frontend-ios
//
//  Created by PHAM ANH DUNG on 25/8/25.
//

import SwiftUI

struct CardDetail: View {
  let word: WordListItem
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        // Word Header
        VStack(spacing: 12) {
          Text(word.word)
            .font(.system(size: 36, weight: .bold, design: .rounded))
            .foregroundColor(.primary)
            .multilineTextAlignment(.center)

          Text(DateFormatter.shortDate.string(from: word.createdAt))
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.top, 40)

        // Definition Section
        VStack(alignment: .leading, spacing: 12) {
          HStack {
            Image(systemName: "book.closed.fill")
              .foregroundColor(.blue)
            Text("Definition")
              .font(.headline)
              .fontWeight(.semibold)
              .foregroundColor(.primary)
          }

          Text(word.definition)
            .font(.body)
            .foregroundColor(.primary)
            .lineSpacing(4)
            .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
          RoundedRectangle(cornerRadius: 16)
            .fill(Color(.secondarySystemBackground))
            .overlay(
              RoundedRectangle(cornerRadius: 16)
                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
            )
        )
        .padding(.horizontal, 20)

        // Example Section
        VStack(alignment: .leading, spacing: 12) {
          HStack {
            Image(systemName: "quote.bubble.fill")
              .foregroundColor(.orange)
            Text("Example")
              .font(.headline)
              .fontWeight(.semibold)
              .foregroundColor(.primary)
          }

          Text(word.exampleSentence)
            .font(.body)
            .foregroundColor(.secondary)
            .italic()
            .lineSpacing(4)
            .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
          RoundedRectangle(cornerRadius: 16)
            .fill(Color(.secondarySystemBackground))
            .overlay(
              RoundedRectangle(cornerRadius: 16)
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
            )
        )
        .padding(.horizontal, 20)
      }
    }
    .background(
      LinearGradient(
        gradient: Gradient(colors: [
          Color(.systemBackground),
          Color(.secondarySystemBackground),
        ]),
        startPoint: .top,
        endPoint: .bottom
      )
      .ignoresSafeArea()
    )
    .navigationBarTitleDisplayMode(.inline)
  }
}

extension DateFormatter {
  static let shortDate: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
  }()
}

#Preview {
  CardDetail(
    word: WordListItem(
      id: 1,
      word: "Serendipity",
      definition: "The occurrence and development of events by chance in a happy or beneficial way",
      exampleSentence:
        "A fortunate stroke of serendipity brought the old friends together after many years.",
      box: 1,
      createdAt: Date()
    ))
}
