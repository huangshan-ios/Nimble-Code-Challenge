//
//  DataSurvey.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 06/07/2022.
//

import Foundation

struct DataSurvey {
    let data: [Survey]
    let meta: Meta?
    
    struct Meta {
        let page, pages, page_size, records: Int
    }
    
}
