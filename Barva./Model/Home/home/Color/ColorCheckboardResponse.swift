//
//  ColorCheckboardResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/31.
//

import Foundation

struct ColorCheckboardResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: ColorCheckboardData?
    
}

struct ColorCheckboardData: Decodable {
    
    var checkerboardArr: [String]?
    var err: String?
}

