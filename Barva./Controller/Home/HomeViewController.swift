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

    @IBAction func test(_ sender: UIButton) {
        let testVC = self.storyboard?.instantiateViewController(withIdentifier: "testViewController") as! testViewController
        self.navigationController?.pushViewController(testVC, animated: true)
    }
}
