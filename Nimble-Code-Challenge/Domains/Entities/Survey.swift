//
//  Survey.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 30/06/2022.
//

import Foundation

struct Survey {
    let id, type: String
    let attributes: Attributes
    
    struct Attributes {
        let title, description: String
        let cover_image_url: String
    }
}
