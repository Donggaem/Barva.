//
//  ProfileResponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/09.
//

import Foundation

struct ProfileResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    
    var user_name: String
    var proflieImg: String
    var intro: String
    var imgData: [String]
}
