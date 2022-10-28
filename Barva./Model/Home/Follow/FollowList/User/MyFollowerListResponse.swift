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
    
    var myFollower: [FollowerList]?
    var err: String?
}
