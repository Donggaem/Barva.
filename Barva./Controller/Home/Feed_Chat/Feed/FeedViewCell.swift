//
//  FeedViewCell.swift
//  Barva.
//
//  Created by 김동겸 on 2022/09/30.
//

import Foundation
import FSPagerView
import Kingfisher

protocol NaviAction: AnyObject {
    func moveChatVC()
    
    func moveOthereVC()
}

class FeedViewCell: FSPagerViewCell {
    
    @IBOutlet weak var feedNameLabel: UILabel!
    @IBOutlet weak var feedSpecLabel: UILabel!
    
    @IBOutlet weak var feedImage: FSPagerView!{
        didSet {
            self.feedImage.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.feedImage.itemSize = FSPagerView.automaticSize
        }
    }
    
    @IBOutlet weak var heartBtn: UIButton!
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    weak var delegate: NaviAction?
    
    var paramImg: [String]? {
        didSet {
            self.feedImage.reloadData()
        }
    }
    
    var bookmarkBool = false
    
    
    //MARK: - IBACTION
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
    @IBAction func bookmarkBtnPressed(_ sender: UIButton) {
        if bookmarkBool == false {
            bookmarkBool = true
            bookmarkBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }else {
            bookmarkBool = false
            bookmarkBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
    @IBAction func othereProfile(_ sender: UIButton) {
        print("click")
        self.delegate?.moveOthereVC()
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
extension FeedViewCell: FSPagerViewDataSource, FSPagerViewDelegate {
    
    //이미지 개수
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.paramImg?.count ?? 0
    }
    
    //각셀에 대한 설정
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = feedImage.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
//        cell.imageView?.image = UIImage(named: self.delegateImg?.feedImages[index] ?? "")
        
        cell.imageView?.image = UIImage(named: paramImg?[index] ?? "")
        
//        let url = URL(string: self.delegateImg?.feedImages[index] ?? "")
//        cell.imageView?.kf.setImage(with: url)
        
        return cell
    }
}
