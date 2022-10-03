//
//  FeedViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/09/28.
//

import UIKit
import FSPagerView

class FeedViewController: UIViewController {

    var paramImg = ""
    
    @IBOutlet weak var feedPagerView: FSPagerView!{
        didSet {
            self.feedPagerView.register(UINib(nibName:"FeedViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "FeedViewCell")
            //아이템 크기설정
            self.feedPagerView.itemSize = FSPagerView.automaticSize
            
            //무한 스크롤
            self.feedPagerView.isInfinite = true
            self.feedPagerView.scrollDirection = .vertical
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        
        feedPagerView.dataSource = self
        feedPagerView.delegate = self
    }
    
    //MARK: IBACTION
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    
    //MARK: INNER FUNC
    private func setUI(){
        
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true
    }

}

extension FeedViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    
    //이미지 갯수
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return paramImg.count
    }
    
    //각셀의 대한 설정
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "FeedViewCell", at: index) as! FeedViewCell
        
        cell.feedImage.image = UIImage(named: paramImg)
        cell.contentView.isUserInteractionEnabled = false
        
        return cell
    }
    
    
}
