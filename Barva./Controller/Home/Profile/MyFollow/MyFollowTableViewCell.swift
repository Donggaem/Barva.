//
//  MyFollowTableViewCell.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/28.
//

import Foundation
import UIKit

protocol FollowBtnAction: AnyObject {
    func followBtnAction(button: UIButton)
}

class MyFollowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var followNick: UILabel!
    @IBOutlet weak var followProfileImg: UIImageView!{
        didSet {
            //프사 이미지 둥글게
            followProfileImg.layer.cornerRadius = followProfileImg.frame.height/2
            followProfileImg.clipsToBounds = true
        }
    }
    @IBOutlet weak var followName: UILabel!
    @IBOutlet weak var followBtn: UIButton! {
        didSet {
            followBtn.layer.cornerRadius = 5
        }
    }
    
    weak var delegate: FollowBtnAction?
    
    @IBAction func followBtnPressed(_ sender: UIButton) {
        print("셀클릭")
        delegate?.followBtnAction(button: followBtn)
    }
}
