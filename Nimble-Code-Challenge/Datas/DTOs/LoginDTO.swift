//
//  LoginDTO.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 27/06/2022.
//

import Foundation

struct LoginDTO: Decodable {
    let id: String
    let type: String
    let attributes: LoginAttributesDTO
}

struct LoginAttributesDTO: Decodable {
    let access_token: String
    let token_type: String
    let expires_in: Int
    let refresh_token: String
    let created_at: Int
}
