//
//  PWFindViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/15.
//

import UIKit
import Alamofire

class PWFindTabViewController: UIViewController {
    
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var checkNumBtn: UIButton!
    @IBOutlet weak var pwFindBtn: UIButton!
    
    @IBOutlet weak var msgCheckNumBtn: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var checkNumTextField: UITextField!
    
    
    var authNumber = ""
    var checkNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTextField()
    }
    
    //MARK: - IBACTION

    @IBAction func authMailBtnPressed(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        
        if isValidEmail(testStr: email) == true {
            let param = SendMailRequest(user_email: email)
            postAuthMail(param)
            
        }else {
            let fail_alert = UIAlertController(title: "실패", message: "이메일 형식이 잘못되었습니다", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            fail_alert.addAction(okAction)
            present(fail_alert, animated: false, completion: nil)
        }
    }
    
    @IBAction func inspectMailPressed(_ sender: UIButton) {
        if checkNumTextField.text == authNumber {
            
            let email = emailTextField.text ?? ""
            let checkNum = checkNumTextField.text ?? ""
            
            let param = InspectMailRequest(user_email: email, confirmNumber: checkNum)
            postInspectMail(param)
            
        } else {
            btnMessageF(msgBtn: msgCheckNumBtn)
            msgCheckNumBtn.setTitle("인증번호가 일치하지 않습니다", for: .normal)
            let fail_alert = UIAlertController(title: "실패", message: "인증번호를 다시 확인해주세요", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            fail_alert.addAction(okAction)
            present(fail_alert, animated: false, completion: nil)
        }
    }
    
    @IBAction func pwFindBtnPressed(_ sender: UIButton) {
        if checkNum == 1 {
            let id = idTextField.text ?? ""
            
            let param = PWFindRequest(user_id: id)
            postPWFind(param)
            
        }else {
            checkNum = 0
            let check_alert = UIAlertController(title: "실패", message: "이메일 인증을 해주세요", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            check_alert.addAction(okAction)
            present(check_alert, animated: false, completion: nil)
        }
    }
    
    //MARK: - INNER FUNC
    private func setUI() {
        
        //버튼 모서리
        emailBtn.layer.cornerRadius = 15
        checkNumBtn.layer.cornerRadius = 15
        pwFindBtn.layer.cornerRadius = 5
        
        btnHidden(msgBtn: msgCheckNumBtn)
        
        //버튼 활성/비활성 액션
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
    
    //이메일 형식 확인
    private func isValidEmail(testStr:String) -> Bool {
        
        BarvaLog.debug("isValidEmail")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
        
    }
    
    //버튼 메세지
    private func btnMessageT(msgBtn: UIButton) {
        
        BarvaLog.debug("btnMessageT")
        msgBtn.makeImageInset(margin: 4)
        msgBtn.titleLabel?.font = UIFont(name: "SpoqaHanSansNeo-Regular", size: 8)
        msgBtn.tintColor = UIColor(red: 0, green: 0.28, blue: 1, alpha: 1)
        msgBtn.setTitleColor(UIColor(red: 0, green: 0.28, blue: 1, alpha: 1), for: .normal)
        msgBtn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
    }
    
    private func btnMessageF(msgBtn: UIButton) {
        
        BarvaLog.debug("btnMessageF")
        msgBtn.makeImageInset(margin: 4)
        msgBtn.titleLabel?.font = UIFont(name: "SpoqaHanSansNeo-Regular", size: 8)
        msgBtn.tintColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        msgBtn.setTitleColor(UIColor(red: 1, green: 0, blue: 0, alpha: 1), for: .normal)
        msgBtn.setImage(UIImage(systemName: "exclamationmark.circle"), for: .normal)
    }
    
    private func btnHidden(msgBtn: UIButton) {
        
        BarvaLog.debug("btnHidden")
        msgBtn.titleLabel?.font = UIFont(name: "SpoqaHanSansNeo-Regular", size: 8)
        msgBtn.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        msgBtn.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
    }
    
    //MARK: - POST PWFIND
    private func postPWFind(_ parameters: PWFindRequest){
        AF.request(BarvaURL.pwFindURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: PWFindResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("postPWFind-success")
                        pwFindBtn.isEnabled = true
                        let updateVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdatePWViewController") as! UpdatePWViewController
                        self.navigationController?.pushViewController(updateVC, animated: true)
                        
                        updateVC.paramUserid = idTextField.text ?? ""
                        
                    } else {
                        BarvaLog.error("postPWFind-fail")
                        let Fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        Fail_alert.addAction(okAction)
                        present(Fail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    BarvaLog.error("postPWFind-err")
                    print(error.localizedDescription)
                    let Fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    Fail_alert.addAction(okAction)
                    present(Fail_alert, animated: false, completion: nil)
                }
            }
    }
    
    //MARK: POST AuthMAil
    private func postAuthMail(_ parameters: SendMailRequest){
        AF.request(BarvaURL.pwFindEmailURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: SendMailResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("PostAuthMail-success")
                        
                        authNumber = response.data?.authNumber ?? ""
                        
                        let mail_alert = UIAlertController(title: "이메일 발송", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        mail_alert.addAction(okAction)
                        present(mail_alert, animated: false, completion: nil)
                        
                        
                        
                    } else {
                        BarvaLog.error("PostAuthMail-fail")
                        
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        present(fail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    BarvaLog.error("PostAuthMail-err")
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
                        
                        BarvaLog.debug("PostInspectMAil-succedd")
                        
                        checkNum += 1
                        checkNumTextField.isUserInteractionEnabled = false
                        checkNumBtn.isUserInteractionEnabled = false
                        
                        btnMessageT(msgBtn: msgCheckNumBtn)
                        msgCheckNumBtn.setTitle("인증번호가 일치합니다", for: .normal)
                        
                        let mail_alert = UIAlertController(title: "이메일 인증 완료", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        mail_alert.addAction(okAction)
                        present(mail_alert, animated: false, completion: nil)
                        
                        
                    } else {
                        BarvaLog.error("PostInspectMAil-fail")
                        btnMessageF(msgBtn: msgCheckNumBtn)
                        msgCheckNumBtn.setTitle(response.message, for: .normal)
                        print(response.data?.err ?? "")
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        present(fail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    BarvaLog.error("PostInspectMAil-err")
                    print(error.localizedDescription)
                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    present(fail_alert, animated: false, completion: nil)
                }
            }
    }
}

extension PWFindTabViewController: UITextFieldDelegate{
    
    private func setTextField() {
        
        self.idTextField.delegate = self
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.checkNumTextField.delegate = self
        
        //텍스트필드 입력값 변경 감지
        self.idTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        self.nameTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        self.emailTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        self.checkNumTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
    }
    
    @objc func TFdidChanged(_ sender: UITextField) {
        
        //텍스트필드가 채워졌는지, 비밀번호가 일치하는 지 확인, 필수 약관을 동의 했는지
        if  !(self.nameTextField.text?.isEmpty ?? true) && !(self.idTextField.text?.isEmpty ?? true) &&  !(self.emailTextField.text?.isEmpty ?? true) &&  !(self.checkNumTextField.text?.isEmpty ?? true) {
            pwFindBtn.isEnabled = true
            pwFindBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else {
            pwFindBtn.isEnabled = false
            pwFindBtn.backgroundColor = UIColor(red: 0.733, green: 0.733, blue: 0.733, alpha: 1)
        }
    }
    
}
