//
//  ViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/08.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var pwTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func siginBtnPressed(_ sender: UIButton) {
        let signinVC = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
        self.navigationController?.pushViewController(signinVC, animated: true)
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let homeNav = storyBoard.instantiateViewController(identifier: "HomeNav")
        self.changeRootViewController(homeNav)
    }
    
}

