//
//  DetalizationViewController.swift
//  AvengoTest
//
//  Created by Rostyslav Bodnar on 07.06.2021.
//

import UIKit
import Alamofire
import AlamofireImage
import RealmSwift

class DetalizationViewController: UIViewController {
    
    enum DataSource {
        case api(ApiRecipeModel)
        case db(RecipeModel)
    }

    // MARK: - IBOutlets
    
    @IBOutlet weak private var recipeImage: UIImageView!
    @IBOutlet weak private var foodLabel: UILabel!
    
    @IBOutlet weak private var food: UILabel!
    @IBOutlet weak private var energyLabel: UILabel!
    
    @IBOutlet weak private var energy: UILabel!
    @IBOutlet weak private var proteinLabel: UILabel!
    
    @IBOutlet weak private var protein: UILabel!
    @IBOutlet weak private var fatLavel: UILabel!
    
    @IBOutlet weak private var fat: UILabel!
    @IBOutlet weak private var carbsLabel: UILabel!
    
    @IBOutlet weak private var carbs: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak private var ingridientsLabel: UILabel!
    @IBOutlet weak private var ingridients: UILabel!
    
    var dataSource: DataSource?
    
    // MARK: - Private Properties
    private var imageRequest: DataRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch dataSource {
        case .db(let model): self.setData(from: model)
        case .api(let model): self.setData(from: model)
        case .none: print("Data doesn't set")
        }
        
        favoriteButton.addTarget(self, action: #selector(favAction), for: .touchUpInside)
    }
    
    private func setData(from model: ApiRecipeModel) {
        food.text = model.label
        energy.text = "\(model.calories)"
        protein.text = "\(model.totalDaily.protein.quantity) \(model.totalDaily.protein.unit)"
        fat.text = "\(model.totalDaily.fat.quantity) \(model.totalDaily.fat.unit)"
        carbs.text = "\(model.totalDaily.carbs.quantity) \(model.totalDaily.protein.unit)"
        ingridients.text = model.ingredientLines.joined(separator: "\n")
        
        imageRequest = AF.request(model.image).responseImage { [unowned self] in
             if case .success(let image) = $0.result {
                 self.recipeImage.image = image
             }
         }
        
        try? self.updateFavButton(by: model.label)
    }
    
    private func setData(from model: RecipeModel) {
        food.text = model.label
        energy.text = "\(model.calories)"
        protein.text = "\(model.proteinQuantity) \(model.proteinUnit)"
        fat.text = "\(model.fatQuantity) \(model.fatUnit)"
        carbs.text = "\(model.carbsQuantity) \(model.carbsUnit)"
        ingridients.text = model.ingredientLines
        
        imageRequest = AF.request(model.image).responseImage { [unowned self] in
            if case .success(let image) = $0.result {
                self.recipeImage.image = image
            }
        }
        
        try? self.updateFavButton(by: model.label)
    }
    
    @objc private func favAction() {
        switch dataSource {
        case .db(let model): self.removeFromFavorite(modelLabel: model.label)
        case .api(let model): self.addToFavorite(model)
        case .none: print("Data doesn't set")
        }
    }
    
    private func addToFavorite(_ model: ApiRecipeModel) {
        let dbModel = RecipeModel()
        dbModel.image = model.image
        dbModel.label = model.label
        dbModel.calories = model.calories
        dbModel.ingredientLines = model.ingredientLines.joined(separator: "\n")
        
        dbModel.carbsUnit = model.totalDaily.carbs.unit
        dbModel.carbsQuantity = model.totalDaily.carbs.quantity
        
        dbModel.fatUnit = model.totalDaily.fat.unit
        dbModel.fatQuantity = model.totalDaily.fat.quantity
        
        dbModel.proteinUnit = model.totalDaily.protein.unit
        dbModel.proteinQuantity = model.totalDaily.protein.quantity
        
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.add(dbModel, update: .modified)
            }
            
            try self.updateFavButton(by: model.label)
        
        } catch {
            print(error)
        }
    }
    
    private func removeFromFavorite(modelLabel: String) {
        do {
            let realm = try Realm()
            
            try realm.write {
                let model = realm.object(ofType: RecipeModel.self, forPrimaryKey: modelLabel)
                realm.delete(model!)
            }
            
            try self.updateFavButton(by: modelLabel)
        
        } catch {
            print(error)
        }
    }
    
    private func updateFavButton(by modelLabel: String) throws {
        let realm = try Realm()
        
        if let _ = realm.object(ofType: RecipeModel.self, forPrimaryKey: modelLabel) {
            favoriteButton.setTitle("Remove from favorite", for: .normal)
            
        } else {
            favoriteButton.setTitle("Add to favorite", for: .normal)
        }
    }
}
