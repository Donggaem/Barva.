//
//  GenderCheckboardResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/22.
//

import Foundation

struct GenderCheckboardResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: GenderCheckboardData?
    
}

struct GenderCheckboardData: Decodable {
    
    var checkerboardArr: [String]?
    var err: String
}
