//
//  FollowerList.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/27.
//

import Foundation

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
