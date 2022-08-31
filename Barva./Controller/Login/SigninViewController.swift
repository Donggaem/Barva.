//
//  SigninViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/08.
//

import UIKit

class SigninViewController: UIViewController {
    
    @IBOutlet weak var nickBtn: UIButton! 
    @IBOutlet weak var idBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var checkNumBtn: UIButton!
    @IBOutlet weak var signinBtn: UIButton!
    
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var checkNumTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: SET UI
    private func setUI() {
        
        self.navigationController?.navigationBar.isHidden = true
        
        //버튼 모서리
        nickBtn.layer.cornerRadius = 14
        idBtn.layer.cornerRadius = 14
        emailBtn.layer.cornerRadius = 14
        checkNumBtn.layer.cornerRadius = 14
        signinBtn.layer.cornerRadius = 5
        
//        nickBtn.layer.cornerRedius = frame.height / 2
        
        //버튼 활성/비활성 액션
        self.nickNameTextField.addAction(UIAction(handler: { _ in
            if self.nickNameTextField.text?.isEmpty == true {
                self.nickBtn.isEnabled = false
                self.nickBtn.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.941, alpha: 1)
            } else {
                self.nickBtn.isEnabled = true
                self.nickBtn.backgroundColor = .black
            }
        }), for: .editingChanged)
        
        self.idTextField.addAction(UIAction(handler: { _ in
            if self.idTextField.text?.isEmpty == true {
                self.idBtn.isEnabled = false
                self.idBtn.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.941, alpha: 1)
            } else {
                self.idBtn.isEnabled = true
                self.idBtn.backgroundColor = .black
            }
        }), for: .editingChanged)
        
        self.emailTextField.addAction(UIAction(handler: { _ in
            if self.emailTextField.text?.isEmpty == true {
                self.emailBtn.isEnabled = false
                self.emailBtn.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.941, alpha: 1)
            } else {
                self.emailBtn.isEnabled = true
                self.emailBtn.backgroundColor = .black
            }
        }), for: .editingChanged)
        
        self.checkNumTextField.addAction(UIAction(handler: { _ in
            if self.checkNumTextField.text?.isEmpty == true {
                self.checkNumBtn.isEnabled = false
                self.checkNumBtn.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.941, alpha: 1)
            } else {
                self.checkNumBtn.isEnabled = true
                self.checkNumBtn.backgroundColor = .black
            }
        }), for: .editingChanged)
        
    }
    
}
