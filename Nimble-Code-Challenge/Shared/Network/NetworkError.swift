//
//  NetworkError.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import Foundation

indirect enum NetworkAPIError: Error {
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
    case noContent //204
    case timeout
    case noNetworkCollection
}
