//
//  HandleResponse+Extensions.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 29/06/2022.
//

import Moya
import RxSwift

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func handleResponse() -> Single<Element> {
        return flatMap { response in
            if let credential = try? response.map(CredentialDTO.self) {
                UserSession.shared.setCredential(credential.toCredentials())
            }
            
            if (200 ... 299) ~= response.statusCode {
                return .just(response)
            }
            
            if var error = try? response.map(APIErrorDTO.self) {
                error.httpStatusCode = response.statusCode
                return .error(error)
            }
            
            return .error(APIErrorDTO.somethingWentWrong)
        }
    }
}
