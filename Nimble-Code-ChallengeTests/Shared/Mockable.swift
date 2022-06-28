//
//  Mockable.swift
//  Nimble-Code-ChallengeTests
//
//  Created by Son Hoang on 27/06/2022.
//

import Foundation

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
            let decodedObject = try JSONDecoder().decode(type, from: data)

            return decodedObject
        } catch {
            fatalError("Failed to decode loaded JSON")
        }
    }
}
