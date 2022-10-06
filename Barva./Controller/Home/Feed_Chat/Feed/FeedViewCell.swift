//
//  FeedViewCell.swift
//  Barva.
//
//  Created by 김동겸 on 2022/09/30.
//

import Foundation
import FSPagerView

protocol NaviAction: AnyObject {
    func moveChatVC()
}

class FeedViewCell: FSPagerViewCell {
    
    @IBOutlet weak var feedNameLabel: UILabel!
    @IBOutlet weak var feedSpecLabel: UILabel!
    @IBOutlet weak var feedImage: UIImageView!
    
    @IBOutlet weak var heartBtn: UIButton!
    
    weak var delegate: NaviAction?
    
    //MARK: IBACTION
    @IBAction func allChatBtnPressed(_ sender: UIButton) {

        self.delegate?.moveChatVC()
    }
    
    @IBAction func heartBtnPressed(_ sender: UIButton) {
        if heartBtn.isSelected == false {
            heartBtn.isSelected = true
            heartBtnColorT(checkBtn: heartBtn)
        }else{
            heartBtn.isSelected = false
            heartBtnColorF(checkBtn: heartBtn)
        }
    }
    
    //INNER FUNC
    //좋아요 버튼 색 변경
    private func heartBtnColorT(checkBtn: UIButton) {
        BarvaLog.debug("termsCheckT")
        heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        heartBtn.tintColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        
    }
    
    private func heartBtnColorF(checkBtn: UIButton) {
        BarvaLog.debug("termsCheckF")
        heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        heartBtn.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
