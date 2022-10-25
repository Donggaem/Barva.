//
//  AddFollowingResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/26.
//

import Foundation

struct AddFollowingResponse: Decodable {
   
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: AddFollowingData?
}

struct AddFollowingData: Decodable {
    var err: String
}
