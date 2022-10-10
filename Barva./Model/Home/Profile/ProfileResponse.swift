//
//  ProfileResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/09.
//

import Foundation

struct ProfileResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: ProfileInfo?
    
}

struct ProfileInfo: Decodable {
    
    var myProfileInfo: Userdata?
    var err: String?
}

struct Userdata: Decodable {
    var user_nick: String?
    var profile_url: String?
    var user_introduce: String?
}
