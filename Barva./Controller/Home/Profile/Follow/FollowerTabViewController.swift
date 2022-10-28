//
//  FollowerViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/24.
//

import UIKit
import Alamofire
import Kingfisher

class FollowerTabViewController: UIViewController {


    @IBOutlet weak var followerTableView: UITableView!
    
    var followerList: [FollowerList] = []
    var isMe = false
    var isFollowing = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
        setAPI()
    }
    
    //MARK: - INNER FUNC
    private func setAPI() {
        let nick = UserDefaults.standard.string(forKey: "follownick") ?? ""
        let param = OtherFollowListRequest(user_nick: nick)
        postOtherFollowList(param)

        
        
    }
    
    //MARK: - GET MY FOLLOWER
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "data")!]
    private func getMyFollowerList() {
        AF.request(BarvaURL.myFollowerListURL, method: .get, headers: header)
            .validate()
            .responseDecodable(of: MyFollowerListResponse.self) { [weak self] response in
                guard let self = self else {return}
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        print(BarvaLog.debug("getMyFollowerList-success"))
                        
                        if response.data != nil {
                            if let myFollowerList = response.data?.myFollower {
                                self.followerList = myFollowerList
                                self.followerTableView.reloadData()
                                
                            }
                        }


                    } else {
                        print(BarvaLog.error("getMyFollowerList-fail"))
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        self.present(fail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    print(BarvaLog.error("getMyFollowerList-err"))
                    print("failure: \(error.localizedDescription)")
                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    self.present(fail_alert, animated: false, completion: nil)
                }
            }
    }
    
    //MARK: - POST OTHERFOLLOWLIST
    private func postOtherFollowList(_ parameters: OtherFollowListRequest){
        AF.request(BarvaURL.otherFollowerListURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
            .validate()
            .responseDecodable(of: OtherFollowerListResponse.self) { [weak self] response in
                guard let self = self else {return}
                switch response.result {
                case .success(let response):
                    print(response)
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("postOtherFollowList - Success")
                        
                        self.followerList = response.data?.otherFollowerList ?? []
                        print(self.followerList)
//                        if response.data != nil {
//                            if let otherFollowerList = response.data?.otherFollowerList {
//
//                                self.followerList = otherFollowerList
//                                self.followerTableView.reloadData()
//                                print("ff\(self.followerList)")
//                            }
//                        }else {
//                            print("닐값")
//                        }
                        
                        
                    } else {
                        BarvaLog.error("postOtherFollowList - fail")
                        let loginFail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        loginFail_alert.addAction(okAction)
                        self.present(loginFail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    BarvaLog.error("postOtherFollowList - err")
                    let loginFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    loginFail_alert.addAction(okAction)
                    self.present(loginFail_alert, animated: false, completion: nil)
                }
            }
    }
    
  
}

//MARK: - Extension UITableView
extension FollowerTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    //SET TABLEVIEW
    func setTable() {
        followerTableView.delegate = self
        followerTableView.dataSource = self
        followerTableView.reloadData()
        self.followerTableView.register(UINib(nibName: "FollowTableViewCell", bundle: nil),  forCellReuseIdentifier: "FollowTableViewCell")

    }
    
    // 몇개의 Cell을 반환할지 Return하는 메소드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followerList.count
    }
    
    //각Row에서 해당하는 Cell을 Return하는 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowTableViewCell", for: indexPath) as! FollowTableViewCell
        cell.nameLabel.text = followerList[indexPath.row].follower.user_name
        cell.nickLabel.text = followerList[indexPath.row].follower.user_nick
        
        let url = URL(string: followerList[indexPath.row].follower.profile_url)
        cell.profileImage.kf.setImage(with: url)
        
        if let bool_isMe = followerList[indexPath.row].isMe {
            if bool_isMe == true {
                cell.folowBtn.isHidden = true
            }
        }
        
        if let bool_isFollowing = followerList[indexPath.row].isFollowing {
            
            if bool_isFollowing == true {
                
                cell.folowBtn.setTitle("팔로잉", for: .normal)
                cell.folowBtn.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                cell.folowBtn.backgroundColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1)
                
            }else {
                
                cell.folowBtn.setTitle("팔로우", for: .normal)
                cell.folowBtn.setTitleColor(UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1), for: .normal)
                cell.folowBtn.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                cell.folowBtn.layer.borderColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1).cgColor
            }
        }
        
        return cell
    }
    
    


}
