//
//  ColorSingleResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/31.
//

import Foundation

struct ColorSingleResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: ColorFeedData?
}

struct ColorFeedData: Decodable {
    
    var singleResult: [FeedArray]?
    var err: String?
}

