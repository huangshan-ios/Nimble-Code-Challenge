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
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: token)
        if !defaultEndpoint.url.contains(AppConstants.URL.authen) {
            let credential = UserSession.shared.getCredential()
            if !credential.attributes.access_token.isEmpty {
                let authorizationHeader = "\(credential.attributes.token_type) \(credential.attributes.access_token)"
                return defaultEndpoint.adding(newHTTPHeaderFields: ["Authorization": authorizationHeader])
            }
        }
        return defaultEndpoint
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
