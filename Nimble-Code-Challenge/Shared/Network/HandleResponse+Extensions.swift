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
            if let jsonString = String(data: response.data, encoding: .utf8),
               let responseDTO = DataResponseDTO<CredentialDTO>(JSONString: jsonString),
               let credential = responseDTO.data?.toCredential() {
                UserSession.shared.setCredential(credential)
            }
            
            if (200 ... 299) ~= response.statusCode {
                return .just(response)
            }
            
            if let jsonString = String(data: response.data, encoding: .utf8),
               let error = APIErrorDTO(JSONString: jsonString) {
                error.httpStatusCode = response.statusCode
                return .error(error)
            }
            
            return .error(APIErrorDTO.somethingWentWrong)
        }
    }
}
