//
//  SavePostSingleResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/26.
//

import Foundation

struct SavePostSingleResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: SavePostSingleData?
}

struct SavePostSingleData: Decodable {
    
    var singleResult: [SavedPosts]?
    var err: String?
}

struct SavedPosts:Decodable {
    var saved_posts: FeedArray
    var isSave: Bool
}

