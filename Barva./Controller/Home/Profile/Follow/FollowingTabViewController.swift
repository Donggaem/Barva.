//
//  FollowingViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/24.
//

import UIKit
import Alamofire
import Kingfisher

class FollowingTabViewController: UIViewController {

    @IBOutlet weak var followingTableView: UITableView!
    
    var followingList: [OtherFollowingList] = []
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
        let param = OtherFollowingListRequest(user_nick: nick)
        postOtherFollowingList(param)
        
    }
    
    //MARK: - POST OTHERFOLLOWING LIST
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "data")!]
    private func postOtherFollowingList(_ parameters: OtherFollowingListRequest){
        AF.request(BarvaURL.otherFollowingListURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
            .validate()
            .responseDecodable(of: OtherFollowingListResponse.self) { [weak self] response in
                guard let self = self else {return}
                switch response.result {
                case .success(let response):
                    print(response)
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("postOtherFollowingList - Success")
                        
                        if response.data != nil {
                            if let otherFollowingList = response.data?.otherFollowingResult {

                                self.followingList = otherFollowingList
                                self.followingTableView.reloadData()
                                print(self.followingList)

                            }
                        }else {
                            print("닐값")
                        }
                        
                        
                    } else {
                        BarvaLog.error("postOtherFollowingList - fail")
                        let loginFail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        loginFail_alert.addAction(okAction)
                        self.present(loginFail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    BarvaLog.error("postOtherFollowingList - err")
                    let loginFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    loginFail_alert.addAction(okAction)
                    self.present(loginFail_alert, animated: false, completion: nil)
                }
            }
    }
    
  
}

//MARK: - Extension UITableView
extension FollowingTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    //SET TABLEVIEW
    func setTable() {
        followingTableView.delegate = self
        followingTableView.dataSource = self
        followingTableView.reloadData()
        self.followingTableView.register(UINib(nibName: "FollowTableViewCell", bundle: nil),  forCellReuseIdentifier: "FollowTableViewCell")

    }
    
    // 몇개의 Cell을 반환할지 Return하는 메소드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followingList.count
    }
    
    //각Row에서 해당하는 Cell을 Return하는 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowTableViewCell", for: indexPath) as! FollowTableViewCell
        
        cell.selectionStyle = .none
        cell.nameLabel.text = followingList[indexPath.row].following.user_name
        cell.nickLabel.text = followingList[indexPath.row].following.user_nick
        
        let url = URL(string: followingList[indexPath.row].following.profile_url)
        cell.profileImage.kf.setImage(with: url)
        
        if let bool_isMe = followingList[indexPath.row].isMe {
            if bool_isMe == true {
                cell.folowBtn.isHidden = true
            }
        }
        
        if let bool_isFollowing = followingList[indexPath.row].isFollowing {
            
            if bool_isFollowing == true {
                
                cell.folowBtn.layer.borderWidth = 1
                cell.folowBtn.setTitle("팔로잉", for: .normal)
                cell.folowBtn.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                cell.folowBtn.backgroundColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1)
                cell.folowBtn.layer.borderColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1).cgColor
                
            }else {
                
                cell.folowBtn.layer.borderWidth = 1
                cell.folowBtn.setTitle("팔로우", for: .normal)
                cell.folowBtn.setTitleColor(UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1), for: .normal)
                cell.folowBtn.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                cell.folowBtn.layer.borderColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1).cgColor
            }
        }
        
        return cell
    }
    
    


}

