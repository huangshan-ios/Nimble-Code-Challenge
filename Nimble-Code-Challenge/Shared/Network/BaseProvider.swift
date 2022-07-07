//
//  BaseProvider.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import Moya
import Alamofire
import RxSwift

private var apiSession: Session = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForResource = 30
    configuration.timeoutIntervalForRequest = 30
    let session = Session(configuration: configuration)
    return session
}()

class BaseProvider<API: TargetType>: MoyaProvider<API> {
    
    override func endpoint(_ token: API) -> Endpoint {
        let url = token.baseURL.absoluteString + token.path
        var headers = token.headers

        let credential = UserSession.shared.getCredential()
        if !credential.attributes.accessToken.isEmpty {
            let authorizationHeader = "\(credential.attributes.tokenType) \(credential.attributes.accessToken)"
            headers?["Authorization"] = authorizationHeader
        }
        
        return Endpoint(
            url: url,
            sampleResponseClosure: { .networkResponse(200, token.sampleData) },
            method: token.method,
            task: token.task,
            httpHeaderFields: headers
        )
    }
    
    convenience init(apiSession: Session = apiSession,
                     pluginsProvider: [PluginType] = []) {
        self.init(requestClosure: MoyaProvider<API>.defaultRequestMapping,
                  stubClosure: MoyaProvider.neverStub,
                  callbackQueue: nil,
                  session: apiSession,
                  plugins: pluginsProvider,
                  trackInflights: false)
    }
}
