//
//  DataTypeMock.swift
//  Nimble-Code-ChallengeTests
//
//  Created by Son Hoang on 27/06/2022.
//

import Foundation

enum DataTypeMock {
    case json(String)
    case object(Decodable)
}

enum ErrorTypeMock: Error {
    case json(String)
    case error(Error)
}
