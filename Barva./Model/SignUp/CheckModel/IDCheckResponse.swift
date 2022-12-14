//
//  IDCheckResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/09/26.
//

import Foundation

struct IDCheckResponse: Decodable{
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: IDData?
}

struct IDData: Decodable {
    var err: String
}
