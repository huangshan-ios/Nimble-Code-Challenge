//
//  DataSurveyDTO.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 30/06/2022.
//

import ObjectMapper

class DataSurveyDTO: Mappable {
    var data: [SurveyDTO]?
    var meta: MetaDTO?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        data <- map["data"]
        meta <- map["meta"]
    }
}

class SurveyDTO: Mappable {
    var id, type: String?
    var attributes: Attributes?
    var relationships: Relationships?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        type <- map["type"]
        attributes <- map["attributes"]
        relationships <- map["relationships"]
    }
    
    class Attributes: Mappable {
        var title, description: String?
        var thankEmailAboveThreshold: String?
        var thankEmailBelowThreshold: String?
        var isActive: Bool?
        var coverImageUrl: String?
        var createdAt, activeAt: String?
        var inactiveAt: String?
        var surveyType: String?
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            title <- map["title"]
            description <- map["description"]
            thankEmailAboveThreshold <- map["thank_email_above_threshold"]
            thankEmailBelowThreshold <- map["thank_email_below_threshold"]
            isActive <- map["is_active"]
            coverImageUrl <- map["cover_image_url"]
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
        var data: [QuestionsDetail]?
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            data <- map["data"]
        }
    }
    
    class QuestionsDetail: Mappable {
        var id: String?
        var type: String?
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            id <- map["id"]
            type <- map["type"]
        }
    }
}

class MetaDTO: Mappable {
    var page, pages, pageSize, records: Int?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        page <- map["page"]
        pages <- map["pages"]
        pageSize <- map["page_size"]
        records <- map["records"]
    }
}

extension DataSurveyDTO {
    func toDataSurvey() -> DataSurvey {
        let surveys = data?
            .compactMap({ surveyDTO in
                return surveyDTO.toSurvey()
            }) ?? []
        return DataSurvey(data: surveys,
                          meta: meta?.toMeta())
    }
}

extension MetaDTO {
    func toMeta() -> DataSurvey.Meta {
        return DataSurvey.Meta(page: page ?? 0,
                               pages: pages ?? 0,
                               pageSize: pageSize ?? 0,
                               records: records ?? 0)
    }
}

extension SurveyDTO {
    func toSurvey() -> Survey {
        let surveyAttributes = attributes?.toSurveyAttributes() ?? Survey.Attributes(title: "", description: "", coverImageUrl: "")
        return Survey(id: id ?? "",
                      type: type ?? "",
                      attributes: surveyAttributes)
    }
}

extension SurveyDTO.Attributes {
    func toSurveyAttributes() -> Survey.Attributes {
        return Survey.Attributes(title: title ?? "",
                                 description: description ?? "",
                                 coverImageUrl: coverImageUrl ?? "")
    }
}
