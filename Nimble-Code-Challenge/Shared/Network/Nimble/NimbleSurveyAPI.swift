//
//  NimbleSurveyAPI.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import Foundation

enum NimbleSurveyAPI {
    case login(String, String)
    case surveys(Int, Int)
    case surveyDetail(String)
}
