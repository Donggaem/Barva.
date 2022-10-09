//
//  IDPWFindViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/15.
//

import UIKit

class FindViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - IBACTION
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
