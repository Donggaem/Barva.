//
//  NewestSingleResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/22.
//

import Foundation

struct NewestSingleResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: NewestFeedData?
}

struct NewestFeedData: Decodable {
    
    var singleResult: [NewestFeedArray]?
    var err: String?
}

struct NewestFeedArray: Decodable {
    
    var post_content: String
    var likeCount: Int
    var user_gender: String
    var user_tall: String
    var user_weight: String
    var created_at: String
    var post_url: [String]
    var post_users: Newest_Data
    
}

struct Newest_Data: Decodable {
    
    var user_nick: String
    var profile_url: String
}

