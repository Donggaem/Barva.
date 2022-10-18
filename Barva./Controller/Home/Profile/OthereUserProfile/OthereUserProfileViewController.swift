//
//  OthereUserProfileViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/18.
//

import UIKit

class OthereUserProfileViewController: UIViewController {

    @IBOutlet weak var othereUserNick: UILabel!
    @IBOutlet weak var othereUserProfileImg: UIImageView!
    @IBOutlet weak var othereUserIntro: UILabel!
    
    var paramImg = ""
    var paramNick = ""
    var paramIntro = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
}
