//
//  HandleResponse+Extensions.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 29/06/2022.
//

import Moya
import RxSwift
import JSONAPIMapper

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func handleResponse() -> Single<Element> {
        return flatMap { response in
            
            if let credentialDTO = try? JSONAPIDecoder().decode(CredentialDTO.self, from: response.data) {
                UserSession.shared.setCredential(credentialDTO.toCredential())
            }
            
            if (200 ... 299) ~= response.statusCode {
                return .just(response)
            }
            
            do {
                let _ = try JSONAPIDecoder().decode(JSONAPIObject.self, from: response.data)
            } catch let error {
                if let errors = error as? [JSONAPIError], let error = errors.first {
                    let apiError = APIError(statusCode: response.statusCode,
                                            detail: error.detail ?? "",
                                            code: error.code ?? "")
                    return .error(apiError)
                }
            }
            
            return .error(APIError.somethingWentWrong)
        }
    }
}
