//
//  AppError.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 27/06/2022.
//

import Foundation

enum AppError: Error {
    case somethingWentWrong
    case invalidGrant(String)
    case invalidClient(String)
    case unauthorizedClient(String)
    case incorrectPassword(String)
    case invalid(String)
    
    var message: String {
        switch self {
        case .somethingWentWrong:
            return "Something went wrong"
        case .invalidGrant(let message),
                .invalidClient(let message),
                .unauthorizedClient(let message),
                .incorrectPassword(let message),
                .invalid(let message):
            return message
        }
    }
}
