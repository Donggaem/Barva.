//
//  ChatTableViewCell.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/06.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var chatLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
