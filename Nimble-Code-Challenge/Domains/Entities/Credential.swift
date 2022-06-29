//
//  Credential.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 27/06/2022.
//

import Foundation

struct Credential: Encodable {
    var id: String = ""
    var type: String = ""
    var attributes: Attributes = Attributes()
    
    struct Attributes: Encodable {
        var access_token: String = ""
        var token_type: String = ""
        var expires_in: Int = 0
        var refresh_token: String = ""
        var created_at: Int = 0
    }
}

extension Credential {
    func toString() -> String {
        guard let data = try? JSONEncoder().encode(self) else {
            return ""
        }
        return String(data: data, encoding: .utf8) ?? ""
    }
}
