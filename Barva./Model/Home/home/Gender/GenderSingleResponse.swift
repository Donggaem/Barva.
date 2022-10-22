//
//  GenderSingleResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/22.
//

import Foundation

struct GenderSingleResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: GenderFeedData?
}

struct GenderFeedData: Decodable {
    
    var singleResult: [GenderFeedArray]?
    var err: String?
}

struct GenderFeedArray: Decodable {
    
    var post_content: String
    var likeCount: Int
    var user_gender: String
    var user_tall: String
    var user_weight: String
    var created_at: String
    var post_url: [String]
    var post_users: Gender_Data
    
}

struct Gender_Data: Decodable {
    var user_nick: String
    var profile_url: String
}
