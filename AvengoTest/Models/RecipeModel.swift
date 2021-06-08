//
//  RecipeModel.swift
//  AvengoTest
//
//  Created by Rostyslav Bodnar on 07.06.2021.
//

import Foundation
import RealmSwift

final class RecipeModel: Object, Decodable {
    @objc dynamic var image: String = ""
    @objc dynamic var label: String = ""
    dynamic var calories: Float = 0
   
    @objc dynamic var carbsUnit: String = ""
    dynamic var carbsQuantity: Float = 0
    
    @objc dynamic var fatUnit: String = ""
    dynamic var fatQuantity: Float = 0
    
    @objc dynamic var proteinUnit: String = ""
    dynamic var proteinQuantity: Float = 0
    
    @objc dynamic var ingredientLines: String = ""
    
    override class func primaryKey() -> String? {
        "label"
    }
}

