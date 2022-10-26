//
//  SavePostCheckerboardResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/26.
//

import Foundation

struct SavePostCheckerboardResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: SavePostCheckerboardData?
    
}

struct SavePostCheckerboardData: Decodable {
    
    var checkerboardArr: [String]?
    
    var err: String?
}
