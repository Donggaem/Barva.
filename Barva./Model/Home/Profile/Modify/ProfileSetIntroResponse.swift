//
//  ProfileSetIntroResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/10.
//

import Foundation

struct ProfileSetIntroResponse:Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: IntroErr?
}

struct IntroErr: Decodable {
    var err: String
}
