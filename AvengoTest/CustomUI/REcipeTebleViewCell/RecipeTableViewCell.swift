//
//  RecipeTableViewCell.swift
//  AvengoTest
//
//  Created by Rostyslav Bodnar on 07.06.2021.
//

import UIKit
import Alamofire
import AlamofireImage

class RecipeTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets

    @IBOutlet weak var backgroundContentView: UIView!
    @IBOutlet weak private var recipeImage: UIImageView!
    @IBOutlet weak private var recipeName: UILabel!
    
    // MARK: - Private Properties
    
    private var imageRequest: DataRequest?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundContentView.layer.cornerRadius = 16
        backgroundContentView?.layer.borderColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setRecipeImage(from url: String) {

       imageRequest = AF.request(url).responseImage { [unowned self] in
            if case .success(let image) = $0.result {
                self.recipeImage.image = image
            }
        }
    }

    override func prepareForReuse() {
        imageRequest?.cancel()
        recipeImage.image = nil
    }
    
    func setRecipeNme(name: String) {
        recipeName.text = name
    }
    
}
