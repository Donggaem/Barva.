//
//  OthereUserProfileViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/18.
//

import UIKit
import Alamofire

class OtherUserProfileViewController: UIViewController {
    
    
    @IBOutlet weak var otherCheckBoardCollectionView: UICollectionView!
    
    @IBOutlet weak var otherUserProfile: UIImageView!
    @IBOutlet weak var otherUserNick: UILabel!
    @IBOutlet weak var otherUserName: UILabel!
    @IBOutlet weak var otherUserIntro: UILabel!
    

    @IBOutlet weak var count_Post: UILabel!
    @IBOutlet weak var count_Follower: UILabel!
    @IBOutlet weak var count_Following: UILabel!
    
    @IBOutlet weak var followBtn: UIButton!
    
    var paramOtherNick = ""
    
    var OtherCheckboardArray: [String] = []
    
    var followBool = false {
        didSet {
            if followBool == false {
                followBtn.setColor_false(button: followBtn)
            }else {
                followBtn.setColor_true(button: followBtn)
               
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAPI()
        setCollectionView()
    }
    
    //MARK: - INNER FUNC
    private func setUI() {
        
        //프사 이미지 둥글게
        otherUserProfile.layer.cornerRadius = otherUserProfile.frame.height/2
        otherUserProfile.clipsToBounds = true
        
        //팔로우 버튼 조정
        followBtn.layer.cornerRadius = 3
        followBtn.layer.borderWidth = 1
        followBtn.setColor_false(button: followBtn)

    }
    
    private func setAPI() {
        
        //postOtherProfile
        let nick = paramOtherNick
        let param = OtherProfileRequest(user_nick: nick)
        postOtherProfile(param)
        
        //postOtherCheckerboard
        let nick_checkboard = paramOtherNick
        let param_checkboard = OtherCheckboardRequest(user_nick: nick_checkboard)
        postOtherCheckerboard(param_checkboard)
    }
    
    //버튼 비활색
   private func setColor_false(button: UIButton) {
        button.setTitle("팔로우", for: .normal)
        button.setTitleColor(UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1), for: .normal)
        button.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.borderColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1).cgColor
    }
    
