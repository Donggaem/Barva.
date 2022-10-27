//
//  FollowCell.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/24.
//

import Foundation
import UIKit

class FollowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            profileImage.layer.cornerRadius = profileImage.frame.height/2
            profileImage.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var folowBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBAction func followBtnPressed(_ sender: UIButton) {
        
    }
}
