//
//  MyFollowingListResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/29.
//

import Foundation

struct MyFollowingListResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: MyFollowing?
}

struct MyFollowing: Decodable {
    
    var myFollowingResult: [MyFollowingList]?
    var err: String?
}

struct MyFollowingList: Decodable {
    
    var following: MyFollowingData
    var isFollowing: Bool
}
struct MyFollowingData: Decodable {
    
    var user_name: String
    var user_nick: String
    var profile_url: String
}
