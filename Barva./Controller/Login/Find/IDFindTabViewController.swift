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
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTextField()
    }
    
    //MARK: OBJC
    //텍스트 필드 입력값 변하면 유효성 검사
    @objc func TFdidChanged(_ sender: UITextField) {
        
        //2개 텍스트필드가 채워졌는지, 비밀번호가 일치하는 지 확인.
        if !(self.idTextField.text?.isEmpty ?? true) && !(self.emailTextField.text?.isEmpty ?? true) {
            idFindBtn(willActive: true)
        }
        else {
            
            idFindBtn(willActive: false)
        }
        
    }
    
    //MARK: INNER FUNC
    private func setUI() {
        
        //버튼 모서리
        idFindBtn.layer.cornerRadius = 5
        
    }
    
    //버튼 활성화/비활성화
    func idFindBtn(willActive: Bool) {
        
        if(willActive == true) {
            //다음 버튼 색 변경
            idFindBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            //다음 버튼 색 변경
            idFindBtn.backgroundColor = UIColor(red: 0.733, green: 0.733, blue: 0.733, alpha: 1)
        }
    }
    
    //MARK: POST IDFIND
    private func postIDFind(_ parameters: IDFindRequest){
        AF.request(BarvaURL.idFindURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: IDFindResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("postIDFind")
                        let Find_alert = UIAlertController(title: "성공", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        Find_alert.addAction(okAction)
                        present(Find_alert, animated: false, completion: nil)
                        
                        
                    } else {
                        BarvaLog.error("postIDFind")
                        let Fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        Fail_alert.addAction(okAction)
                        present(Fail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    BarvaLog.error("postIDFind")
                    print(error.localizedDescription)
                    let Fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    Fail_alert.addAction(okAction)
                    present(Fail_alert, animated: false, completion: nil)
                }
            }
    }
}

//MARK: UITextFiel
extension IDFindTabViewController: UITextFieldDelegate {
    
    private func setTextField() {
        self.idTextField.delegate = self
        self.emailTextField.delegate = self
        
        //텍스트필드 입력값 변경 감지
        self.idTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        self.emailTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        
    }
}
