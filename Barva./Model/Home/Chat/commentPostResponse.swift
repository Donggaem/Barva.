//
//  commentPostResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/25.
//

import Foundation

struct commentPostResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: commentData?
}

struct commentData: Decodable {
    var err: String
}
