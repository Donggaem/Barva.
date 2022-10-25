//
//  SigninViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/08.
//

import UIKit
import Alamofire

class SigninViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var nickBtn: UIButton!
    @IBOutlet weak var idBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var checkNumBtn: UIButton!
    @IBOutlet weak var signinBtn: UIButton!
    
    @IBOutlet weak var msgCheckNumBtn: UIButton!
    @IBOutlet weak var msgNickBtn: UIButton!
    @IBOutlet weak var msgIdBtn: UIButton!
    @IBOutlet weak var msgPwBtn: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pwCheckTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var checkNumTextField: UITextField!
    
    @IBOutlet weak var allCheckBtn: UIButton!
    @IBOutlet weak var termsBtn: UIButton!
    @IBOutlet weak var termsGoBtn: UIButton!
    @IBOutlet weak var personalBtn: UIButton!
    @IBOutlet weak var personalGoBtn: UIButton!
    @IBOutlet weak var marketingBtn: UIButton!
    
    var authNumber = ""
    var checkNum = 0
    var marketingBool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTextField()
        checkNum = 0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    //MARK: - IBACTION
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nickBtnPressed(_ sender: UIButton) {
        let nick = nickNameTextField.text ?? ""
        if nickNameTextField.text == "" {
            let checkNil_alert = UIAlertController(title: "실패", message: "닉네임을 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            checkNil_alert.addAction(okAction)
            present(checkNil_alert, animated: false, completion: nil)
            
        }else if isValidNick(testStr: nick) == false {
            btnMessageF(msgBtn: msgNickBtn)
            msgNickBtn.setTitle("닉네임형식을 확인해주세요.\n (한글, 영어 대소문자 사용 2~15자이내) ", for: .normal)
            let check_alert = UIAlertController(title: "실패", message: "닉네임형식을 확인해주세요.\n (한글, 영어 대소문자 사용 2~15자이내) ", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            check_alert.addAction(okAction)
            present(check_alert, animated: false, completion: nil)
        }
        else {
            let nick = nickNameTextField.text ?? ""
            let param = NickCheckRequest(user_nick: nick)
            postNickCheck(param)
        }
    }
    
    @IBAction func idBtnPressed(_ sender: UIButton) {
        let id = idTextField.text ?? ""
        if idTextField.text == "" {
            let checkNil_alert = UIAlertController(title: "실패", message: "아이디를 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            checkNil_alert.addAction(okAction)
            present(checkNil_alert, animated: false, completion: nil)
            
        }else if isValidID(testStr: id) == false {
            btnMessageF(msgBtn: msgIdBtn)
            msgIdBtn.setTitle("아이디형식을 확인해주세요.\n (영어 대소문자, 숫자 사용 5~15자이내) ", for: .normal)
            let check_alert = UIAlertController(title: "실패", message: "아이디형식을 확인해주세요.\n (영어 대소문자, 숫자 사용 5~15자이내) ", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            check_alert.addAction(okAction)
            present(check_alert, animated: false, completion: nil)
        }
        else {
            let param = IDCheckRequest(user_id: id)
            postIDCheck(param)
        }
    }
    
    @IBAction func authMailBtnPressed(_ sender: UIButton) {
        
        let email = emailTextField.text ?? ""
        
        if isValidEmail(testStr: email) == true {
            let param = SendMailRequest(user_email: email)
            postSendMail(param)
            
        }else {
            let fail_alert = UIAlertController(title: "실패", message: "이메일 형식이 잘못되었습니다", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            fail_alert.addAction(okAction)
            present(fail_alert, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func inspectMailBtnPressed(_ sender: UIButton) {
        
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
    
    @IBAction func allCheckBtnPressed(_ sender: UIButton) {
        if allCheckBtn.isSelected == false {
            allCheckBtn.isSelected = true
            termsCheckColorT(checkBtn: allCheckBtn)
            termsCheckColorT(checkBtn: termsBtn)
            termsCheckColorT(checkBtn: termsGoBtn)
            termsCheckColorT(checkBtn: personalBtn)
            termsCheckColorT(checkBtn: personalGoBtn)
            termsCheckColorT(checkBtn: marketingBtn)
            
        }else {
            allCheckBtn.isSelected = false
            termsCheckColorF(checkBtn: allCheckBtn)
            termsCheckColorF(checkBtn: termsBtn)
            termsCheckColorF(checkBtn: termsGoBtn)
            termsCheckColorF(checkBtn: personalBtn)
            termsCheckColorF(checkBtn: personalGoBtn)
            termsCheckColorF(checkBtn: marketingBtn)
        }
        

    }
    @IBAction func termsBtnPressed(_ sender: UIButton) {
        if termsBtn.isSelected == false {
            termsBtn.isSelected = true
            allCheck()
            termsCheckColorT(checkBtn: termsBtn)
            termsCheckColorT(checkBtn: termsGoBtn)
        }else {
            termsBtn.isSelected = false
            allCheck()
            termsCheckColorF(checkBtn: termsBtn)
            termsCheckColorF(checkBtn: termsGoBtn)
        }
    }
    @IBAction func termsGoBtnPressed(_ sender: UIButton) {
        
    }
    @IBAction func personalBtnPressed(_ sender: UIButton) {
        if personalBtn.isSelected == false {
            personalBtn.isSelected = true
            allCheck()
            termsCheckColorT(checkBtn: personalBtn)
            termsCheckColorT(checkBtn: personalGoBtn)
        }else {
            personalBtn.isSelected = false
            allCheck()
            termsCheckColorF(checkBtn: personalBtn)
            termsCheckColorF(checkBtn: personalGoBtn)
        }
    }
    @IBAction func personalGoBtnPressed(_ sender: UIButton) {
    }
    @IBAction func marketingBtnPressed(_ sender: UIButton) {
        if marketingBtn.isSelected == false {
            marketingBool = true
            marketingBtn.isSelected = true
            allCheck()
            termsCheckColorT(checkBtn: marketingBtn)
            print(marketingBtn.isSelected)
            
        }else {
            marketingBool = false
            marketingBtn.isSelected = false
            allCheck()
            termsCheckColorF(checkBtn: marketingBtn)
            print(marketingBtn.isSelected)
        }
    }
    
    @IBAction func signinBtnPressed(_ sender: UIButton) {
        let id = idTextField.text ?? ""
        let pw = pwCheckTextField.text ?? ""
        let nick = nickNameTextField.text ?? ""
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let marketing = marketingBool
        
        switch checkNum {
        case 0: let check_alert = UIAlertController(title: "실패", message: "아이디, 닉네임 중복 체크를 해주세요", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            check_alert.addAction(okAction)
            present(check_alert, animated: false, completion: nil)
            
        case 1:
            let check_alert = UIAlertController(title: "실패", message: "아이디 중복 체크를 해주세요", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            check_alert.addAction(okAction)
            present(check_alert, animated: false, completion: nil)
            
        case 2:
            let check_alert = UIAlertController(title: "실패", message: "이메일 인증을 완료해주세요", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            check_alert.addAction(okAction)
            present(check_alert, animated: false, completion: nil)
            
        case 3:
            print(name)
            print(nick)
            print(id)
            print(pw)
            print(email)
            print(marketing)
            
                
            let param = SignRequest(user_name: name, user_nick: nick, user_id: id, user_pw: pw,  user_email: email, marketing: marketing)
            postSignin(param)
            
            
        default:
            checkNum = 0
            let check_alert = UIAlertController(title: "실패", message: "회원가입을 다시 시도해주세요", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            check_alert.addAction(okAction)
            present(check_alert, animated: false, completion: nil)
        }
    }
    
    
    //MARK: - INNER FUNC
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
        
        //버튼 색깔셋
        nickBtn.setColor_false(button: nickBtn)
        idBtn.setColor_false(button: idBtn)
        emailBtn.setColor_false(button: emailBtn)
        checkNumBtn.setColor_false(button: checkNumBtn)
        signinBtn.setColor_false(button: signinBtn)
        
        btnHidden(msgBtn: msgIdBtn)
        btnHidden(msgBtn: msgPwBtn)
        btnHidden(msgBtn: msgNickBtn)
        btnHidden(msgBtn: msgCheckNumBtn)
        
        termsBtn.makeImageInset(margin: 8)
        personalBtn.makeImageInset(margin: 8)
        marketingBtn.makeImageInset(margin: 8)
        
        //버튼 활성/비활성 액션
        self.nickNameTextField.addAction(UIAction(handler: { _ in
            if self.nickNameTextField.text?.isEmpty == true {
                self.nickBtn.isEnabled = false
                self.nickBtn.setColor_false(button: self.nickBtn)
                self.btnHidden(msgBtn: self.msgNickBtn)
            } else {
                self.nickBtn.isEnabled = true
                self.nickBtn.setColor_true(button: self.nickBtn)
                
            }
        }), for: .editingChanged)
        
        self.idTextField.addAction(UIAction(handler: { _ in
            if self.idTextField.text?.isEmpty == true {
                self.idBtn.isEnabled = false
                self.idBtn.setColor_false(button: self.idBtn)
                self.btnHidden(msgBtn: self.msgIdBtn)
            } else {
                self.idBtn.isEnabled = true
                self.idBtn.setColor_true(button: self.idBtn)

            }
        }), for: .editingChanged)
        
        self.emailTextField.addAction(UIAction(handler: { _ in
            if self.emailTextField.text?.isEmpty == true {
                self.emailBtn.isEnabled = false
                self.emailBtn.setColor_false(button: self.emailBtn)

            } else {
                self.emailBtn.isEnabled = true
                self.emailBtn.setColor_true(button: self.emailBtn)

            }
        }), for: .editingChanged)
        
        self.checkNumTextField.addAction(UIAction(handler: { _ in
            if self.checkNumTextField.text?.isEmpty == true {
                self.btnHidden(msgBtn: self.msgCheckNumBtn)
                self.checkNumBtn.isEnabled = false
                self.checkNumBtn.setColor_false(button: self.checkNumBtn)
                self.btnHidden(msgBtn: self.msgCheckNumBtn)
            } else {
                self.checkNumBtn.isEnabled = true
                self.checkNumBtn.setColor_true(button: self.checkNumBtn)

            }
        }), for: .editingChanged)
        

    }
    
    //이름 형식 확인
    private func isValidName(testStr: String) -> Bool {
        let nameRegEx = "[가-힣A-Za-z]{2,10}"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: testStr)
    }
    
    //닉네임 형식 확인
    private func isValidNick(testStr: String) -> Bool {
        let nickRegEx = "[가-힣A-Za-z0-9]{2,15}"
        let nickTest = NSPredicate(format:"SELF MATCHES %@", nickRegEx)
        return nickTest.evaluate(with: testStr)
    }
    
    //아이디 형식 확인
    private func isValidID(testStr: String) -> Bool {
        let idRegEx = "[A-Za-z0-9]{5,15}"
        let idTest = NSPredicate(format:"SELF MATCHES %@", idRegEx)
        return idTest.evaluate(with: testStr)
    }
    
    //비밀번호 형식 확인
    private func isValidPW(testStr: String) -> Bool {
        let pwRegEx = "[A-Za-z0-9!_@$%^&+=]{6,15}"
        let pwTest = NSPredicate(format:"SELF MATCHES %@", pwRegEx)
        return pwTest.evaluate(with: testStr)
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
    
    //약관 색깔
    private func termsCheckColorT(checkBtn: UIButton) {
        BarvaLog.debug("termsCheckT")
        checkBtn.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        checkBtn.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
    }
    
    private func termsCheckColorF(checkBtn: UIButton) {
        BarvaLog.debug("termsCheckF")
        checkBtn.tintColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        checkBtn.setTitleColor(UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), for: .normal)
    }
    
    private func allCheck(){
        if (termsBtn.isSelected == true) && (personalBtn.isSelected == true) && (marketingBtn.isSelected == true) {
            termsCheckColorT(checkBtn: allCheckBtn)
        }else {
            termsCheckColorF(checkBtn: allCheckBtn)
        }
    }
    
    //MARK: - POST NICKCHECK
    private func postNickCheck(_ parameters: NickCheckRequest){
        AF.request(BarvaURL.nickCheckURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: NickCheckResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        BarvaLog.debug("PostNickCheck-success")
                        
                        checkNum += 1
                        nickBtn.isUserInteractionEnabled = false
                        nickNameTextField.isUserInteractionEnabled = false
                        
                        btnMessageT(msgBtn: msgNickBtn)
                        msgNickBtn.setTitle("사용가능한 닉네임입니다", for: .normal)
                        
                        let nameCk_alert = UIAlertController(title: "가능", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        nameCk_alert.addAction(okAction)
                        present(nameCk_alert, animated: false, completion: nil)
                        
                    } else {
                        BarvaLog.error("PostNickCheck-fail")
                        btnMessageF(msgBtn: msgNickBtn)
                        print(response.data?.err ?? "")
                        msgNickBtn.setTitle(response.message, for: .normal)
                        let nameCkFail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        nameCkFail_alert.addAction(okAction)
                        present(nameCkFail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    BarvaLog.error("PostNickCheck-err")
                    print(error.localizedDescription)
                    let nameCkFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    nameCkFail_alert.addAction(okAction)
                    present(nameCkFail_alert, animated: false, completion: nil)
                }
            }
    }
    
    //MARK: - POST IDCHECK
    private func postIDCheck(_ parameters: IDCheckRequest){
        AF.request(BarvaURL.idCheckURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: IDCheckResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        BarvaLog.debug("PostIDCheck-success")
                        
                        checkNum += 1
                        idBtn.isUserInteractionEnabled = false
                        idTextField.isUserInteractionEnabled = false
                        
                        
                        btnMessageT(msgBtn: msgIdBtn)
                        msgIdBtn.setTitle("사용가능한 아이디입니다", for: .normal)
                        
                        let idCk_alert = UIAlertController(title: "가능", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        idCk_alert.addAction(okAction)
                        present(idCk_alert, animated: false, completion: nil)
                        
                    } else {
                        BarvaLog.error("PostIDCheck-fail")
                        btnMessageF(msgBtn: msgIdBtn)
                        msgIdBtn.setTitle(response.message, for: .normal)
                        let idCkFail_alert = UIAlertController(title: "중복", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        idCkFail_alert.addAction(okAction)
                        present(idCkFail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    BarvaLog.error("PostIDCheck-err")
                    print(error.localizedDescription)
                    let idCkFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    idCkFail_alert.addAction(okAction)
                    present(idCkFail_alert, animated: false, completion: nil)
                }
            }
    }
    
    
    
    //MARK: - POST AuthMAil
    private func postSendMail(_ parameters: SendMailRequest){
        AF.request(BarvaURL.sendMailURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
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
    
    //MARK: - POST InspectMAil
    private func postInspectMail(_ parameters: InspectMailRequest){
        AF.request(BarvaURL.insepectMailURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: InspectMailResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("PostInspectMAil-success")
                        
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
    
    //MARK: - POST SIGNIN
    private func postSignin(_ parameters: SignRequest){
        AF.request(BarvaURL.signupURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: SigninResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("PostSignin-success")
                        
                        let signin_alert = UIAlertController(title: "성공", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default) {
                            (action) in self.navigationController?.popViewController(animated: true)
                        }
                        signin_alert.addAction(okAction)
                        present(signin_alert, animated: false, completion: nil)
                        
                        
                    } else {
                        BarvaLog.error("PostSignin-fail")
                        print(response.data?.err ?? "")
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        present(fail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    BarvaLog.error("PostSignin-err")
                    print(error.localizedDescription)
                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    present(fail_alert, animated: false, completion: nil)
                }
            }
    }
}

//MARK: - Extension UITextField
extension SigninViewController: UITextFieldDelegate{
    
    private func setTextField() {
        
        self.idTextField.delegate = self
        self.nameTextField.delegate = self
        self.nickNameTextField.delegate = self
        self.pwTextField.delegate = self
        self.pwCheckTextField.delegate = self
        self.emailTextField.delegate = self
        self.checkNumTextField.delegate = self
        
        //텍스트필드 입력값 변경 감지
        self.idTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        self.nameTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        self.nickNameTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        self.pwTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        self.pwCheckTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        self.emailTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        self.checkNumTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
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
        if  !(self.pwTextField.text?.isEmpty ?? true) && !(self.pwCheckTextField.text?.isEmpty ?? true) &&  !(self.nameTextField.text?.isEmpty ?? true)
                && isSameBothTextField(pwTextField, pwCheckTextField) {
            signinBtn.isEnabled = true
            signinBtn.setColor_true(button: signinBtn)
        }
        else {
            signinBtn.isEnabled = false
            signinBtn.setColor_false(button: signinBtn)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField {
            if isValidName(testStr: nameTextField.text ?? "") == false {
                let fail_alert = UIAlertController(title: "실패", message: "이름 형식이 잘못되었습니다\n 한글, 영어 대소문자 사용 2~10자 이내", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "확인", style: .default)
                fail_alert.addAction(okAction)
                present(fail_alert, animated: false, completion: nil)
            }
        }else if textField == pwTextField {
            if isValidPW(testStr: pwTextField.text ?? "") == false {
                let fail_alert = UIAlertController(title: "실패", message: "비밀번호 형식이 잘못되었습니다\n 한글, 영어 대소문자,숫자, !_@$%^&+= 사용 6~15자 이내", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "확인", style: .default)
                fail_alert.addAction(okAction)
                present(fail_alert, animated: false, completion: nil)
            }
        }
    }
}

//MARK: - Extension UIBUTTON
extension UIButton {
  func makeImageInset(margin: CGFloat) {
    let padding = margin / 2
    imageEdgeInsets = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: padding)
    titleEdgeInsets = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: -padding)
    contentEdgeInsets = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding
    )
  }
  
  func setUnderLineButton() {
    guard let title = title(for: .normal) else { return }
    let attributedString = NSMutableAttributedString(string: title)
    attributedString.addAttribute(.underlineStyle,
                                  value: NSUnderlineStyle.single.rawValue,
                                  range: NSRange(location: 0, length: title.count)
    )
    setAttributedTitle(attributedString, for: .normal)
  }
    func setColor_false(button: UIButton) {
        button.setTitleColor(UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1), for: .normal)
        button.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1).cgColor
    }
    
    func setColor_true(button: UIButton) {
        button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1)
    }
    
}
