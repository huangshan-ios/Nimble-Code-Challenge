//
//  DataResponseDTO.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 27/06/2022.
//

import Foundation

struct DataResponseDTO<D: Decodable>: Decodable {
    let data: D
}