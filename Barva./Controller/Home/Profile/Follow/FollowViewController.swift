//
//  FollowViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/24.
//

import UIKit

class FollowViewController: UIViewController {

    @IBOutlet weak var main_otheruser_nick: UILabel!
    
    var paramMainOtherNick = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        UserDefaults.standard.removeObject(forKey: "follownick")
    }
    
    //MARK: - SETUI
    func setUI() {
        
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true

        main_otheruser_nick.text = paramMainOtherNick
        UserDefaults.standard.set(paramMainOtherNick, forKey: "follownick")
    }
}
