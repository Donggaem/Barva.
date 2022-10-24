//
//  FollowViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/24.
//

import UIKit

class FollowViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - SETUI
    func setUI() {
        
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true

    }
}
