//
//  InspectMailRewponse.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/19.
//

import Foundation

struct InspectMailResponse: Decodable{
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: InspectData?
}

struct InspectData: Decodable {
    var err: String
}
