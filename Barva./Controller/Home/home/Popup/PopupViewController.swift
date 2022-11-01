//
//  PopupViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/13.
//

import UIKit
import FSPagerView

class PopupViewController: UIViewController {
    

    @IBOutlet weak var pagerView: FSPagerView!{
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = FSPagerView.automaticSize
            self.pagerView.automaticSlidingInterval = 3.0
            self.pagerView.transformer = FSPagerViewTransformer(type: .linear)
            
        }
    }
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            self.pageControl.numberOfPages = 3
        }
    }

    @IBOutlet weak var countImg: UIImageView!
    @IBOutlet weak var popupView: UIView!
    
    var images = ["a","b", "c"]
    var images_control = ["one", "two", "third"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        self.pagerView.delegate = self
        self.pagerView.dataSource = self
    }
    
    
    //MARK: - INNER FUNC
    private func setUI() {
        popupView.layer.cornerRadius = 5
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        view.isOpaque = false
        
        pageControl.setStrokeColor(.white, for: .normal)
        pageControl.setStrokeColor(.white, for: .selected)
    }
    
    //백그라운드 터치시 뷰컨 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first , touch.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

//MARK: - Extension FSPagerView
extension PopupViewController: FSPagerViewDataSource, FSPagerViewDelegate {

    //이미지 개수
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return images.count
    }
    
    //각셀에 대한 설정
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> (FSPagerViewCell) {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        pageControl.currentPage = index
        cell.imageView?.image = UIImage(named: images[index])
        countImg.image = UIImage(named: images_control[index])
        return (cell)
    }
}
