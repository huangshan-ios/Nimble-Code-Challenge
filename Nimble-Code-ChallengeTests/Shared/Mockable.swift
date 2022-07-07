//
//  Mockable.swift
//  Nimble-Code-ChallengeTests
//
//  Created by Son Hoang on 27/06/2022.
//

import Foundation
import JSONAPIMapper

@testable import Nimble_Code_Challenge

protocol Mockable: AnyObject {
    associatedtype MockType
    
    var bundle: Bundle { get }
    var listMock: [MockType] { get }
    
    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> T
}

extension Mockable {
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }

    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> T {
        guard let path = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to load JSON")
        }

        do {
            let data = try Data(contentsOf: path)
            let decodedObject = try JSONAPIDecoder().decode(type, from: data)

            return decodedObject
        } catch {
            fatalError("Failed to decode loaded JSON")
        }
    }
    
    func loadJSON<T: Decodable, M: Decodable>(filename: String, type: T.Type, metaType: M.Type) -> (T, M) {
        guard let path = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to load JSON")
        }

        do {
            let data = try Data(contentsOf: path)
            let decodedObject = try JSONAPIDecoder().decodeWithMeta(value: type, meta: metaType, from: data)

            return decodedObject
        } catch {
            fatalError("Failed to decode loaded JSON")
        }
    }
    
    func loadError(filename: String) throws -> JSONAPIObject {
        guard let path = bundle.url(forResource: filename, withExtension: "json") else {
            throw APIError.somethingWentWrong
        }

        do {
            let data = try Data(contentsOf: path)
            let decodedObject = try JSONAPIDecoder().decode(JSONAPIObject.self, from: data)

            return decodedObject
        } catch let error {
            if let errors = error as? [JSONAPIError], let error = errors.first {
                throw APIError(statusCode: -1,
                               detail: error.detail ?? "",
                               code: error.code ?? "")
            }
            throw error
        }
    }
}
