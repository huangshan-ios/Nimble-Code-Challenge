//
//  APIErrorDTO.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 27/06/2022.
//

import ObjectMapper

class APIErrorDTO: Error, Mappable {
    static let somethingWentWrong = APIErrorDTO(errors: [APIErrorDetail.somethingWentWrong])
    
    var httpStatusCode: Int?
    var errors: [APIErrorDetail]?
    
    init(errors: [APIErrorDetail]) {
        self.errors = errors
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        errors <- map["errors"]
    }
    
    class APIErrorDetail: Mappable {
        static let somethingWentWrong = APIErrorDetail(source: "local",
                                                       detail: "Something went wrong",
                                                       code: "something_went_wrong")
        
        var source: String?
        var detail: String?
        var code: String?
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            source <- map["source"]
            detail <- map["detail"]
            code <- map["code"]
        }
        
        init(source: String, detail: String, code: String) {
            self.source = source
            self.detail = detail
            self.code = code
        }
    }
}
