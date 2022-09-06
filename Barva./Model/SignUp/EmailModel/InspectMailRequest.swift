//
//  InspectMailRequest.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/19.
//

import Foundation

struct InspectMailRequest: Encodable {
    
    var user_email: String
    var confirmNumber: String
    
}
