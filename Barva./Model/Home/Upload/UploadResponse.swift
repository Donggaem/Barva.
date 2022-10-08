//
//  UploadResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/02.
//

import Foundation

struct UploadResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: [String]
}

//struct UploadInfo: Decodable {
//
//}
