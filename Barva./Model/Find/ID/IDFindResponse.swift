//
//  IDFindResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/09/26.
//

import Foundation

struct IDFindResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: IDFindData?
}

struct IDFindData: Decodable {
    
    var err: String
}
