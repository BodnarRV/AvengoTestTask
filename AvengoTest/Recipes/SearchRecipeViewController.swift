//
//  ViewController.swift
//  AvengoTest
//
//  Created by Rostyslav Bodnar on 07.06.2021.
//

import UIKit

class SearchRecipeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak private var searchBar: UISearchBar!
    @IBOutlet weak private var tableView: UITableView!
    
    // MARK: - Private Properties
    private let debouncer = Debouncer.init(timeInterval: 0.3)
    private let service = Service.init()
    private var recipes: [ApiWrapperRecipeModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        let newsCell = UINib(nibName: "RecipeTableViewCell", bundle: nil)
        tableView.register(newsCell, forCellReuseIdentifier: "RecipeTableViewCell")
    }
}

extension SearchRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell",
                                                 for: indexPath) as! RecipeTableViewCell
        
        let model = recipes[indexPath.row].recipe
        
        cell.setRecipeNme(name: model.label)
        cell.setRecipeImage(from: model.image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetalizationViewController") as! DetalizationViewController
        vc.dataSource = .api(recipes[indexPath.row].recipe)
        
        self.present(vc, animated: true, completion: nil)
    }
}

extension SearchRecipeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        debouncer.renewInterval()
        
        debouncer.handler = {
            self.service.getRecipes(text: searchBar.text!) { [unowned self] result in
                switch result {
                case .success(let model):
                    self.recipes = model
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    self.showErrorAlert(with: error)
                }
            }
        }
    }
}
