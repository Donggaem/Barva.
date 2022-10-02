//
//  UploadRequest.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/02.
//

import Foundation
import UIKit

struct UploadRequest: Encodable {
    var gender: String
    var user_height: String
    var user_weight: String
    var content: String
    var userImg: [Data]
}
