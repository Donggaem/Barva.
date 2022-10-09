//
//  ProfileTabViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/11.
//

import UIKit
import Alamofire

class ProfileTabViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
//        getProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    //MARK: - OBJC
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let modifyVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileModifyViewController") as! ProfileModifyViewController
        self.navigationController?.pushViewController(modifyVC, animated: true)
    }
    
    //MARK: - INNER FUNC
    private func setUI(){
        
        // 이미지뷰 탭
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        //이미지뷰가 상호작용할 수 있게 설정
        profileImageView.isUserInteractionEnabled = true
        //이미지뷰에 제스처인식기 연결
        profileImageView.addGestureRecognizer(tapImageViewRecognizer)
    }
    
//    //MARK: - GET PROFILE
//    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "data")!]
//    private func getProfile() {
//        AF.request(BarvaURL.profileURL, method: .get, headers: header)
//            .validate()
//            .responseDecodable(of: ProfileResponse.self) { response in
//                switch response.result {
//                case .success(let response):
//                    if response.isSuccess == true {
//                        print(BarvaLog.debug("getProfile-Success"))
//
//
//
//                    } else {
//                        print(BarvaLog.error("getProfile-fail"))
//                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
//                        let okAction = UIAlertAction(title: "확인", style: .default)
//                        fail_alert.addAction(okAction)
//                        self.present(fail_alert, animated: false, completion: nil)
//                    }
//                case .failure(let error):
//                    print(BarvaLog.error("getProfile-서버err"))
//                    print("failure: \(error.localizedDescription)")
//                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
//                    let okAction = UIAlertAction(title: "확인", style: .default)
//                    fail_alert.addAction(okAction)
//                    self.present(fail_alert, animated: false, completion: nil)
//                }
//            }
//    }
}
