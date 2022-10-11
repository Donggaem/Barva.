//
//  StorageImagesResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/09.
//

import Foundation

struct StorageImagesResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: Storagedata?
}

struct Storagedata:Decodable {
    
    var StorageInfo: [String]?
    
    var err: String?
}


