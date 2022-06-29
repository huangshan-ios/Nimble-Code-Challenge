//
//  CredentialDTO.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 27/06/2022.
//

import Foundation

struct CredentialDTO: Decodable {
    let id: String
    let type: String
    let attributes: Attributes
    
    struct Attributes: Decodable {
        let access_token: String
        let token_type: String
        let expires_in: Int
        let refresh_token: String
        let created_at: Int
    }
}

extension CredentialDTO {
    func toCredential() -> Credential {
        return Credential(id: id,
                          type: type,
                          attributes: attributes.toCredentialAttributes())
    }
}

extension CredentialDTO.Attributes {
    func toCredentialAttributes() -> Credential.Attributes {
        return Credential.Attributes(access_token: access_token,
                                     token_type: token_type,
                                     expires_in: expires_in,
                                     refresh_token: refresh_token,
                                     created_at: created_at)
    }
}
