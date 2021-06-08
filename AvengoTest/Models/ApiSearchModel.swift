//
//  ApiSearchModel.swift
//  AvengoTest
//
//  Created by Rostyslav Bodnar on 07.06.2021.
//

import Foundation

struct ApiSearchModel: Decodable {
    let hits: [ApiWrapperRecipeModel]
}

struct ApiWrapperRecipeModel: Decodable {
    let recipe: ApiRecipeModel
}

struct ApiRecipeModel: Decodable {
    let image: String
    let label: String
    let calories: Float
    let totalDaily: ApiTotalDailyModel
    let ingredientLines: [String]
}

struct ApiTotalDailyModel: Decodable {
    let carbs: ApiDishDetailModel
    let fat: ApiDishDetailModel
    let protein: ApiDishDetailModel
    
    enum CodingKeys: String, CodingKey {
        case carbs = "CHOCDF"
        case fat = "FAT"
        case protein = "PROCNT"
    }
}

struct ApiDishDetailModel: Decodable {
    let quantity: Float
    let unit: String
}
