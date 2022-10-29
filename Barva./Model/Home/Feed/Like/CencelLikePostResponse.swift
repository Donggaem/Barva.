//
//  CencelLikePostResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/29.
//

import Foundation

struct CencelLikePostResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: CencelLikePostData?
}

struct CencelLikePostData: Decodable {
    
    var err: String
}

