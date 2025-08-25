//
//  FlashcardModel.swift
//  frontend-ios
//
//  Created by PHAM ANH DUNG on 25/8/25.
//

import Foundation

struct FlashcardModel: Codable, Identifiable {
    let id: String
    let front: String
    let back: String
    let boxId: String?
    let createdAt: Date?
    let updatedAt: Date?
    let reviewCount: Int?
    let lastReviewed: Date?
    let difficulty: Int?
    let nextReview: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case front
        case back
        case boxId
        case createdAt
        case updatedAt
        case reviewCount
        case lastReviewed
        case difficulty
        case nextReview
    }
    
    init(
        id: String,
        front: String,
        back: String,
        boxId: String? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        reviewCount: Int? = nil,
        lastReviewed: Date? = nil,
        difficulty: Int? = nil,
        nextReview: Date? = nil
    ) {
        self.id = id
        self.front = front
        self.back = back
        self.boxId = boxId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.reviewCount = reviewCount
        self.lastReviewed = lastReviewed
        self.difficulty = difficulty
        self.nextReview = nextReview
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        front = try container.decode(String.self, forKey: .front)
        back = try container.decode(String.self, forKey: .back)
        boxId = try container.decodeIfPresent(String.self, forKey: .boxId)
        reviewCount = try container.decodeIfPresent(Int.self, forKey: .reviewCount)
        difficulty = try container.decodeIfPresent(Int.self, forKey: .difficulty)
        
        // Handle date decoding
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let createdAtString = try container.decodeIfPresent(String.self, forKey: .createdAt) {
            createdAt = dateFormatter.date(from: createdAtString)
        } else {
            createdAt = nil
        }
        
        if let updatedAtString = try container.decodeIfPresent(String.self, forKey: .updatedAt) {
            updatedAt = dateFormatter.date(from: updatedAtString)
        } else {
            updatedAt = nil
        }
        
        if let lastReviewedString = try container.decodeIfPresent(String.self, forKey: .lastReviewed) {
            lastReviewed = dateFormatter.date(from: lastReviewedString)
        } else {
            lastReviewed = nil
        }
        
        if let nextReviewString = try container.decodeIfPresent(String.self, forKey: .nextReview) {
            nextReview = dateFormatter.date(from: nextReviewString)
        } else {
            nextReview = nil
        }
    }
}