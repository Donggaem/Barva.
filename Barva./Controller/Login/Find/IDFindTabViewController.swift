//
//  IDFindViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/15.
//

import UIKit
import Alamofire

class IDFindTabViewController: UIViewController {
    

    @IBOutlet weak var idFindBtn: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTextField()
    }
    
    //MARK: - OBJC
    //텍스트 필드 입력값 변하면 유효성 검사
    @objc func TFdidChanged(_ sender: UITextField) {
        
        //2개 텍스트필드가 채워졌는지.
        if !(self.nameTextField.text?.isEmpty ?? true) && !(self.emailTextField.text?.isEmpty ?? true) {
            idFindBtn(willActive: true)
        }
        else {
            
            idFindBtn(willActive: false)
        }
        
    }
    //MARK: - IBACTION
    
    @IBAction func idFindBtnPressed(_ sender: UIButton) {
        
        if isValidEmail(testStr: emailTextField.text ?? "") == true {
            let name = nameTextField.text ?? ""
            let email = emailTextField.text ?? ""
            
            let param = IDFindRequest(user_name: name, user_email: email)
            postIDFind(param)
        }else {
            let Fail_alert = UIAlertController(title: "실패", message: "이메일 형식을 확인해주세요", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            Fail_alert.addAction(okAction)
            present(Fail_alert, animated: false, completion: nil)
        }
        
    }
    
    //MARK: - INNER FUNC
    private func setUI() {
        
        //버튼 모서리
        idFindBtn.layer.cornerRadius = 5
        idFindBtn.setColor_false(button: idFindBtn)
        
    }
    
    //버튼 활성화/비활성화
    func idFindBtn(willActive: Bool) {
        
        if(willActive == true) {
            //다음 버튼 색 변경
            idFindBtn.setColor_true(button: idFindBtn)
        } else {
            //다음 버튼 색 변경
            idFindBtn.setColor_false(button: idFindBtn)
        }
    }
    
    //버튼 비활 색깔
    func setColor_false(button: UIButton) {
        button.setTitleColor(UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1), for: .normal)
        button.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1).cgColor
    }
    
    //버튼 활 색깔
    func setColor_true(button: UIButton) {
        button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1)
    }
    
    //이메일 형식 검사
    private func isValidEmail(testStr:String) -> Bool {
        
        BarvaLog.debug("isValidEmail")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
        
    }
    
    //MARK: - POST IDFIND
    private func postIDFind(_ parameters: IDFindRequest){
        AF.request(BarvaURL.idFindURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: IDFindResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("postIDFind-success")
                        let Find_alert = UIAlertController(title: "성공", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                            
                            self.nameTextField.text = ""
                            self.emailTextField.text = ""
                            idFindBtn.backgroundColor = UIColor(red: 0.733, green: 0.733, blue: 0.733, alpha: 1)

                        }
                        Find_alert.addAction(okAction)
                        present(Find_alert, animated: false, completion: nil)
                        
                        
                    } else {
                        BarvaLog.error("postIDFind-fail")
                        let Fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        Fail_alert.addAction(okAction)
                        present(Fail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    BarvaLog.error("postIDFind-err")
                    print(error.localizedDescription)
                    let Fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    Fail_alert.addAction(okAction)
                    present(Fail_alert, animated: false, completion: nil)
                }
            }
    }
}

//MARK: - UITextFiel
extension IDFindTabViewController: UITextFieldDelegate {
    
    private func setTextField() {
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        
        //텍스트필드 입력값 변경 감지
        self.nameTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        self.emailTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        
    }
}
