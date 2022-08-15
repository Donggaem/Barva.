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
    }
    
    func popupPresent() {
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let popUp = storyboard.instantiateViewController(identifier: "PopupViewController")
        popUp.modalPresentationStyle = .overFullScreen
        popUp.modalTransitionStyle = .crossDissolve
        self.present(popUp, animated: true, completion: nil)
    }

}
