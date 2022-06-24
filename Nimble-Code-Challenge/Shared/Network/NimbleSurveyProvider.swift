//
//  NimbleSurveyProvider.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import Moya
import Alamofire
import RxSwift

private let pluginsProvider = [NetworkLoggerPlugin()]
private var apiSession: Session = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForResource = 30
    configuration.timeoutIntervalForRequest = 30
    let session = Session(configuration: configuration)
    return session
}()

let nimbleSurveyProvider = NimbleSurveyProvider<NimbleSurveyAPI>()

class NimbleSurveyProvider<NimbleSurveyAPI>: MoyaProvider<NimbleSurveyAPI> where NimbleSurveyAPI: TargetType {
    convenience init(apiSession: Session = apiSession,
                     pluginsProvider: [PluginType] = pluginsProvider) {
        self.init(endpointClosure: MoyaProvider.defaultEndpointMapping,
                  requestClosure: MoyaProvider<NimbleSurveyAPI>.defaultRequestMapping,
                  stubClosure: MoyaProvider.neverStub,
                  callbackQueue: nil,
                  session: apiSession,
                  plugins: pluginsProvider,
                  trackInflights: false)
    }
}
