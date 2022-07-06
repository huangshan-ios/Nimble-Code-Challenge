//
//  AppConstants.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

struct AppConstants {
    static var baseURL: String {
        let urlString = AppConfigurationHelper.shared.value(for: "SERVER_BASE_URL") ?? ""
        return urlString
    }
    
    static let clientSecret: String = AppConfigurationHelper.shared.value(for: "CLIENT_SECRET") ?? ""
    static let clientId: String = AppConfigurationHelper.shared.value(for: "CLIENT_ID") ?? ""
    
    struct URL {
        static let authen = "oauth/token"
        static let surveys = "surveys"
    }
    
}
