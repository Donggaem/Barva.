//
//  OthereUpImagesResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/18.
//

import Foundation

struct OthereUpImagesResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: OthereUpdata?
}

struct OthereUpdata: Decodable {
    
    var othereFeedInfo: [String]?
    
    var err: String?
}
