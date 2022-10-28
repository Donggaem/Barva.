//
//  MyFollowerList.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/27.
//

import Foundation

struct MyFollowerListResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: MyFollower?
}

struct MyFollower: Decodable {
    
    var myFollower: [MyFollowerList]?
    var err: String?
}

struct MyFollowerList: Decodable {
    
    var follower: MyFollowerData
    var isFollowing: Bool
}

struct MyFollowerData: Decodable {
    
    var user_name: String
    var user_nick: String
    var profile_url: String
    
}
