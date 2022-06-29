//
//  Error+Extensions.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 29/06/2022.
//

import Foundation

extension Error {
    func toAPIError() -> APIError {
        guard let apiErrorDTO = self as? APIErrorDTO else {
            return  APIErrorDTO.somethingWentWrong.toAPIError()
        }
        
        return apiErrorDTO.toAPIError()
    }
}
