//
//  UpdatePWViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/09/26.
//

import UIKit
import Alamofire

class UpdatePWViewController: UIViewController {
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pwCheckTextField: UITextField!
    
    @IBOutlet weak var msgPwBtn: UIButton!
    @IBOutlet weak var resetPWBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    var paramUserid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTextField()
    }
    //MARK: IBACTION
    @IBAction func resetPWBtnPressed(_ sender: UIButton) {
        let id = paramUserid
        let param = UpdatePWRequest(user_id: id)
        postUpdatePW(param)
    }
    @IBAction func backBtnPressed(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)

    }
    
    //MARK: INNER FUNC
    
    //SET UI
    private func setUI(){
        resetPWBtn.layer.cornerRadius = 5
        btnHidden(msgBtn: msgPwBtn)
        
        idLabel.font = UIFont(name: "SpoqaHanSansNeo-Regular", size: 16)
        idLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        idLabel.text = "아이디 : \(paramUserid)"
        
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
    
    //비밀번호 형식 확인
    private func isValidPW(testStr: String) -> Bool {
        let pwRegEx = "[A-Za-z0-9!_@$%^&+=]{6,15}"
        let pwTest = NSPredicate(format:"SELF MATCHES %@", pwRegEx)
        return pwTest.evaluate(with: testStr)
    }
    
    
    //MARK: POST PWUPDATE
    private func postUpdatePW(_ parameters: UpdatePWRequest){
        AF.request(BarvaURL.pwFindURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: UpdatePWResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("postUpdatePW")
                        
                        let update_alert = UIAlertController(title: "성공", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                            let updateVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            self.navigationController?.pushViewController(updateVC, animated: true)
                            
                        }
                        update_alert.addAction(okAction)
                        present(update_alert, animated: false, completion: nil)
                        
                        
                    } else {
                        BarvaLog.error("postUpdatePW")
                        let Fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        Fail_alert.addAction(okAction)
                        present(Fail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    BarvaLog.error("postUpdatePW")
                    print(error.localizedDescription)
                    let Fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    Fail_alert.addAction(okAction)
                    present(Fail_alert, animated: false, completion: nil)
                }
            }
    }
}

extension UpdatePWViewController: UITextFieldDelegate{
    
    private func setTextField() {
        
        self.pwTextField.delegate = self
        self.pwCheckTextField.delegate = self
        
        //텍스트필드 입력값 변경 감지
        self.pwTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        self.pwCheckTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        
    }
    private func isSameBothTextField(_ first: UITextField,_ second: UITextField) -> Bool {
        
        if(first.text == second.text) {
            
            return true
        } else {
            
            return false
        }
    }
    
    //텍스트 필드 입력값 변하면 유효성 검사
    @objc func TFdidChanged(_ sender: UITextField) {
        
        print("텍스트 변경 감지")
        
        if self.pwTextField.text?.isEmpty == true{
            btnHidden(msgBtn: msgPwBtn)
        }else if self.pwCheckTextField.text?.isEmpty == true {
            btnHidden(msgBtn: msgPwBtn)
        }else if isSameBothTextField(pwTextField, pwCheckTextField) == true {
            btnMessageT(msgBtn: msgPwBtn)
            msgPwBtn.setTitle("비밀번호가 일치합니다", for: .normal)
        }else {
            btnMessageF(msgBtn: msgPwBtn)
            msgPwBtn.setTitle("비밀번호가 일치하지 않습니다", for: .normal)
            
        }
        
        
        //텍스트필드가 채워졌는지, 비밀번호가 일치하는 지 확인, 필수 약관을 동의 했는지
        if  !(self.pwTextField.text?.isEmpty ?? true) && !(self.pwCheckTextField.text?.isEmpty ?? true) &&   isSameBothTextField(pwTextField, pwCheckTextField) {
            resetPWBtn.isEnabled = true
            resetPWBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else {
            resetPWBtn.isEnabled = false
            resetPWBtn.backgroundColor = UIColor(red: 0.733, green: 0.733, blue: 0.733, alpha: 1)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == pwTextField {
            if isValidPW(testStr: pwTextField.text ?? "") == false {
                let fail_alert = UIAlertController(title: "실패", message: "비밀번호 형식이 잘못되었습니다\n 한글, 영어 대소문자,숫자, !_@$%^&+= 사용 6~15자 이내", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "확인", style: .default)
                fail_alert.addAction(okAction)
                present(fail_alert, animated: false, completion: nil)
            }
        }
    }
}
