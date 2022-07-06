//
//  DataResponseDTO.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 27/06/2022.
//

import ObjectMapper

class DataResponseDTO<D: Mappable>: Mappable {
    var data: D?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        data <- map["data"]
    }
}
