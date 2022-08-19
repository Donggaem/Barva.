//
//  LoginResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/11.
//

import Foundation

struct LoginResponse: Decodable {
   
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: token?
}

struct token: Decodable{
    
    var token: String
    
}
