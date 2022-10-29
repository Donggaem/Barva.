//
//  commentPostResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/25.
//

import Foundation

struct CommentPostResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: CommentPostData?
}

struct CommentPostData: Decodable {
    var err: String
}
