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
    @IBOutlet weak var userNick: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userIntro: UILabel!
    
    @IBOutlet weak var modifyBtn: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getProfile()
        
    }
    
    //MARK: - IBACTION
    
    @IBAction func followerBtnPressed(_ sender: UIButton) {
        let followVC = self.storyboard?.instantiateViewController(withIdentifier: "FollowViewController") as! FollowViewController
        self.navigationController?.pushViewController(followVC, animated: true)
    }
    
    @IBAction func followingBtnPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func modifyBtnPressed(_ sender: UIButton) {
        let modifyVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileModifyViewController") as! ProfileModifyViewController
        self.navigationController?.pushViewController(modifyVC, animated: true)
        
        modifyVC.paramNick = userNick.text ?? ""
        modifyVC.paramIntro = userIntro.text ?? ""
        modifyVC.paramProfileImg = profileImageView.image ?? UIImage()
    }
    
    @IBAction func settingBtnPressed(_ sender: UIButton) {
        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileSettingViewController") as! ProfileSettingViewController
        self.navigationController?.pushViewController(settingVC, animated: true)
        
    }
    
    //MARK: - INNER FUNC
    private func setUI(){
        
        //프사 이미지 둥글게
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        
        //프로필 편집 버튼 조정
        modifyBtn.layer.cornerRadius = 3
        modifyBtn.layer.borderWidth = 1
        modifyBtn.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        
        //프로필 설정 버튼 조정
        settingBtn.layer.cornerRadius = 3
        settingBtn.layer.borderWidth = 1
        settingBtn.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor


        
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
                                    self.userNick.text = nick
                                }else {
                                    self.userNick.text = "이름없음"
                                    
                                }
                                
                                if let intro = response.data?.myProfileInfo?.user_introduce {
                                    print(intro)
                                    self.userIntro.text = intro
                                }else {
                                    self.userIntro.text = ""
                                }
                                
                                if response.data?.myProfileInfo?.profile_url == "" || response.data?.myProfileInfo?.profile_url == nil {
                                    print("기본 이미지")
                                    
                                    self.profileImageView.image = UIImage(systemName: "person.crop.circle")

                                }else {
                                    print("이미지")
                                    print(response.data?.myProfileInfo?.profile_url ?? "")
                                    let url = URL(string: response.data?.myProfileInfo?.profile_url ?? "")
//                                    let url = URL(string: "https://barva-dot.s3.ap-northeast-2.amazonaws.com")
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
