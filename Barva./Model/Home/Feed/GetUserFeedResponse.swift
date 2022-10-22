//
//  GetFeedResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/20.
//

import Foundation

struct GetUserFeedResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: UserFeedData?
}

struct UserFeedData: Decodable {
    
    var singleResult: [UserFeedArray]?
    var err: String?
}

struct UserFeedArray: Decodable {
    
    var post_content: String
    var likeCount: Int
    var user_gender: String
    var user_tall: String
    var user_weight: String
    var created_at: String
    var post_url: [String]
    var post_users: User_Data
    
}

struct User_Data: Decodable {
    var user_nick: String
    var profile_url: String
}
