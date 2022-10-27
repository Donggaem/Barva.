//
//  OtherCheckboardResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/27.
//

import Foundation

struct OtherCheckboardResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: OtherCheckboardData?
}

struct OtherCheckboardData: Decodable {
    
    var checkerboardArr: [String]?
    var err: String? 
}
