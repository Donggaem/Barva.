//
//  MyUpImagesResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/09.
//

import Foundation

struct MyUpImagesResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: MyUpdata?
}

struct MyUpdata:Decodable {
    
    var myFeedInfo: [String]?
    
    var err: String?
}
