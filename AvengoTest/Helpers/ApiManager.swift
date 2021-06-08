//
//  ApiManager.swift
//  AvengoTest
//
//  Created by Rostyslav Bodnar on 07.06.2021.
//

import Foundation
import Alamofire

final class ApiManager {
    class func sendGet<T: Decodable>(endPoint: String,
                                     queryItems: [URLQueryItem],
                                     parameters: Parameters? = nil,
                                     headers: HTTPHeaders? = nil,
                                     completion: ((Swift.Result<T, Error>) -> Void)?) {
        
        var urlComponetnts = URLComponents()
        urlComponetnts.scheme = "https"
        urlComponetnts.host = Constants.Url.baseUrl
        urlComponetnts.path = "/\(endPoint)"
        urlComponetnts.queryItems = queryItems
        urlComponetnts.queryItems?.append(.init(name: "app_key", value: Constants.Url.appKey))
        urlComponetnts.queryItems?.append(.init(name: "app_id", value: Constants.Url.appId))
        
        let urlString = urlComponetnts.url!.absoluteURL
        AF.request(urlString,
                   method: .get,
                   parameters: parameters,
                   headers: headers)
            .response { response in
                
                do {
                    guard let data = response.data else {
                        print(">>> Response is empty")
                        completion?(.failure(NSError(domain: "Empty response", code: 0, userInfo: nil)))
                        return
                    }
                    
                    let someResult = try JSONDecoder().decode(T.self, from: data)
                    print(someResult)
                    print("__________")
                    completion?(.success(someResult))
                    print(">>>> Response: \(String(describing: String(data: data, encoding: .utf8)))")
                    
                } catch {
                    if let data = response.data,
                       let error = try? JSONDecoder().decode(ErrorResponseModel.self, from: data) {
                        completion?(.failure(error))
                        
                    } else {
                        completion?(.failure(error))
                        print("Decodind error: \(error)")
                    }
                }
            }
    }
}
