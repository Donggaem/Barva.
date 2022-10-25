//
//  CancelFollowingResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/26.
//

import Foundation

struct CancelFollowingResponse: Decodable {
   
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: CancelFollowingData?
}

struct CancelFollowingData: Decodable {
    var err: String
}
