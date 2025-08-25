//
//  APIManager.swift
//  frontend-ios
//
//  Created by PHAM ANH DUNG on 25/8/25.
//

import Foundation
import Combine

class APIManager {
    static let shared = APIManager()
    
    private let baseURL = "https://your-api-base-url.com/api" // Replace with your actual API base URL
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    private init() {
        decoder.dateDecodingStrategy = .iso8601
    }
    
    // MARK: - Generic API Request Method
    func request<T: Codable>(
        endpoint: String,
        method: HTTPMethod = .GET,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> APIResponse<T> {
        
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30.0
        
        // Set default headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Add custom headers
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Add parameters for POST, PUT, PATCH requests
        if let parameters = parameters,
           [HTTPMethod.POST, HTTPMethod.PUT, HTTPMethod.PATCH].contains(method) {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                throw APIError.networkError("Failed to serialize parameters")
            }
        }
        
        // Add parameters as query string for GET requests
        if let parameters = parameters, method == .GET {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            if let newURL = components?.url {
                request.url = newURL
            }
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unknown
            }
            
            return try handleResponse(data: data, httpResponse: httpResponse, responseType: responseType)
            
        } catch let error as APIError {
            throw error
        } catch {
            if error.localizedDescription.contains("timeout") {
                throw APIError.timeout
            } else {
                throw APIError.networkError(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Response Handler
    private func handleResponse<T: Codable>(
        data: Data,
        httpResponse: HTTPURLResponse,
        responseType: T.Type
    ) throws -> APIResponse<T> {
        
        let statusCode = httpResponse.statusCode
        
        // Handle different status codes
        switch statusCode {
        case 200...299:
            // Success
            do {
                if T.self == EmptyResponse.self {
                    return APIResponse<T>(
                        success: true,
                        data: EmptyResponse() as? T,
                        message: "Success",
                        error: nil,
                        statusCode: statusCode
                    )
                }
                
                // Try to decode as APIResponse first
                if let apiResponse = try? decoder.decode(APIResponse<T>.self, from: data) {
                    return apiResponse
                }
                
                // If not APIResponse format, try to decode directly as T
                let decodedData = try decoder.decode(T.self, from: data)
                return APIResponse<T>(
                    success: true,
                    data: decodedData,
                    message: "Success",
                    error: nil,
                    statusCode: statusCode
                )
            } catch {
                throw APIError.decodingError
            }
            
        case 401:
            throw APIError.unauthorized
            
        case 403:
            throw APIError.forbidden
            
        case 404:
            throw APIError.notFound
            
        case 400...499:
            // Client error
            if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                throw APIError.serverError(statusCode, errorResponse.message)
            } else {
                throw APIError.serverError(statusCode, "Client error")
            }
            
        case 500...599:
            // Server error
            if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                throw APIError.serverError(statusCode, errorResponse.message)
            } else {
                throw APIError.serverError(statusCode, "Server error")
            }
            
        default:
            throw APIError.unknown
        }
    }
    
    // MARK: - Convenience Methods
    func get<T: Codable>(
        endpoint: String,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> APIResponse<T> {
        return try await request(
            endpoint: endpoint,
            method: .GET,
            parameters: parameters,
            headers: headers,
            responseType: responseType
        )
    }
    
    func post<T: Codable>(
        endpoint: String,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> APIResponse<T> {
        return try await request(
            endpoint: endpoint,
            method: .POST,
            parameters: parameters,
            headers: headers,
            responseType: responseType
        )
    }
    
    func put<T: Codable>(
        endpoint: String,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> APIResponse<T> {
        return try await request(
            endpoint: endpoint,
            method: .PUT,
            parameters: parameters,
            headers: headers,
            responseType: responseType
        )
    }
    
    func delete<T: Codable>(
        endpoint: String,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> APIResponse<T> {
        return try await request(
            endpoint: endpoint,
            method: .DELETE,
            parameters: parameters,
            headers: headers,
            responseType: responseType
        )
    }
}

// MARK: - Empty Response for requests that don't return data
struct EmptyResponse: Codable {
    init() {}
}