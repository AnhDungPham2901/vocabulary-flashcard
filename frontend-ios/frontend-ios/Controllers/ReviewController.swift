//
//  ReviewController.swift
//  frontend-ios
//
//  Created by PHAM ANH DUNG on 25/8/25.
//

import Foundation
import SwiftUI

@MainActor
class ReviewController: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var showSuccess = false
    @Published var successMessage: String?
    
    private let apiManager = APIManager.shared
    
    // MARK: - Submit Review
    func submitReview(flashcardId: String, difficulty: Int, correct: Bool) async -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        let parameters: [String: Any] = [
            "flashcardId": flashcardId,
            "difficulty": difficulty,
            "correct": correct
        ]
        
        do {
            let response = try await apiManager.post(
                endpoint: "/reviews",
                parameters: parameters,
                responseType: ReviewModel.self
            )
            
            if response.success {
                showSuccess(message: "Review submitted successfully!")
                return true
            } else {
                showError(message: response.message ?? "Failed to submit review")
                return false
            }
        } catch {
            showError(message: error.localizedDescription)
            return false
        }
    }
    
    // MARK: - Get Cards Due for Review
    func getCardsDueForReview() async -> [FlashcardModel]? {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await apiManager.get(
                endpoint: "/reviews/due",
                responseType: [FlashcardModel].self
            )
            
            if response.success, let data = response.data {
                return data
            } else {
                showError(message: response.message ?? "Failed to fetch due cards")
                return nil
            }
        } catch {
            showError(message: error.localizedDescription)
            return nil
        }
    }
    
    // MARK: - Get Review Statistics
    func getReviewStats() async -> ReviewStatsModel? {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await apiManager.get(
                endpoint: "/reviews/stats",
                responseType: ReviewStatsModel.self
            )
            
            if response.success, let data = response.data {
                return data
            } else {
                showError(message: response.message ?? "Failed to fetch review stats")
                return nil
            }
        } catch {
            showError(message: error.localizedDescription)
            return nil
        }
    }
    
    // MARK: - Get Cards for Box Review
    func getCardsForBoxReview(boxId: String) async -> [FlashcardModel]? {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await apiManager.get(
                endpoint: "/reviews/box/\(boxId)",
                responseType: [FlashcardModel].self
            )
            
            if response.success, let data = response.data {
                return data
            } else {
                showError(message: response.message ?? "Failed to fetch box review cards")
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