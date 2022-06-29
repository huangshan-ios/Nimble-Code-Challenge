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
    convenience init(apiSession: Session = apiSession,
                     pluginsProvider: [PluginType] = [NetworkLoggerPlugin()]) {
        self.init(endpointClosure: MoyaProvider.defaultEndpointMapping,
                  requestClosure: MoyaProvider<API>.defaultRequestMapping,
                  stubClosure: MoyaProvider.neverStub,
                  callbackQueue: nil,
                  session: apiSession,
                  plugins: pluginsProvider,
                  trackInflights: false)
    }
}
