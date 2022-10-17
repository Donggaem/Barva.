//
//  ProfileModifyViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/09/02.
//

import UIKit
import Alamofire

class ProfileModifyViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var introTextView: UITextView!
    @IBOutlet weak var setProfileBtn: UIButton!
    
    var paramNick = ""
    var paramIntro = ""
    var paramProfileImg = UIImage()
    
    var setprofileImg = Data()
    
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    //MARK: - IBACTION
    @IBAction func backBtnPressed(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func setProfileBtnPressed(_ sender: UIButton) {
        let intro = introTextView.text ?? ""
        
        let param = ProfileSetIntroRequest(user_introduce: intro)
        postSetProfile(param)
        
        let paramImg = ProfileSetImgRequest(profileImg: setprofileImg)
        postSetProfileImg(paramImg)
        
        let setProfile_alert = UIAlertController(title: "성공", message: " 프로필 수정이 완료 되었습니다", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .default){(action) in self.navigationController?.popViewController(animated: true)
            
        }
        
        setProfile_alert.addAction(okAction)
        present(setProfile_alert, animated: false, completion: nil)
        
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:  - OBJC
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.imagePickerController.delegate = self
        self.imagePickerController.sourceType = .photoLibrary
//        self.imagePickerController.allowsEditing = true
        present(self.imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: - INNER FUNC
    private func setUI() {
        
        nickLabel.text = paramNick
        introTextView.text = paramIntro
        profileImageView.image = paramProfileImg
        
        //프사 이미지 둥글게
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
//        profileImageView.layer.borderWidth = 1
//        profileImageView.layer.borderColor = UIColor.clear.cgColor
        
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true
        
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        //이미지뷰가 상호작용할 수 있게 설정
        profileImageView.isUserInteractionEnabled = true
        //이미지뷰에 제스처인식기 연결
        profileImageView.addGestureRecognizer(tapImageViewRecognizer)
        
        introTextView.layer.borderWidth = 1.0
        introTextView.layer.borderColor = UIColor.black.cgColor
        introTextView.layer.cornerRadius = 5
        
    }
    
    //MARK: - POST SETPROFILE
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "data")!]
    private func postSetProfile(_ parameters: ProfileSetIntroRequest){
        AF.request(BarvaURL.setProfileURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
            .validate()
            .responseDecodable(of: ProfileSetIntroResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("postSetProfile - Success")
//                        let setProfile_alert = UIAlertController(title: "성공", message: response.message, preferredStyle: UIAlertController.Style.alert)
//                        let okAction = UIAlertAction(title: "확인", style: .default)
//                        setProfile_alert.addAction(okAction)
//                        present(setProfile_alert, animated: false, completion: nil)

                        
                    } else {
                        BarvaLog.error("postSetProfile - fail")
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        present(fail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    print("postSetProfile - 서버err")
                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    present(fail_alert, animated: false, completion: nil)
                }
            }
    }
    
    //MARK: - POST SETPRPFILEIMG
    func postSetProfileImg(_ parameters: ProfileSetImgRequest) {
        
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data", "authorization": UserDefaults.standard.string(forKey: "data")!]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            if let image = self.profileImageView.image?.jpegData(compressionQuality: 0.5)! {
                multipartFormData.append(image, withName: "img", fileName: "test.jpeg", mimeType: "image/jpeg")
                self.setprofileImg = image
            }
            		
        }, to: BarvaURL.setProfileImageURL, method: .post, headers: headers).responseDecodable(of: ProfileSetImgResponse.self) { [self] response in
            switch response.result {
            case .success(let response):
                if response.isSuccess == true {
                    BarvaLog.debug("postSetProfileImg-success")

                   
                    
                } else {
                    BarvaLog.error("postSetProfileImg-fail")
                    let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    present(fail_alert, animated: false, completion: nil)
                    
                }
            case .failure(let error):
                BarvaLog.error("postSetProfileImg-err")
                print(error.localizedDescription)
                let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "확인", style: .default)
                fail_alert.addAction(okAction)
                present(fail_alert, animated: false, completion: nil)
                
            }
        }
    }
}

//MARK: - Extension UIImagePicker
extension ProfileModifyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil) //dismiss를 직접 해야함
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
