//
//  GetFeedResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/20.
//

import Foundation

struct UserSingleResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: UserFeedData?
}

struct UserFeedData: Decodable {
    
    var singleResult: [FeedArray]?
    var err: String?
}

