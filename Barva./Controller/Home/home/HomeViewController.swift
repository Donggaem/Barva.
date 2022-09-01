//
//  HomeViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/11.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupPresent()
        setUI()
    }
    
    func popupPresent() {
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let popUp = storyboard.instantiateViewController(identifier: "PopupViewController")
        popUp.modalPresentationStyle = .overFullScreen
        popUp.modalTransitionStyle = .crossDissolve
        self.present(popUp, animated: true, completion: nil)
    }
    
    private func setUI() {
        
        //탭바 설정
        self.tabBarController?.tabBar.tintColor = UIColor(red: 0.262, green: 0.262, blue: 0.262, alpha: 1) //탭바 선택 아이템 색
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(red: 0.262, green: 0.262, blue: 0.262, alpha: 1) //탭바 미선택 아이템 색
        self.tabBarController?.tabBar.backgroundColor = .white //탭바 배경색
        self.tabBarController?.tabBar.layer.borderWidth = 1 //탭바 보더
        self.tabBarController?.tabBar.layer.borderColor = UIColor(red: 0.846, green: 0.846, blue: 0.846, alpha: 1).cgColor //탭바 보더 색

    }
}
