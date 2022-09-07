//
//  SigninViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/08.
//

import UIKit
import Alamofire

class SigninViewController: UIViewController {
    
    @IBOutlet weak var nickBtn: UIButton!
    @IBOutlet weak var idBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var checkNumBtn: UIButton!
    @IBOutlet weak var signinBtn: UIButton!
    
    @IBOutlet weak var msgCheckNumBtn: UIButton!
    @IBOutlet weak var msgNickBtn: UIButton!
    @IBOutlet weak var msgIdBtn: UIButton!
    @IBOutlet weak var msgPwBtn: UIButton!
    
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var checkNumTextField: UITextField!
    
    var authNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
    
    //MARK: IBACTION
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func aurhMailBtnPressed(_ sender: UIButton) {
        
        let email = emailTextField.text ?? ""
        
        if isValidEmail(testStr: email) == true {
            let param = AuthMailRequest(user_email: email)
            postAuthMail(param)
        }else {
            let fail_alert = UIAlertController(title: "실패", message: "이메일 형식이 잘못되었습니다", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            fail_alert.addAction(okAction)
            present(fail_alert, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func inspectMailBtnPressed(_ sender: UIButton) {
        
        if checkNumTextField.text == authNumber {
            
            //            msgCheckNumBtn.isHidden = true
            let email = emailTextField.text ?? ""
            let checkNum = checkNumTextField.text ?? ""
            
            let param = InspectMailRequest(user_email: email, confirmNumber: checkNum)
            postInspectMail(param)
            
        } else {
            msgCheckNumBtn.isHidden = false
            let fail_alert = UIAlertController(title: "실패", message: "인증번호를 다시 확인해주세요", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            fail_alert.addAction(okAction)
            present(fail_alert, animated: false, completion: nil)
        }
        
    }
    //MARK: INNER FUNC
    //Set UI
    private func setUI() {
        
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true
        
        //버튼 모서리
        nickBtn.layer.cornerRadius = 14
        idBtn.layer.cornerRadius = 14
        emailBtn.layer.cornerRadius = 14
        checkNumBtn.layer.cornerRadius = 14
        signinBtn.layer.cornerRadius = 5
        
        msgCheckNumBtn.isHidden = true
        
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
                self.msgCheckNumBtn.isHidden = true
                self.checkNumBtn.isEnabled = false
                self.checkNumBtn.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.941, alpha: 1)
            } else {
                self.checkNumBtn.isEnabled = true
                self.checkNumBtn.backgroundColor = .black
            }
        }), for: .editingChanged)
        
    }
    
    //이메일 형식 확인
    private func isValidEmail(testStr:String) -> Bool {
        
        BarvaLog.debug("isValidEmail")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //버튼 메세지
    private func btnMessage(msgBtn: UIButton) {
        BarvaLog.debug("btnMessage")
        msgBtn.isHidden = false
        msgBtn.titleLabel?.font = UIFont(name: "SpoqaHanSansNeo-Regular", size: 8)
        msgBtn.tintColor = UIColor(red: 0, green: 0.28, blue: 1, alpha: 1)
        msgBtn.setTitleColor(UIColor(red: 0, green: 0.28, blue: 1, alpha: 1), for: .normal)
        msgBtn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
//        msgBtn.setTitle("    인증번호가 일치합니다", for: .normal)
    }
    
    //MARK: POST NICKCHECK
    private func postNickCheck(_ parameters: NickCheckRequest){
        AF.request(BarvaURL.checkURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: NickCheckResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        //                        checkNum += 1
                        //                        nameCkeckBtn.isUserInteractionEnabled = false
                        //                        ninknameTextField.isUserInteractionEnabled = false
                        
                        btnMessage(msgBtn: msgNickBtn)
                        msgNickBtn.setTitle("    사용가능한 닉네임입니다", for: .normal)
                        
                        let nameCk_alert = UIAlertController(title: "가능", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        nameCk_alert.addAction(okAction)
                        present(nameCk_alert, animated: false, completion: nil)
                        
                    } else {
                        print("닉네임 중복")
                        let nameCkFail_alert = UIAlertController(title: "중복", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        nameCkFail_alert.addAction(okAction)
                        present(nameCkFail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    let nameCkFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    nameCkFail_alert.addAction(okAction)
                    present(nameCkFail_alert, animated: false, completion: nil)
                }
            }
    }
    
    //MARK: POST IDCHECK
    private func postIDCheck(_ parameters: IDCheckRequest){
        AF.request(BarvaURL.checkURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: IDCheckResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        //                        checkNum += 1
                        //                        idCheckBtn.isUserInteractionEnabled = false
                        //                        idTextField.isUserInteractionEnabled = false
                        
                        btnMessage(msgBtn: msgIdBtn)
                        msgIdBtn.setTitle("    사용가능한 아이디입니다", for: .normal)
                        
                        let idCk_alert = UIAlertController(title: "가능", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        idCk_alert.addAction(okAction)
                        present(idCk_alert, animated: false, completion: nil)
                        
                    } else {
                        print("아이디 중복")
                        let idCkFail_alert = UIAlertController(title: "중복", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        idCkFail_alert.addAction(okAction)
                        present(idCkFail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    let idCkFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    idCkFail_alert.addAction(okAction)
                    present(idCkFail_alert, animated: false, completion: nil)
                }
            }
    }
    
    
    
    //MARK: POST AuthMAil
    private func postAuthMail(_ parameters: AuthMailRequest){
        AF.request(BarvaURL.authMailURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: AuthMailResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("PostAuthMail")
                        
                        authNumber = response.data?.authNumber ?? ""
                        
                        let mail_alert = UIAlertController(title: "이메일 발송", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        mail_alert.addAction(okAction)
                        present(mail_alert, animated: false, completion: nil)
                        
                        
                        
                    } else {
                        BarvaLog.error("PostAuthMail")
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        present(fail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    BarvaLog.error("PostAuthMail")
                    print(error.localizedDescription)
                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    present(fail_alert, animated: false, completion: nil)
                }
            }
    }
    
    //MARK: POST InspectMAil
    private func postInspectMail(_ parameters: InspectMailRequest){
        AF.request(BarvaURL.insepectMailURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: InspectMailResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("PostInspectMAil")
                        
                        checkNumTextField.isUserInteractionEnabled = false
                        checkNumBtn.isUserInteractionEnabled = false
                        
                        btnMessage(msgBtn: msgCheckNumBtn)
                        msgCheckNumBtn.setTitle("    인증번호가 일치합니다", for: .normal)
                        
                        let mail_alert = UIAlertController(title: "이메일 인증 완료", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        mail_alert.addAction(okAction)
                        present(mail_alert, animated: false, completion: nil)
                        
                        
                    } else {
                        BarvaLog.error("PostInspectMAil")
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        present(fail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    present(fail_alert, animated: false, completion: nil)
                }
            }
    }
}
