//
//  PWFindResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/09/26.
//

import Foundation

struct PWFindResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: PWFindData?
}

struct PWFindData: Decodable {
    
    var err: String
}