    //버튼 활색
   private func setColor_true(button: UIButton) {
        button.setTitle("팔로잉", for: .normal)
        button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1)
    }
    
    //MARK: - IBACTION
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func followerBtnPressed(_ sender: UIButton) {
        let followVC = self.storyboard?.instantiateViewController(withIdentifier: "FollowViewController") as! FollowViewController
        self.navigationController?.pushViewController(followVC, animated: true)
        
        followVC.paramMainOtherNick = otherUserNick.text ?? ""
    }
    
    @IBAction func followingBtnPressed(_ sender: UIButton) {
    }
    
    @IBAction func followBtnPressed(_ sender: UIButton) {
        if followBool == false {
            let nick = otherUserNick.text ?? ""
            let param = AddFollowingRequest(user_nick: nick)
            postAddFollowing(param)
            followBool = true
        }else {
            let nick = otherUserNick.text ?? ""
            let param = CancelFollowingRequest(user_nick: nick)
            postCancelFollowing(param)
            followBool = false
        }
    }
    
    //MARK: - POST OtherProfile
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "data")!]
    private func postOtherProfile(_ parameters: OtherProfileRequest){
        AF.request(BarvaURL.otherProfileURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
            .validate()
            .responseDecodable(of: OtherProfileResponse.self) { [weak self] response in
                guard let self = self else {return}
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        BarvaLog.debug("postOtherProfile - Success")
                        
                        if response.data != nil {
                            if response.data?.otherProfileInfo != nil{
                                
                                self.count_Post.text = String(response.data?.otherProfileInfo?.countPost ?? 0)
                                self.count_Follower.text = String(response.data?.otherProfileInfo?.countFollower ?? 0)
                                self.count_Following.text = String(response.data?.otherProfileInfo?.countFollowing ?? 0)
                                
                                self.otherUserNick.text = response.data?.otherProfileInfo?.user_nick
                                self.otherUserName.text = response.data?.otherProfileInfo?.user_name

                                if let intro = response.data?.otherProfileInfo?.user_introduce {
                                    self.otherUserIntro.text = intro
                                }else {
                                    self.otherUserIntro.text = ""
                                }
                                    
                                if response.data?.otherProfileInfo?.profile_url == "" || response.data?.otherProfileInfo?.profile_url == nil {
                                    
                                    self.otherUserProfile.image = UIImage(systemName: "person.crop.circle")

                                }else {
                                    let url = URL(string: response.data?.otherProfileInfo?.profile_url ?? "")
                                    self.otherUserProfile.kf.setImage(with: url)
                                    
                                }
                            }
                        }else {
                            print("data 옵셔널 에러")
                        }

                        
                    } else {
                        BarvaLog.error("postOtherProfile - fail")
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        self.present(fail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    print("postOtherProfile - 서버err")
                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    self.present(fail_alert, animated: false, completion: nil)
                }
            }
    }
    
    //MARK: - POST ADDFOLLOWING
    private func postAddFollowing(_ parameters: AddFollowingRequest){
        AF.request(BarvaURL.addFollowingURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
            .validate()
            .responseDecodable(of: AddFollowingResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        BarvaLog.debug("postAddFollowing - Success")

                        
                    } else {
                        BarvaLog.error("postAddFollowing - fail")
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        present(fail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    print("postAddFollowing - 서버err")
                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    present(fail_alert, animated: false, completion: nil)
                }
            }
    }
    
    //MARK: - POST CANCELFOLLOWING
    private func postCancelFollowing(_ parameters: CancelFollowingRequest){
        AF.request(BarvaURL.cancelFollowingURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
            .validate()
            .responseDecodable(of: AddFollowingResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        BarvaLog.debug("postCancelFollowing - Success")

                        
                    } else {
                        BarvaLog.error("postCancelFollowing - fail")
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        present(fail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    print("postCancelFollowing - 서버err")
                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    present(fail_alert, animated: false, completion: nil)
                }
            }
    }
    
    //MARK: - POST OTHERCHECKBOARD
    private func postOtherCheckerboard(_ parameters: OtherCheckboardRequest){
        AF.request(BarvaURL.otherCheckboardURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
            .validate()
            .responseDecodable(of: OtherCheckboardResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("postOtherCheckerboard - Success")
                        
                        if response.data != nil {
                            if let imgarry = response.data?.checkerboardArr?.compactMap({$0}) {
                                self.OtherCheckboardArray = imgarry
                                self.otherCheckBoardCollectionView.reloadData()
                                
                            }
                        }
                        
                    } else {
                        BarvaLog.error("postOtherCheckerboard - fail")
                        let loginFail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        loginFail_alert.addAction(okAction)
                        present(loginFail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    BarvaLog.error("postOtherCheckerboard - err")
                    let loginFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    loginFail_alert.addAction(okAction)
                    present(loginFail_alert, animated: false, completion: nil)
                }
            }
    }
}

//MARK: - Extension UICollectionView
extension OtherUserProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // CollectionView 셋팅
    func setCollectionView() {
        self.otherCheckBoardCollectionView.delegate = self
        self.otherCheckBoardCollectionView.dataSource = self
        self.otherCheckBoardCollectionView.register(UINib(nibName: "HomeImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeImageCollectionViewCell")
    }

    // CollectionView item 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return OtherCheckboardArray.count
    }

    // CollectionView Cell의 Object
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeImageCollectionViewCell", for: indexPath) as! HomeImageCollectionViewCell

        let url = URL(string: OtherCheckboardArray[indexPath.row])
        cell.image.kf.setImage(with: url)

        return cell
    }
    
    // CollectionView Cell 터치
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as? HomeImageCollectionViewCell
        
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let feedVC = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
        self.navigationController?.pushViewController(feedVC, animated: true)
        
        feedVC.paramSeletIndex = indexPath.row
        feedVC.paramSort = "Other"
        feedVC.paramUserNick = paramOtherNick
    }

    // CollectionView Cell의 Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width: CGFloat = collectionView.frame.width / 3 - 1.0

        return CGSize(width: width, height: width)
    }

    // CollectionView Cell의 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    // CollectionView Cell의 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}
