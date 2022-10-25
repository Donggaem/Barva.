//
//  ResignResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/25.
//

import Foundation

struct ResignResponse:Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: ResignData?
}

struct ResignData: Decodable {
    var err: String
}
