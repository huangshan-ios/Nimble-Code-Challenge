//
//  CredentialDTO.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 27/06/2022.
//

import ObjectMapper

class CredentialDTO: Mappable {
    var id: String?
    var type: String?
    var attributes: Attributes?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        type <- map["id"]
        attributes <- map["attributes"]
    }
    
    class Attributes: Mappable {
        var accessToken: String?
        var tokenType: String?
        var expiresIn: Int?
        var refreshToken: String?
        var createdAt: Int?
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            accessToken <- map["access_token"]
            tokenType <- map["token_type"]
            expiresIn <- map["expires_in"]
            refreshToken <- map["refresh_token"]
            createdAt <- map["created_at"]
        }
    }
}

extension CredentialDTO {
    func toCredential() -> Credential {
        let credentialAttributes = attributes?.toCredentialAttributes() ?? Credential.Attributes()
        return Credential(id: id ?? "",
                          type: type ?? "",
                          attributes: credentialAttributes)
    }
}

extension CredentialDTO.Attributes {
    func toCredentialAttributes() -> Credential.Attributes {
        return Credential.Attributes(accessToken: accessToken ?? "",
                                     tokenType: tokenType ?? "",
                                     expiresIn: expiresIn ?? 0,
                                     refreshToken: refreshToken ?? "",
                                     createdAt: createdAt ?? 0)
    }
}
