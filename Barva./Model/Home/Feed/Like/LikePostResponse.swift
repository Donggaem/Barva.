//
//  LikePostResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/29.
//

import Foundation

struct LikePostResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: LikePostData?
}

struct LikePostData: Decodable {
    
    var likeCount: Int?
    var err: String?
}
