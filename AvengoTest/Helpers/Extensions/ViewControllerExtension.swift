//
//  ViewControllerExtension.swift
//  AvengoTest
//
//  Created by Rostyslav Bodnar on 07.06.2021.
//

import UIKit

extension UIViewController {
    
    func showErrorAlert(with error: Error?) {
        let errorMessage =
            (error as? ErrorResponseModel)?
            .localizedDescription ?? error?.localizedDescription ?? "No description"
        
        let alertVC = UIAlertController(title: "Oops",
                                        message: errorMessage,
                                        preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
}
