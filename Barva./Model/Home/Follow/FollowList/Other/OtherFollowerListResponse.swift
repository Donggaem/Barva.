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
    var data: OtherFollower?
}

struct OtherFollower: Decodable {
    
    var otherFollowerResult: [OtherFollowerList]?
    var err: String?
}

struct OtherFollowerList: Decodable {
    
    var follower: OtherFollowerData
    var isMe: Bool?
    var isFollowing: Bool?
}

struct OtherFollowerData: Decodable {
    
    var user_name: String
    var user_nick: String
    var profile_url: String
    
}

