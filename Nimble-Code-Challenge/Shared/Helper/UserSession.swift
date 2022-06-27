//
//  UserSession.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 27/06/2022.
//

import Foundation

final class UserSession {
    static let shared = UserSession()
    
    private var credential: Credential = Credential()

}

// MARK: - Credential
extension UserSession {
    func resetCredential() {
        credential = Credential()
    }
    
    func getCredential() -> Credential {
        return credential
    }
    
    func setCredential(_ credential: Credential) {
        self.credential = credential
    }
}
