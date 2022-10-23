//
//  NewestSingleResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/22.
//

import Foundation

struct NewestSingleResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: NewestFeedData?
}

struct NewestFeedData: Decodable {
    
    var singleResult: [FeedArray]?
    var err: String?
}
