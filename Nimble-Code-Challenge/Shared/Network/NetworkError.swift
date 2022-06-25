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
    case unknown(statusCode: Int?, data: Any?)
    case notModified // 304
    case invalidRequest(data: Any? = nil) // 400
    case unauthorized // 401
    case accessDenied // 403
    case notFound  // 404
    case methodNotAllowed  // 405
    case validate   // 422
    case serverError // 500
    case badGateway // 502
    case serviceUnavailable // 503
    case gatewayTimeout // 504
    case noContent // 204
    case timeout
    case noNetworkCollection
    
    // swiftlint:disable cyclomatic_complexity
    static func getError(from code: Int, data: Any? = nil) -> NetworkAPIError {
        switch code {
        case 304:
            return .notModified
        case 401:
            return .unauthorized
        case 403:
            return .accessDenied
        case 404:
            return .notFound
        case 405:
            return .methodNotAllowed
        case 422:
            return .validate
        case 500:
            return .serverError
        case 502:
            return .badGateway
        case 503:
            return .serviceUnavailable
        case 504:
            return .gatewayTimeout
        default:
            return .unknown(statusCode: code, data: data)
        }
    }
    // swiftlint:enable cyclomatic_complexity
}
