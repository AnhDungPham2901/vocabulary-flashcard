//
//  ReviewModel.swift
//  frontend-ios
//
//  Created by PHAM ANH DUNG on 25/8/25.
//

import Foundation

struct ReviewModel: Codable, Identifiable {
    let id: String
    let flashcardId: String
    let difficulty: Int
    let correct: Bool
    let reviewedAt: Date?
    let nextReview: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case flashcardId
        case difficulty
        case correct
        case reviewedAt
        case nextReview
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        flashcardId = try container.decode(String.self, forKey: .flashcardId)
        difficulty = try container.decode(Int.self, forKey: .difficulty)
        correct = try container.decode(Bool.self, forKey: .correct)
        
        // Handle date decoding
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let reviewedAtString = try container.decodeIfPresent(String.self, forKey: .reviewedAt) {
            reviewedAt = dateFormatter.date(from: reviewedAtString)
        } else {
            reviewedAt = nil
        }
        
        if let nextReviewString = try container.decodeIfPresent(String.self, forKey: .nextReview) {
            nextReview = dateFormatter.date(from: nextReviewString)
        } else {
            nextReview = nil
        }
    }
}

struct ReviewStatsModel: Codable {
    let totalReviews: Int
    let correctReviews: Int
    let averageDifficulty: Double
    let streakDays: Int
    let cardsReviewedToday: Int
    let cardsDueToday: Int
    let accuracy: Double
    
    enum CodingKeys: String, CodingKey {
        case totalReviews
        case correctReviews
        case averageDifficulty
        case streakDays
        case cardsReviewedToday
        case cardsDueToday
        case accuracy
    }
}