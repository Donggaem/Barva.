//
//  SigninResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/11.
//

import Foundation

struct SigninResponse: Decodable {
   
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: SignData?
}

struct SignData: Decodable {
    var err: String
}
