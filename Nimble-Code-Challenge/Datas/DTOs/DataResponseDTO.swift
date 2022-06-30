//
//  DataResponseDTO.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 27/06/2022.
//

import Foundation

struct DataResponseDTO<D: Decodable>: Decodable {
    let data: D
    let meta: MetaDTO?
    
    enum CodingKeys: String, CodingKey {
        case data
        case meta
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(D.self, forKey: .data)
        meta = try container.decodeIfPresent(MetaDTO.self, forKey: .meta)
    }
    
    init(data: D, meta: MetaDTO?) {
        self.data = data
        self.meta = meta
    }
    
    struct MetaDTO: Decodable {
        let page, pages, page_size, records: Int
    }
}

extension DataResponseDTO.MetaDTO {
    func toResponseMeta() -> ResponseMeta {
        return ResponseMeta(page: page,
                            pages: pages,
                            page_size: page_size,
                            records: records)
    }
}
