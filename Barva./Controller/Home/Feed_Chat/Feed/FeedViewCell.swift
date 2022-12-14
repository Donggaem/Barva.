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
    func moveOtherVC()
    func checkBookmark(bookmark: Bool)
    func checkLike(like: Bool)
    
}

class FeedViewCell: FSPagerViewCell {
    
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            pageControl.setStrokeColor(UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), for: .normal)
            pageControl.setStrokeColor(UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1), for: .selected)
            
            pageControl.setFillColor(UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), for: .normal)
            pageControl.setFillColor(UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1), for: .selected)
        }
    }
    
    @IBOutlet weak var feedProfileImg: UIImageView! {
        didSet {
            //프사 이미지 둥글게
            feedProfileImg.layer.cornerRadius = feedProfileImg.frame.height/2
            feedProfileImg.clipsToBounds = true
        }
    }
    @IBOutlet weak var feedNameLabel: UILabel!
    @IBOutlet weak var feedSpecLabel: UILabel!

    @IBOutlet weak var feedText: UILabel!
    
    @IBOutlet weak var feedDay: UILabel!
    @IBOutlet weak var feedImage: FSPagerView!{
        didSet {
            self.feedImage.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.feedImage.itemSize = FSPagerView.automaticSize
            self.feedImage.isExclusiveTouch = false
        }
    }
    
    @IBOutlet weak var heartBtn: UIButton!
    @IBOutlet weak var heartCount: UILabel! 
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    weak var delegate: NaviAction?
    
    var paramImg: [String]? {
        didSet {
            self.feedImage.reloadData()
        }
    }
    
    var bookmarkBool = false {
        didSet {
            if bookmarkBool == false {
                bookmarkBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)

            }else {
                bookmarkBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)

            }
        }
    }
    
    var likeBool = false {
        didSet {
            if likeBool == false {
                
                heartBtnColorF(checkBtn: heartBtn)
            }else {
                
                heartBtnColorT(checkBtn: heartBtn)
            }
        }
    }
    
    var heartIntCount = 0 {
        didSet {
            heartCount.text = String(heartIntCount)
        }
    }
    
    //MARK: - IBACTION
    @IBAction func allChatBtnPressed(_ sender: UIButton) {

        self.delegate?.moveChatVC()
        
    }
    
    @IBAction func heartBtnPressed(_ sender: UIButton) {
        if likeBool == false {
            delegate?.checkLike(like: likeBool)
            likeBool = true
            heartBtnColorT(checkBtn: heartBtn)
            heartIntCount += 1
        }else{
            delegate?.checkLike(like: likeBool)
            likeBool = false
            heartBtnColorF(checkBtn: heartBtn)
            heartIntCount -= 1
        }
    }
    @IBAction func bookmarkBtnPressed(_ sender: UIButton) {
        if bookmarkBool == false {
            delegate?.checkBookmark(bookmark: bookmarkBool)
            bookmarkBool = true
        }else {
            delegate?.checkBookmark(bookmark: bookmarkBool)
            bookmarkBool = false
        }
    }
    @IBAction func othereProfile(_ sender: UIButton) {
        self.delegate?.moveOtherVC()
    }
    
    //MARK: - INNER FUNC
    //좋아요 버튼 색 변경
    private func heartBtnColorT(checkBtn: UIButton) {
        BarvaLog.debug("termsCheckT")
        heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        heartBtn.tintColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        heartCount.textColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        
    }
    
    private func heartBtnColorF(checkBtn: UIButton) {
        BarvaLog.debug("termsCheckF")
        heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        heartBtn.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        heartCount.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    
    
}
//MARK: - Extension FSPagerView
extension FeedViewCell: FSPagerViewDataSource, FSPagerViewDelegate {
    
    //이미지 개수
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.paramImg!.count
    }
    
    //각셀에 대한 설정
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = feedImage.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
//        cell.imageView?.image = UIImage(named: self.delegateImg?.feedImages[index] ?? "")
               
        pageControl.currentPage = index
        let url = URL(string: paramImg?[index] ?? "")
        cell.imageView?.kf.setImage(with: url)
        
        return cell
    }
}
