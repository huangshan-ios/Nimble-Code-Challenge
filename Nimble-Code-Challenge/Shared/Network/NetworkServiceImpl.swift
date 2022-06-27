//
//  NetworkServiceImpl.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import RxSwift
import Moya

class NetworkServiceImpl: NetworkService {
    func request<T>(_ token: NimbleSurveyAPI) -> Single<Result<T, Error>> where T: Decodable {
        return nimbleSurveyProvider.rx.request(token)
            .map({ response in
                switch response.statusCode {
                case 200...299:
                    do {
                        let dtoResponse = try JSONDecoder().decode(DataResponseDTO<T>.self, from: response.data)
                        return .success(dtoResponse.data)
                    } catch {
                        return .failure(NetworkAPIError.unknown)
                    }
                default:
                    return .failure(NetworkAPIError.getError(from: response.statusCode, data: response.data))
                }
            })
        
    }
}
