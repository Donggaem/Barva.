//
//  IDCheckResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/19.
//

import Foundation

struct IDCheckResponse: Decodable{
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: IDerr?
}

struct IDerr: Decodable {
    var err: String
}
