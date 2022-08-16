//
//  PopupViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/13.
//

import UIKit

class PopupViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var images = ["jo", "jo2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        
    }
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        imageView.image = UIImage(named: images[pageControl.currentPage])
    }

    
    private func setUI() {
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        view.isOpaque = false
        
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        // 페이지 표시 색상
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        // 현재 페이지 표시 색상
        pageControl.currentPageIndicatorTintColor = UIColor.black
        imageView.image = UIImage(named: images[0])
        
        // 한 손가락 스와이프 제스쳐 등록(좌, 우)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(PopupViewController.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(PopupViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        // 만일 제스쳐가 있다면
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            
            // 발생한 이벤트가 각 방향의 스와이프 이벤트라면
            // pageControl이 가르키는 현재 페이지에 해당하는 이미지를 imageView에 할당
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left :
                pageControl.currentPage += 1
                imageView.image = UIImage(named: images[pageControl.currentPage])
            case UISwipeGestureRecognizer.Direction.right :
                pageControl.currentPage -= 1
                imageView.image = UIImage(named: images[pageControl.currentPage])
            default:
                break
            }
        }
    }
    //백그라운드 터치시 뷰컨 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first , touch.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }
    }

}
