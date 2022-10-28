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
    
    var otherFollowerList: [FollowerList]?
    var err: String?
}


