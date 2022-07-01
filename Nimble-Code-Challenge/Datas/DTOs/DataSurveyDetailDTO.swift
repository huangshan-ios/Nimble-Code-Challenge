//
//  DataSurveyDetailDTO.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 01/07/2022.
//

import Foundation

struct DataSurveyDetailDTO: Decodable {
    let data: SurveyDetailDTO
    let included: [IncludedDTO]
}

struct SurveyDetailDTO: Decodable {
    let id, type: String
    let attributes: Attributes
    let relationships: Relationships
    
    struct Attributes: Decodable {
        let title, description: String
        let thank_email_above_threshold: String?
        let thank_email_below_threshold: String?
        let isActive: Bool
        let cover_image_url: String
        let created_at, active_at: String
        let inactive_at: String??
        let survey_type: String
    }
    
    struct Relationships: Decodable {
        let questions: Questions
    }
    
    struct Questions: Decodable {
        let data: [QuestionDataDetail]
    }
    
    struct QuestionDataDetail: Decodable {
        let id: String
        let type: String
    }
}

struct IncludedDTO: Decodable {
    let id: String
    let type: String
    let attributes: Attributes
    let relationships: Relationships?
    
    struct Attributes: Codable {
        let text, helpText: String?
        let displayOrder: Int
        let shortText: String
        let pick: String?
        let displayType: String
        let isMandatory: Bool
        let correctAnswerID: String?
        let facebookProfile: String?
        let twitterProfile: String?
        let imageURL: String?
        let coverImageURL: String?
        let coverImageOpacity: Double?
        let coverBackgroundColor: String?
        let isShareableOnFacebook, isShareableOnTwitter: Bool?
        let fontFace, fontSize: String?
        let tagList: String?
        let inputMaskPlaceholder: String?
        let isCustomerFirstName, isCustomerLastName, isCustomerTitle, isCustomerEmail: Bool?
        let promptCustomAnswer: Bool?
        let weight: String?
        let inputMask: String?
        let dateConstraint, defaultValue: String?
        let responseClass: String?
        let referenceIdentifier: String?
        let score: Int?
        let alerts: [String]?
        
        enum CodingKeys: String, CodingKey {
            case text
            case helpText = "help_text"
            case displayOrder = "display_order"
            case shortText = "short_text"
            case pick
            case displayType = "display_type"
            case isMandatory = "is_mandatory"
            case correctAnswerID = "correct_answer_id"
            case facebookProfile = "facebook_profile"
            case twitterProfile = "twitter_profile"
            case imageURL = "image_url"
            case coverImageURL = "cover_image_url"
            case coverImageOpacity = "cover_image_opacity"
            case coverBackgroundColor = "cover_background_color"
            case isShareableOnFacebook = "is_shareable_on_facebook"
            case isShareableOnTwitter = "is_shareable_on_twitter"
            case fontFace = "font_face"
            case fontSize = "font_size"
            case tagList = "tag_list"
            case inputMaskPlaceholder = "input_mask_placeholder"
            case isCustomerFirstName = "is_customer_first_name"
            case isCustomerLastName = "is_customer_last_name"
            case isCustomerTitle = "is_customer_title"
            case isCustomerEmail = "is_customer_email"
            case promptCustomAnswer = "prompt_custom_answer"
            case weight
            case inputMask = "input_mask"
            case dateConstraint = "date_constraint"
            case defaultValue = "default_value"
            case responseClass = "response_class"
            case referenceIdentifier = "reference_identifier"
            case score, alerts
        }
    }
    
    struct Relationships: Decodable {
        let answers: SurveyDetailDTO.Questions
    }
}
