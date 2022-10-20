//
//  UserCheckerBoardResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/18.
//

import Foundation

struct UserCheckerBoardResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: CheckerboardData?
    
}

struct CheckerboardData: Decodable {
    
    var checkerboardArr: [String?]?
    
    var err: String?
}
