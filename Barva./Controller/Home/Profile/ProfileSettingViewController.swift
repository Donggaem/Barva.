//
//  ProfileSettingViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/24.
//

import UIKit
import Alamofire

class ProfileSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true

    }
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func logoutBtnPressed(_ sender: UIButton) {
        
        let logout_alert = UIAlertController(title: "로그아웃", message: "로그아웃을 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "예", style: .default){ (action) in
            
            let storyBoard = UIStoryboard(name: "Login", bundle: nil)
            let loginNav = storyBoard.instantiateViewController(identifier: "LoginNav")
            self.changeRootViewController(loginNav)
            UserDefaults.standard.removeObject(forKey: "data")
            
        }
        
        let noAction = UIAlertAction(title: "아니요", style: .default)
        
        logout_alert.addAction(noAction)
        logout_alert.addAction(okAction)
        
        present(logout_alert, animated: false, completion: nil)
    }
    
    @IBAction func resignBtnPressed(_ sender: UIButton) {
        
        let Resign_alert = UIAlertController(title: "회원탈퇴를 하시겠습니까?", message: "비밀번호를 입력해주세요", preferredStyle: UIAlertController.Style.alert)
        Resign_alert.addTextField { (myTextField) in
            myTextField.isSecureTextEntry = true
        }
        let okAction = UIAlertAction(title: "예", style: .default){ (action) in
                        
            let userpw = Resign_alert.textFields?[0].text ?? ""
            let param = ResignRequest(user_pw: userpw)
            self.postResign(param)
        }
        
        let noAction = UIAlertAction(title: "아니요", style: .default)
        Resign_alert.addAction(okAction)
        Resign_alert.addAction(noAction)
        present(Resign_alert, animated: false, completion: nil)
    }
    
    //MARK: POST RESIGN
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "data")!]
    private func postResign(_ parameters: ResignRequest){
        AF.request(BarvaURL.resignURL, method: .delete, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
            .validate()
            .responseDecodable(of: ResignResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        print(BarvaLog.debug("postResign - success"))
                        
                        let resign_alert = UIAlertController(title: "성공", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default){ (action) in
                            
                            let storyBoard = UIStoryboard(name: "Login", bundle: nil)
                            let loginNav = storyBoard.instantiateViewController(identifier: "LoginNav")
                            self.changeRootViewController(loginNav)
                            UserDefaults.standard.removeObject(forKey: "data")
                        }
                        resign_alert.addAction(okAction)
                        present(resign_alert, animated: false, completion: nil)
                        
                    } else {
                            print(BarvaLog.error("postResign - fail"))
                        let resignFail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        resignFail_alert.addAction(okAction)
                        present(resignFail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    print(BarvaLog.error("postResign - err"))
                    print(error.localizedDescription)
                    
                    let resignFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    resignFail_alert.addAction(okAction)
                    present(resignFail_alert, animated: false, completion: nil)
                }
            }
    }
}
