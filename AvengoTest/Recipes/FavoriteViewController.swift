//
//  FavoriteViewController.swift
//  AvengoTest
//
//  Created by Rostyslav Bodnar on 07.06.2021.
//

import UIKit
import RealmSwift

class FavoriteViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak private var tableView: UITableView!
    
    private var dataSource = (try? Realm())?.objects(RecipeModel.self)
    private var dataSourceNotificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let newsCell = UINib(nibName: "RecipeTableViewCell", bundle: nil)
        tableView.register(newsCell, forCellReuseIdentifier: "RecipeTableViewCell")
        
        dataSourceNotificationToken = dataSource?.observe({ [weak self] result in
            self?.tableView.reloadData()
        })
    }
    
    deinit {
        dataSourceNotificationToken?.invalidate()
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell",
                                                 for: indexPath) as! RecipeTableViewCell
        
        let model = dataSource![indexPath.row]
        cell.setRecipeNme(name: model.label)
        cell.setRecipeImage(from: model.image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetalizationViewController") as! DetalizationViewController
        vc.dataSource = .db(dataSource![indexPath.row])
        
        self.present(vc, animated: true, completion: nil)
    }
}
