//
//  NetworkError.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import Foundation

enum NetworkAPIError: Error {
    case noStatusCode
    case invalidData(data: Any?)
    case unknown
    case invalidRequest(error: APIErrorDTO? = nil) // 400
    case unauthorized(error: APIErrorDTO? = nil) // 401
    case accessDenied(error: APIErrorDTO? = nil) // 403
    case notFound  // 404
    case validate(error: APIErrorDTO? = nil) // 422
    case serverError // 500
    case badGateway // 502
    case serviceUnavailable // 503
    case gatewayTimeout // 504
    case noContent // 204
    case timeout
    case noNetworkCollection
    
    // swiftlint:disable cyclomatic_complexity
    static func getError(from code: Int, data: Data? = nil) -> NetworkAPIError {
        
        var response: APIErrorDTO?
        do {
            if let data = data {
                response = try JSONDecoder().decode(APIErrorDTO.self, from: data)
            }
        } catch {
            response = nil
        }
        
        switch code {
        case 400:
            return .invalidRequest(error: response)
        case 401:
            return .unauthorized(error: response)
        case 403:
            return .accessDenied(error: response)
        case 404:
            return .notFound
        case 422:
            return .validate(error: response)
        case 500:
            return .serverError
        case 502:
            return .badGateway
        case 503:
            return .serviceUnavailable
        case 504:
            return .gatewayTimeout
        default:
            return .unknown
        }
    }
    // swiftlint:enable cyclomatic_complexity
}
