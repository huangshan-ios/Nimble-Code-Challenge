//
//  SurveyDTO.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 30/06/2022.
//

import Foundation

struct SurveyDTO: Decodable {
    let id, type: String
    let attributes: Attributes
    let relationships: Relationships
    
    struct Attributes: Codable {
        let title, description: String
        let thank_email_above_threshold: String?
        let thank_email_below_threshold: String?
        let is_active: Bool
        let cover_image_url: String
        let created_at, active_at: String
        let inactive_at: String?
        let survey_type: String
    }
    
    struct Relationships: Decodable {
        let questions: Questions
    }
    
    struct Questions: Decodable {
        let data: [QuestionsDetail]
    }
    
    struct QuestionsDetail: Decodable {
        let id: String
        let type: String
    }
}

extension SurveyDTO {
    func toSurvey() -> Survey {
        return Survey(id: id,
                      type: type,
                      attributes: attributes.toSurveyAttributes())
    }
}

extension SurveyDTO.Attributes {
    func toSurveyAttributes() -> Survey.Attributes {
        return Survey.Attributes(title: title,
                                 description: description,
                                 cover_image_url: cover_image_url)
    }
}
