//
//  CommentListResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/29.
//

import Foundation

struct CommentListResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message:String
    var data: CommentListData?
}

struct CommentListData: Decodable {
    
    var profile_url: String?
    var commentResult: [CommentResult]?
    var err: String?
}

struct CommentResult: Decodable {
    
    var comment: String
    var comment_users: CommentUserData
}

struct CommentUserData: Decodable {
    
    var user_nick: String
    var profile_url: String
}
