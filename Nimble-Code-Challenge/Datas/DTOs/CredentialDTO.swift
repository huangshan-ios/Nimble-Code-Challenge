//
//  CredentialDTO.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 27/06/2022.
//

import Foundation

struct CredentialDTO: Decodable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let refreshToken: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case createdAt = "created_at"
    }
}

extension CredentialDTO {
    func toCredential() -> Credential {
        return Credential(accessToken: accessToken,
                          tokenType: tokenType,
                          expiresIn: expiresIn,
                          refreshToken: refreshToken,
                          createdAt: createdAt)
    }
}
