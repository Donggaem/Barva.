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
    var data: NickData?
}

struct NickData: Decodable{
    var err: String
}
