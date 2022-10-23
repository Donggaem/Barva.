//
//  GenderSingleResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/22.
//

import Foundation

struct GenderSingleResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: GenderFeedData?
}

struct GenderFeedData: Decodable {
    
    var singleResult: [FeedArray]?
    var err: String?
}
