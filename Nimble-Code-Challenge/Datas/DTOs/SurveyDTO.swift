//
//  SurveyDTO.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 30/06/2022.
//

import Foundation

struct SurveyDTO: Decodable {
    
    let id, type, title, description, coverImageUrl, activeAt, surveyType: String
    let thankEmailAboveThreshold, thankEmailBelowThreshold, createdAt, inactiveAt: String?
    let isActive: Bool
    let questions: [Question]
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case title
        case description
        case thankEmailAboveThreshold = "thank_email_above_threshold"
        case thankEmailBelowThreshold = "thank_email_below_threshold"
        case isActive = "is_active"
        case coverImageUrl = "cover_image_url"
        case createdAt = "created_at"
        case activeAt = "active_at"
        case inactiveAt = "inactive_at"
        case surveyType = "survey_type"
        case questions
    }
    
    struct Question: Decodable {
        let id: String
        let type: String
    }
}

extension SurveyDTO {
    func toSurvey() -> Survey {
        return Survey(id: id, type: type, title: title,
                      description: description,
                      coverImageUrl: coverImageUrl)
    }
}
