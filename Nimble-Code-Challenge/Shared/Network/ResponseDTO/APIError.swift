//
//  APIError.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 27/06/2022.
//

import Foundation

struct APIError: Error {
    static let somethingWentWrong = APIError(statusCode: -1,
                                             detail: "Something went wrong",
                                             code: "something_went_wrong")
    var httpStatusCode: Int?
    let detail: String
    let code: String
    
    init(statusCode: Int, detail: String, code: String) {
        self.httpStatusCode = statusCode
        self.detail = detail
        self.code = code
    }
}
