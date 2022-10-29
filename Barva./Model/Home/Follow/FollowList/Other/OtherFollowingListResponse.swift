//
//  OtherFollowingListResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/29.
//

import Foundation

struct OtherFollowingListResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: OtherFollowing?
}

struct OtherFollowing: Decodable {
    
    var otherFollowingResult: [OtherFollowingList]?
    var err: String?
}

struct OtherFollowingList: Decodable {
    
    var following: OtherFollowingData
    var isMe: Bool?
    var isFollowing: Bool?
}
struct OtherFollowingData: Decodable {
    
    var user_name: String
    var user_nick: String
    var profile_url: String
}

