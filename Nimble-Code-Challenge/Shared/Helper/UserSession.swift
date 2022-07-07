//
//  UserSession.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 27/06/2022.
//

import Foundation

final class UserSession {
    static let shared = UserSession()
    
    private let keychainHelper = KeychainHelper(service: KeychainConfiguration.serviceName,
                                                account: KeychainConfiguration.credentials)
    private var credential: Credential = Credential()
    
    var isLoggedIn: Bool {
        return !getCredential().attributes.access_token.isEmpty
    }

}

// MARK: - Credential
extension UserSession {
    func resetCredential() {
        credential = Credential()
        try? keychainHelper.deleteItem()
    }
    
    func getCredential() -> Credential {
        guard
            let keychainData = try? keychainHelper.readPassword(),
            let data = keychainData.data(using: .utf8)
        else {
            return credential
        }
        
        let credentialDTO = try? JSONDecoder().decode(CredentialDTO.self, from: data)
        credential = credentialDTO?.toCredential() ?? Credential()
        
        return credential
    }
    
    func setCredential(_ credential: Credential) {
        self.credential = credential
        try? keychainHelper.savePassword(credential.toString())
    }
}
