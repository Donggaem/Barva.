//
//  SavePostResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/23.
//

import Foundation

struct SavePostResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: SavePostData?
}

struct SavePostData: Decodable {
    var err: String
}
