//
//  Error+Extensions.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 27/06/2022.
//

import Foundation

extension Error {
    func mapToAppError() -> AppError {
        guard let error = self as? NetworkAPIError else {
            return .somethingWentWrong
        }
        
        switch error {
        case .invalidRequest(let errorDTO),
                .unauthorized(error: let errorDTO),
                .accessDenied(error: let errorDTO):
            
            let code = errorDTO?.errors.first?.code ?? ""
            let detail = errorDTO?.errors.first?.detail ?? ""
            
            switch code {
            case "invalid_email_or_password":
                return .incorrectPassword(detail)
            case "invalid_grant":
                return .invalidGrant(detail)
            case "unauthorized_client" :
                return .unauthorizedClient(detail)
            case "invalid_client":
                return .invalidClient(detail)
            default:
                return .somethingWentWrong
            }
        case .validate(error: let errorDTO):
            return .invalid(errorDTO?.errors.first?.detail ?? "")
        default:
            return .somethingWentWrong
        }
    }
}
