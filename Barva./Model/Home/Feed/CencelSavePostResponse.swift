//
//  CencelSavePostResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/25.
//

import Foundation

struct CencelSavePostResponse: Decodable{
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: CencelSavePostData?
}

struct CencelSavePostData: Decodable {
    var err: String
}
