//
//  APIErrorDTO.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 27/06/2022.
//

import Foundation

struct APIErrorDTO: Decodable {
    let errors: [APIErrorDetailDTO]
}

struct APIErrorDetailDTO: Decodable {
    let source: String?
    let detail: String
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case source
        case detail
        case code
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        source = try container.decodeIfPresent(String.self, forKey: .source)
        detail = try container.decode(String.self, forKey: .detail)
        code = try container.decode(String.self, forKey: .code)
    }
}
