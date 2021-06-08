//
//  Service.swift
//  AvengoTest
//
//  Created by Rostyslav Bodnar on 07.06.2021.
//

import Foundation
import Alamofire

class Service {
    func getRecipes(text: String,
                    completion: @escaping ((Result<[ApiWrapperRecipeModel], Error>) -> Void)) {
        
        let endPoint = "search"
        let query = [
            URLQueryItem(name: "q", value: text),
        ]
        
        ApiManager.sendGet(endPoint: endPoint,
                           queryItems: query,
                           headers: nil) { (result: Result<ApiSearchModel, Error>) in
            switch result {
            case .success(let model):
                completion(.success(model.hits))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
