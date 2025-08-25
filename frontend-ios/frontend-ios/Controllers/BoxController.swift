//
//  BoxController.swift
//  frontend-ios
//
//  Created by PHAM ANH DUNG on 25/8/25.
//

import Foundation
import SwiftUI

@MainActor
class BoxController: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var showSuccess = false
    @Published var successMessage: String?
    
    private let apiManager = APIManager.shared
    
    // MARK: - Get All Boxes
    func getAllBoxes() async -> [BoxModel]? {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await apiManager.get(
                endpoint: "/boxes",
                responseType: [BoxModel].self
            )
            
            if response.success, let data = response.data {
                return data
            } else {
                showError(message: response.message ?? "Failed to fetch boxes")
                return nil
            }
        } catch {
            showError(message: error.localizedDescription)
            return nil
        }
    }
    
    // MARK: - Create Box
    func createBox(name: String, description: String?) async -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        var parameters: [String: Any] = ["name": name]
        if let description = description {
            parameters["description"] = description
        }
        
        do {
            let response = try await apiManager.post(
                endpoint: "/boxes",
                parameters: parameters,
                responseType: BoxModel.self
            )
            
            if response.success {
                showSuccess(message: "Box created successfully!")
                return true
            } else {
                showError(message: response.message ?? "Failed to create box")
                return false
            }
        } catch {
            showError(message: error.localizedDescription)
            return false
        }
    }
    
    // MARK: - Update Box
    func updateBox(id: String, name: String?, description: String?) async -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        var parameters: [String: Any] = [:]
        if let name = name { parameters["name"] = name }
        if let description = description { parameters["description"] = description }
        
        do {
            let response = try await apiManager.put(
                endpoint: "/boxes/\(id)",
                parameters: parameters,
                responseType: BoxModel.self
            )
            
            if response.success {
                showSuccess(message: "Box updated successfully!")
                return true
            } else {
                showError(message: response.message ?? "Failed to update box")
                return false
            }
        } catch {
            showError(message: error.localizedDescription)
            return false
        }
    }
    
    // MARK: - Delete Box
    func deleteBox(id: String) async -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await apiManager.delete(
                endpoint: "/boxes/\(id)",
                responseType: EmptyResponse.self
            )
            
            if response.success {
                showSuccess(message: "Box deleted successfully!")
                return true
            } else {
                showError(message: response.message ?? "Failed to delete box")
                return false
            }
        } catch {
            showError(message: error.localizedDescription)
            return false
        }
    }
    
    // MARK: - Get Box by ID
    func getBox(id: String) async -> BoxModel? {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await apiManager.get(
                endpoint: "/boxes/\(id)",
                responseType: BoxModel.self
            )
            
            if response.success, let data = response.data {
                return data
            } else {
                showError(message: response.message ?? "Failed to fetch box")
                return nil
            }
        } catch {
            showError(message: error.localizedDescription)
            return nil
        }
    }
    
    // MARK: - Get Flashcards in Box
    func getFlashcardsInBox(boxId: String) async -> [FlashcardModel]? {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await apiManager.get(
                endpoint: "/boxes/\(boxId)/flashcards",
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