//
//  MyFollowTableViewCell.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/28.
//

import UIKit

class MyFollowTableViewCell: UITableViewCell {

    @IBOutlet weak var followerProfileImg: UIImageView!
    @IBOutlet weak var followNick: UILabel!
    @IBOutlet weak var followName: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    @IBAction func followerBtnPressed(_ sender: UIButton) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
