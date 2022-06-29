//
//  Credential.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 27/06/2022.
//

import Foundation

struct Credential {
    var id: String = ""
    var type: String = ""
    var attributes: Attributes = Attributes()
    
    struct Attributes {
        var accessToken: String = ""
        var tokenType: String = ""
        var expiresIn: Int = 0
        var refreshToken: String = ""
        var createdAt: Int = 0
    }
}
