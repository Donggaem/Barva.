//
//  UserFeedViewCell.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/21.
//

import Foundation
import FSPagerView

protocol UserFeedNaviAction: AnyObject {
    func moveChatVC()
    
}

class UserFeedViewCell: FSPagerViewCell {
    
    @IBOutlet weak var userImg_Feed: UIImageView!{
        didSet {
            //프사 이미지 둥글게
            userImg_Feed.layer.cornerRadius = userImg_Feed.frame.height/2
            userImg_Feed.clipsToBounds = true
        }
    }
    @IBOutlet weak var userName_Feed: UILabel!
    @IBOutlet weak var userSpec_Feed: UILabel!
    @IBOutlet weak var userFeedImg: FSPagerView!{
        didSet {
            self.userFeedImg.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.userFeedImg.itemSize = FSPagerView.automaticSize
        }
    }
    @IBOutlet weak var textView_Feed: UITextView!
    @IBOutlet weak var heartBtn: UIButton!
    
    weak var delegate: UserFeedNaviAction?

    
    var paramImg: [String]? {
        didSet {
            self.userFeedImg.reloadData()
        }
    }
    
    //MARK: - IBACTION
    @IBAction func modifyBtnPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func chatShowBtnPressed(_ sender: UIButton) {
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
    
    //MARK: - INNER FUNC
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

//MARK: - Extension FSPagerView
extension UserFeedViewCell: FSPagerViewDataSource, FSPagerViewDelegate {
    
    //이미지 개수
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return paramImg!.count
    }
    
    //각셀에 대한 설정
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = userFeedImg.dequeueReusableCell(withReuseIdentifier: "cell", at: index)

        let url = URL(string: paramImg?[index] ?? "")
        cell.imageView?.kf.setImage(with: url)
        
        return cell
    }
}
