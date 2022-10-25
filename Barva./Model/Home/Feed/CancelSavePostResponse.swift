//
//  CencelSavePostResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/25.
//

import Foundation

struct CancelSavePostResponse: Decodable{
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: CancelSavePostData?
}

struct CancelSavePostData: Decodable {
    var err: String
}
