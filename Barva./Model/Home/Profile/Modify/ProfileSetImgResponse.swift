//
//  ProfileSetImgResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/10.
//

import Foundation

struct ProfileSetImgResponse:Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: ProfileImgErr?
}

struct ProfileImgErr: Decodable {
    var err: String
}
