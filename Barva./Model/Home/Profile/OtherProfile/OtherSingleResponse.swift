//
//  OtherSingleResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/27.
//

import Foundation

struct OtherSingleResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: OtherFeedData?
}

struct OtherFeedData: Decodable {
    
    var singleResult: [FeedArray]?
    var err: String?
}


 
