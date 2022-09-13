//
//  NickCheckResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/19.
//

import Foundation

struct NickCheckResponse: Decodable{
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: Nickerr?
}

struct Nickerr: Decodable{
    var err: String
}
