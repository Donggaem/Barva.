//
//  MyFollowerViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/28.
//

import UIKit

class MyFollowViewController: UIViewController {

    @IBOutlet weak var userNick: UILabel!
    var paramUserNick = ""
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

        userNick.text = paramUserNick
    }
}
