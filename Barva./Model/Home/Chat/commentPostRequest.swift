//
//  commentPostRequest.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/25.
//

import Foundation

struct commentPostRequest: Encodable {
    var comment: String
    var post_id: String
}
