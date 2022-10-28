//
//  OtherProfileResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/26.
//

import Foundation

struct OtherProfileResponse:Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: OtherProfileInfo?
}

struct OtherProfileInfo: Decodable {
    
    var otherProfileInfo: OtherProfileData?
    var err: String?
}

struct OtherProfileData: Decodable {
    
    var user_name: String
    var user_nick: String
    var profile_url: String
    var user_introduce: String
    var countPost: Int
    var countFollower: Int
    var countFollowing: Int
    var isFollowing: Bool
}
