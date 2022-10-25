//
//  UpdatePWResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/09/26.
//

import Foundation

struct UpdatePWResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: UpdatePWerr?
}

struct UpdatePWerr: Decodable {
    
    var err: String
}
