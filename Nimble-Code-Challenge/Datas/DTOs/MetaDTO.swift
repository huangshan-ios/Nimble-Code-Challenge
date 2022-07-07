//
//  MetaDTO.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 07/07/2022.
//

import Foundation

struct MetaDTO: Decodable {
    let page, pages, pageSize, records: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case pages
        case pageSize = "page_size"
        case records
    }
}

extension MetaDTO {
    func toMeta() -> DataSurvey.Meta {
        return DataSurvey.Meta(page: page,
                               pages: pages,
                               pageSize: pageSize,
                               records: records)
    }
}
