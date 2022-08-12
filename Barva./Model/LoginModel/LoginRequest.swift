//
//  LoginRequest.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/11.
//

import Foundation

struct LoginRequest: Encodable {
    
    var user_id: String
    var user_pw: String
    
}
