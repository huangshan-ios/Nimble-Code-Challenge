//
//  APIError.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 29/06/2022.
//

import Foundation

struct APIError {
    let errors: [APIErrorDetail]
}

struct APIErrorDetail: Decodable {
    let source: String?
    let detail: String
    let code: String
}
