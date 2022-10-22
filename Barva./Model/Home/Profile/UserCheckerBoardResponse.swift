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
    var data: UserCheckerboardData?
    
}

struct UserCheckerboardData: Decodable {
    
    var checkerboardArr: [String?]?
    
    var err: String?
}
