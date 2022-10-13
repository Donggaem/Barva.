//
//  ProfileTabViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/11.
//

import UIKit
import Alamofire
import Kingfisher

class ProfileTabViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNickLabel: UILabel!
    @IBOutlet weak var profileIntroLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getProfile()
        
    }
    
    //MARK: - OBJC
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let modifyVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileModifyViewController") as! ProfileModifyViewController
        self.navigationController?.pushViewController(modifyVC, animated: true)
        
        modifyVC.paramNick = profileNickLabel.text ?? ""
        modifyVC.paramIntro = profileIntroLabel.text ?? ""
        modifyVC.paramProfileImg = profileImageView.image ?? UIImage()
        
    }
    
    //MARK: - INNER FUNC
    private func setUI(){
        
        //프사 이미지 둥글게
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        
        // 이미지뷰 탭
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        //이미지뷰가 상호작용할 수 있게 설정
        profileImageView.isUserInteractionEnabled = true
        //이미지뷰에 제스처인식기 연결
        profileImageView.addGestureRecognizer(tapImageViewRecognizer)
        
    }
    
    //MARK: - GET PROFILE
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "data")!]
    private func getProfile() {
        AF.request(BarvaURL.profileURL, method: .get, headers: header)
            .validate()
            .responseDecodable(of: ProfileResponse.self) { response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        print(BarvaLog.debug("getProfile-success"))
                        
                        if response.data != nil {
                            if response.data?.myProfileInfo != nil{
                                if let nick = response.data?.myProfileInfo?.user_nick {
                                    print(nick)
                                    self.profileNickLabel.text = nick
                                }
                                
                                if let intro = response.data?.myProfileInfo?.user_introduce {
                                    print(intro)
                                    self.profileIntroLabel.text = intro
                                }else {
                                    self.profileIntroLabel.text = ""
                                }
                                
                                if response.data?.myProfileInfo?.profile_url == "" || response.data?.myProfileInfo?.profile_url == nil {
                                    print("기본 이미지")
                                    
                                    self.profileImageView.image = UIImage(systemName: "person.crop.circle")

                                }else {
                                    print("이미지")
                                    print(response.data?.myProfileInfo?.profile_url ?? "")
//                                    let url = URL(string: response.data?.myProfileInfo?.profile_url ?? "")
                                    let url = URL(string: "https://barva-dot.s3.ap-northeast-2.amazonaws.com")
                                    self.profileImageView.kf.setImage(with: url)
                                    
                                }
                            }
                        }else {
                            print("data 옵셔널 에러")
                        }
                            
                    } else {
                        print(BarvaLog.error("getProfile-fail"))
                        if let fail = response.data?.err{
                            print(fail)
                        }
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        self.present(fail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    BarvaLog.error("PostUpload-err")
                    print(error.localizedDescription)
                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    self.present(fail_alert, animated: false, completion: nil)
                }
            }
    }
}
