//
//  UdatePWRequest.swift
//  Barva.
//
//  Created by 김동겸 on 2022/09/26.
//

import Foundation

struct UpdatePWRequest: Encodable {
    
    var user_id: String
    var user_updatePw: String
}
