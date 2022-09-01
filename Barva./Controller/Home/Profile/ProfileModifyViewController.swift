//
//  ProfileModifyViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/09/02.
//

import UIKit

class ProfileModifyViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    //IBAction
    @IBAction func backBtnPressed(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)

    }
    

    private func setUI() {
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true
    }
}
