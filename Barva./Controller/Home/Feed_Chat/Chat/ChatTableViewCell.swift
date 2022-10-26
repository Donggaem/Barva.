//
//  ChatTableViewCell.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/06.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var chatProfileImg: UIImageView!
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var chatLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
