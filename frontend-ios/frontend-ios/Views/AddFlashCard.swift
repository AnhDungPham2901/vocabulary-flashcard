//
//  AddFlashCard.swift
//  frontend-ios
//
//  Created by PHAM ANH DUNG on 25/8/25.
//

import SwiftUI

struct AddFlashCard: View {
  @State private var word: String = ""
  @State private var definition: String = ""
  @State private var exampleSentence: String = ""

  var body: some View {
    VStack(spacing: 24) {
      // Form Fields
      VStack(spacing: 20) {
        // Word Field
        VStack(alignment: .leading, spacing: 8) {
          HStack {
            Image(systemName: "textformat.abc")
              .foregroundColor(.blue)
            Text("Word")
              .font(.headline)
              .foregroundColor(.primary)
          }

          TextField("Enter the word", text: $word)
            .textFieldStyle(CustomTextFieldStyle())
        }

        // Definition Field
        VStack(alignment: .leading, spacing: 8) {
          HStack {
            Image(systemName: "book.closed")
              .foregroundColor(.green)
            Text("Definition")
              .font(.headline)
              .foregroundColor(.primary)
          }

          TextField("Enter the definition", text: $definition, axis: .vertical)
            .textFieldStyle(CustomTextFieldStyle())
            .lineLimit(3...6)
        }

        // Example Sentence Field
        VStack(alignment: .leading, spacing: 8) {
          HStack {
            Image(systemName: "quote.bubble")
              .foregroundColor(.orange)
            Text("Example Sentence")
              .font(.headline)
              .foregroundColor(.primary)
          }

          TextField("Enter an example sentence", text: $exampleSentence, axis: .vertical)
            .textFieldStyle(CustomTextFieldStyle())
            .lineLimit(2...4)
        }
      }
      .padding(.horizontal, 20)
      .padding(.top, 40)

      Spacer(minLength: 100)
    }
    .onTapGesture {
      // Dismiss keyboard when tapping outside text fields
      UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder),
        to: nil,
        from: nil,
        for: nil)
    }
    // want to split with the form and fix position at bottom
    .overlay(
      // Action Buttons
      VStack {
        Spacer()

        HStack(spacing: 16) {
          CancelButton()
          SaveButton(word: $word, definition: $definition, exampleSentence: $exampleSentence)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
      }
    )
  }
}

struct CancelButton: View {
  @Environment(\.presentationMode) var presentationMode
  var body: some View {
    Button(action: {
      presentationMode.wrappedValue.dismiss()
    }) {
      HStack {
        Image(systemName: "xmark")
        Text("Cancel")
      }
      .foregroundColor(.red)
      .frame(maxWidth: .infinity)
      .frame(height: 50)
      .background(
        RoundedRectangle(cornerRadius: 12)
          .fill(Color.red.opacity(0.1))
          .overlay(
            RoundedRectangle(cornerRadius: 12)
              .stroke(Color.red.opacity(0.3), lineWidth: 1)
          )
      )
    }
  }
}

struct SaveButton: View {
  @Binding var word: String
  @Binding var definition: String
  @Binding var exampleSentence: String
  @State private var isLoading: Bool = false
  @Environment(\.presentationMode) var presentationMode  // it's used to dismiss .sheet after saving successfully
  var body: some View {
    Button(action: {
      saveFlashcard()
    }) {
      HStack {
        if isLoading {
          ProgressView()
            .scaleEffect(0.8)
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
        } else {
          Image(systemName: "checkmark")
        }
        Text(isLoading ? "Saving..." : "Save Card")
      }
      .foregroundColor(.white)
      .frame(maxWidth: .infinity)
      .frame(height: 50)
      .background(
        LinearGradient(
          gradient: Gradient(colors: [.blue, .purple]),
          startPoint: .leading,
          endPoint: .trailing
        )
        .opacity(isFormValid ? 1.0 : 0.5)
      )
      .cornerRadius(12)
    }
    .disabled(!isFormValid || isLoading)
  }

  private func saveFlashcard() {
    isLoading = true

    // Simulate API call
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      isLoading = false
      presentationMode.wrappedValue.dismiss()
    }
  }

  private var isFormValid: Bool {
    !word.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
      && !definition.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
      && !exampleSentence.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
}

#Preview {
  AddFlashCard()
}
