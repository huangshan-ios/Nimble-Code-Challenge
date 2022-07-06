//
//  DataSurveyDTO.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 30/06/2022.
//

import Foundation

struct DataSurveyDTO: Decodable {
    let data: [SurveyDTO]
    let meta: MetaDTO
    
    enum CodingKeys: String, CodingKey {
        case data
        case meta
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([SurveyDTO].self, forKey: .data)
        meta = try container.decode(MetaDTO.self, forKey: .meta)
    }
    
    init(data: [SurveyDTO], meta: MetaDTO) {
        self.data = data
        self.meta = meta
    }
}

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

struct MetaDTO: Decodable {
    let page, pages, page_size, records: Int
}

extension DataSurveyDTO {
    func toDataSurvey() -> DataSurvey {
        return DataSurvey(data: data.map { $0.toSurvey() },
                          meta: meta.toMeta())
    }
}

extension MetaDTO {
    func toMeta() -> DataSurvey.Meta {
        return DataSurvey.Meta(page: page,
                               pages: pages,
                               page_size: page_size,
                               records: records)
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
