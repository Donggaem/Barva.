//
//  SigninRequest.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/11.
//

import Foundation

struct SignRequest: Encodable {
    
    var user_name: String
    var user_nick: String
    var user_id: String
    var user_pw: String
    var user_email: String
    var marketing: Bool
}
