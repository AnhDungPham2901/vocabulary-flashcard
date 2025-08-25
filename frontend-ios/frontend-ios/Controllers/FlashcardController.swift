//
//  FlashcardController.swift
//  frontend-ios
//
//  Created by PHAM ANH DUNG on 25/8/25.
//

import Foundation
import SwiftUI

@MainActor
class FlashcardController: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var showSuccess = false
    @Published var successMessage: String?
    
    private let apiManager = APIManager.shared
    
    // MARK: - Get All Flashcards
    func getAllFlashcards() async -> [FlashcardModel]? {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await apiManager.get(
                endpoint: "/flashcards",
                responseType: [FlashcardModel].self
            )
            
            if response.success, let data = response.data {
                return data
            } else {
                showError(message: response.message ?? "Failed to fetch flashcards")
                return nil
            }
        } catch {
            showError(message: error.localizedDescription)
            return nil
        }
    }
    
    // MARK: - Create Flashcard
    func createFlashcard(front: String, back: String, boxId: String?) async -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        var parameters: [String: Any] = [
            "front": front,
            "back": back
        ]
        
        if let boxId = boxId {
            parameters["boxId"] = boxId
        }
        
        do {
            let response = try await apiManager.post(
                endpoint: "/flashcards",
                parameters: parameters,
                responseType: FlashcardModel.self
            )
            
            if response.success {
                showSuccess(message: "Flashcard created successfully!")
                return true
            } else {
                showError(message: response.message ?? "Failed to create flashcard")
                return false
            }
        } catch {
            showError(message: error.localizedDescription)
            return false
        }
    }
    
    // MARK: - Update Flashcard
    func updateFlashcard(id: String, front: String?, back: String?, boxId: String?) async -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        var parameters: [String: Any] = [:]
        if let front = front { parameters["front"] = front }
        if let back = back { parameters["back"] = back }
        if let boxId = boxId { parameters["boxId"] = boxId }
        
        do {
            let response = try await apiManager.put(
                endpoint: "/flashcards/\(id)",
                parameters: parameters,
                responseType: FlashcardModel.self
            )
            
            if response.success {
                showSuccess(message: "Flashcard updated successfully!")
                return true
            } else {
                showError(message: response.message ?? "Failed to update flashcard")
                return false
            }
        } catch {
            showError(message: error.localizedDescription)
            return false
        }
    }
    
    // MARK: - Delete Flashcard
    func deleteFlashcard(id: String) async -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await apiManager.delete(
                endpoint: "/flashcards/\(id)",
                responseType: EmptyResponse.self
            )
            
            if response.success {
                showSuccess(message: "Flashcard deleted successfully!")
                return true
            } else {
                showError(message: response.message ?? "Failed to delete flashcard")
                return false
            }
        } catch {
            showError(message: error.localizedDescription)
            return false
        }
    }
    
    // MARK: - Get Flashcard by ID
    func getFlashcard(id: String) async -> FlashcardModel? {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await apiManager.get(
                endpoint: "/flashcards/\(id)",
                responseType: FlashcardModel.self
            )
            
            if response.success, let data = response.data {
                return data
            } else {
                showError(message: response.message ?? "Failed to fetch flashcard")
                return nil
            }
        } catch {
            showError(message: error.localizedDescription)
            return nil
        }
    }
    
    // MARK: - Helper Methods
    private func showError(message: String) {
        errorMessage = message
        showError = true
    }
    
    private func showSuccess(message: String) {
        successMessage = message
        showSuccess = true
    }
    
    func clearMessages() {
        errorMessage = nil
        successMessage = nil
        showError = false
        showSuccess = false
    }
}