//
//  OtherFollowerListResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/27.
//

import Foundation

struct OtherFollowerListResponse:Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: OtherFollowerList?
}

struct OtherFollowerList: Decodable {
    
    var otherFollowerList: [FollowerList]?
    var err: String?
}

struct FollowerList: Decodable {
    
    var follower: FollowerData
    var isMe: Bool?
    var isFollowing: Bool?
}

struct FollowerData: Decodable {
    
    var user_name: String
    var user_nick: String
    var profile_url: String
    
}