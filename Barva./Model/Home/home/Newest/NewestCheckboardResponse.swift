//
//  NewestCheckboardResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/22.
//

import Foundation

struct NewestCheckerboardResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: NewestCheckerboardData?
}

struct NewestCheckerboardData: Decodable {
    
    var checkerboardArr: [String]?
    
    var err: String?
}
