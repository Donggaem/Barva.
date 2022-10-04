//
//  AuthMailResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/19.
//

import Foundation

struct SendMailResponse: Decodable{
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data:  SendMailData?
    
}

struct SendMailData: Decodable {
    
//    var err: String
    var authNumber: String
  
}
