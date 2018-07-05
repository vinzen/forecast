//
//  APIManager.swift
//  Forecast
//
//  Created by Vincent Douant on 05/07/2018.
//  Copyright © 2018 Vincent Douant. All rights reserved.
//

import Foundation

enum APIManagerErrorDomain : String {
    case fetchWeather = "APIManager.fetchWeather"
}

enum APIManagerFetchWeatherErrorCode : Int {
    case noRequestState
    case genericError
    case emptyData
}

class APIManager {
    static let sharedInstance = APIManager()
    private let token = "ARtXQFUrUXNWe1ViAHZSewdvUmcNewcgAX1RMgtuUC0BalQ1B2dRN18xAXwEK1BmVnsBYgw3BzcHbFEpCnhUNQFrVztVPlE2VjlVMAAvUnkHKVIzDS0HIAFqUTQLeFAyAWBUNAd6UTpfMgF9BDZQZVZsAX4MLAc%2BB2FRNQpnVD8BYlcyVT5RMlY5VSgAL1JjB2ZSMQ1nBz0BN1E%2FC2RQNgFkVDMHN1EzXzkBfQQyUGRWZAFgDDMHOwdjUT4KeFQoARtXQFUrUXNWe1ViAHZSewdhUmwNZg%3D%3D"

    private init() {}

    func fetchWeather(successBlock: @escaping ([String: Any]) -> Void, errorBlock: ((Error?) -> Void)? = nil) {
        let url = URL(string: "http://www.infoclimat.fr/public-api/gfs/json?_ll=48.85341,2.3488&_auth=\(token)&_c=cfe4aea3bd030815d5365909bbf7e3c5")
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: url!) { (data, response, error) in
            guard let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data else {
                errorBlock?(error)
                return
            }
            do {
                if let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    if let requestState = dict["request_state"] as? Int {
                        if requestState == 200 {
                            successBlock(dict)
                        } else {
                            errorBlock?(self.newFetchWeatherError(code: .genericError))
                        }
                    } else {
                        errorBlock?(self.newFetchWeatherError(code: .noRequestState))
                    }
                }  else {
                    errorBlock?(self.newFetchWeatherError(code: .emptyData))
                }
            } catch let error {
                errorBlock?(error)
            }
        }
        task.resume()
    }

    private func newFetchWeatherError(code: APIManagerFetchWeatherErrorCode) -> Error {
        return NSError(domain: APIManagerErrorDomain.fetchWeather.rawValue, code: code.rawValue, userInfo: nil)
    }
}
