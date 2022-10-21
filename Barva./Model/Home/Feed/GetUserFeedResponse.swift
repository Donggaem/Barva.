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
    var data: FeedData?
}

struct FeedData: Decodable {
    
    var singleResult: [FeedArray]?
    var err: String?
}

struct FeedArray: Decodable {
    
    var post_content: String
    var likeCount: Int
    var user_gender: String
    var user_tall: String
    var created_at: String
    var post_url: [String]
    
}
