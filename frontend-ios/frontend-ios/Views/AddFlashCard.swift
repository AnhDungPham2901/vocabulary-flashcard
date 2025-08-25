//
//  AddFlashCard.swift
//  frontend-ios
//
//  Created by PHAM ANH DUNG on 25/8/25.
//

import SwiftUI

struct AddFlashCard: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var word: String = ""
    @State private var definition: String = ""
    @State private var exampleSentence: String = ""
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
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
                .ignoresSafeArea()
            )
            .navigationBarHidden(true)
            .overlay(
                // Action Buttons
                VStack {
                    Spacer()
                    
                    HStack(spacing: 16) {
                        // Cancel Button
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
                        
                        // Save Button
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
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            )
        }
    }
    
    private var isFormValid: Bool {
        !word.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !definition.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !exampleSentence.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveFlashcard() {
        isLoading = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.tertiarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
            )
            .font(.body)
    }
}

#Preview {
    AddFlashCard()
}
