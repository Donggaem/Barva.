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
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTextField()
    }
    
    //MARK: IBACTION
    @IBAction func siginBtnPressed(_ sender: UIButton) {
        let signinVC = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
        self.navigationController?.pushViewController(signinVC, animated: true)
        
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let homeNav = storyBoard.instantiateViewController(identifier: "HomeNav")
        self.changeRootViewController(homeNav)
    }
    
    @IBAction func idpwFindPressed(_ sender: UIButton) {
        let findVC = self.storyboard?.instantiateViewController(withIdentifier: "FindViewController") as! FindViewController
        self.navigationController?.pushViewController(findVC, animated: true)
    }
    
    //MARK: INNER FUNC
    private func setUI() {
        loginBtn.layer.cornerRadius = 5
        
    }
    
}

//MARK: UITextFiel
extension LoginViewController: UITextFieldDelegate {
    
    private func setTextField() {
        self.idTextField.delegate = self
        self.pwTextField.delegate = self
        
        //텍스트필드 입력값 변경 감지
        self.idTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        self.pwTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        
    }
    
    //MARK: OBJC
    //텍스트 필드 입력값 변하면 유효성 검사
    @objc func TFdidChanged(_ sender: UITextField) {
        
        //2개 텍스트필드가 채워졌는지, 비밀번호가 일치하는 지 확인.
        if !(self.idTextField.text?.isEmpty ?? true) && !(self.pwTextField.text?.isEmpty ?? true) {
            loginBtn(willActive: true)
        }
        else {
            
            loginBtn(willActive: false)
        }
        
    }
    
    //MARK: INNER FUNC
    //버튼 활성화/비활성화
    func loginBtn(willActive: Bool) {
        
        if(willActive == true) {
            //다음 버튼 색 변경
            loginBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            //다음 버튼 색 변경
            loginBtn.backgroundColor = UIColor(red: 0.733, green: 0.733, blue: 0.733, alpha: 1)
        }
    }
}
