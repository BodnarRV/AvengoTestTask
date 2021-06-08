//
//  ErrorResponseModel.swift
//  AvengoTest
//
//  Created by Rostyslav Bodnar on 07.06.2021.
//

import Foundation

struct ErrorResponseModel: Decodable, Error {
    let status: String
    let message: String
    
    var localizedDescription: String {
        message
    }
}
