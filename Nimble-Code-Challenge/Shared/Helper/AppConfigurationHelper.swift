//
//  AppConfigurationHelper.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 01/07/2022.
//

import Foundation

final class AppConfigurationHelper {
    
    static let shared = AppConfigurationHelper(bundle: Bundle(for: AppConfigurationHelper.self))
    
    let bundle: Bundle
    
    init(bundle: Bundle) {
        self.bundle = bundle
    }
    
    func value<T>(for key: String) -> T? where T: LosslessStringConvertible {
        guard let value = bundle.object(forInfoDictionaryKey: key) else { return nil }
        switch value {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { return nil }
            return value
        default:
            return nil
        }
    }
}
