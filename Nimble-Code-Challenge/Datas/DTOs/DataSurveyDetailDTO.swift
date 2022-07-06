//
//  DataSurveyDetailDTO.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 01/07/2022.
//

import ObjectMapper

class DataSurveyDetailDTO: Mappable {
    var data: SurveyDetailDTO?
    var included: [IncludedDTO]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        data <- map["data"]
        included <- map["included"]
    }
}

class SurveyDetailDTO: Mappable {
    var id, type: String?
    var attributes: Attributes?
    var data: Relationships?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        type <- map["type"]
        attributes <- map["data"]
        data <- map["data"]
    }
    
    class Attributes: Mappable {
        var title, description: String?
        var thankEmailAboveThreshold: String?
        var thankEmailBelowThreshold: String?
        var isActive: Bool?
        var coverTmageUrl: String?
        var createdAt, activeAt: String?
        var inactiveAt: String?
        var surveyType: String?
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            title <- map["title"]
            description <- map["description"]
            thankEmailAboveThreshold <- map["thank_email_above_threshold"]
            thankEmailBelowThreshold <- map["thank_email_below_threshold"]
            isActive <- map["isActive"]
            coverTmageUrl <- map["cover_image_url"]
            createdAt <- map["created_at"]
            activeAt <- map["active_at"]
            inactiveAt <- map["inactive_at"]
            surveyType <- map["survey_type"]
        }
    }
    
    class Relationships: Mappable {
        var questions: Questions?
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            questions <- map["questions"]
        }
    }
    
    class Questions: Mappable {
        var data: [QuestionDataDetail]?
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            data <- map["data"]
        }
    }
    
    class QuestionDataDetail: Mappable {
        var id: String?
        var type: String?
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            id <- map["id"]
            type <- map["type"]
        }
    }
}

class IncludedDTO: Mappable {
    var id: String?
    var type: String?
    var attributes: Attributes?
    var relationships: Relationships?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        type <- map["type"]
        attributes <- map["id"]
        relationships <- map["type"]
    }
    
    class Attributes: Mappable {
        var text, helpText: String?
        var displayOrder: Int?
        var shortText: String?
        var pick: String?
        var displayType: String?
        var isMandatory: Bool?
        var correctAnswerID: String?
        var facebookProfile: String?
        var twitterProfile: String?
        var imageURL: String?
        var coverImageURL: String?
        var coverImageOpacity: Double?
        var coverBackgroundColor: String?
        var isShareableOnFacebook, isShareableOnTwitter: Bool?
        var fontFace, fontSize: String?
        var tagList: String?
        var inputMaskPlaceholder: String?
        var isCustomerFirstName, isCustomerLastName, isCustomerTitle, isCustomerEmail: Bool?
        var promptCustomAnswer: Bool?
        var weight: String?
        var inputMask: String?
        var dateConstraint, defaultValue: String?
        var responseClass: String?
        var referenceIdentifier: String?
        var score: Int?
        var alerts: [String]?
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            text <- map["text"]
            helpText <- map["help_text"]
            displayOrder <- map["display_order"]
            shortText <- map["short_text"]
            pick <- map["pick"]
            displayType <- map["display_type"]
            isMandatory <- map["is_mandatory"]
            correctAnswerID <- map["correct_answer_id"]
            facebookProfile <- map["facebook_profile"]
            twitterProfile <- map["twitter_profile"]
            imageURL <- map["image_url"]
            coverImageURL <- map["cover_image_url"]
            coverImageOpacity <- map["cover_image_opacity"]
            coverBackgroundColor <- map["cover_background_color"]
            isShareableOnFacebook <- map["is_shareable_on_facebook"]
            isShareableOnTwitter <- map["is_shareable_on_twitter"]
            fontFace <- map["font_face"]
            fontSize <- map["font_size"]
            tagList <- map["tag_list"]
            inputMaskPlaceholder <- map["input_mask_placeholder"]
            isCustomerFirstName <- map["is_customer_first_name"]
            isCustomerLastName <- map["is_customer_last_name"]
            isCustomerTitle <- map["is_customer_title"]
            isCustomerEmail <- map["is_customer_email"]
            promptCustomAnswer <- map["prompt_custom_answer"]
            weight <- map["weight"]
            inputMask <- map["input_mask"]
            dateConstraint <- map["date_constraint"]
            defaultValue <- map["default_value"]
            responseClass <- map["response_class"]
            referenceIdentifier <- map["reference_identifier"]
            score <- map["score"]
            alerts <- map["alerts"]
        }
    }
    
    class Relationships: Mappable {
        var answers: SurveyDetailDTO.Questions?
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            answers <- map["answers"]
        }
    }
}
