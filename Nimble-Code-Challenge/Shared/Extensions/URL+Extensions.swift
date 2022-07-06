//
//  URL+Extensions.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 06/07/2022.
//

import Foundation

extension URL {
    func toHighQualityImageURL() -> URL? {
        var path = absoluteString
        path.append("l")
        return URL(string: path)
    }
}
