//
//  MyFollowerTabViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/28.
//

import UIKit
import Alamofire
import Kingfisher

class MyFollowerTabViewController: UIViewController {
    
    @IBOutlet weak var myFollowerTableView: UITableView!
    
    var followerList: [MyFollowerList] = []
    var isFollowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
        getMyFollowerList()
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
                            if let myFollowerList = response.data?.myFollowerResult {
                                self.followerList = myFollowerList
                                self.myFollowerTableView.reloadData()
                                print(self.followerList)
                                
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
    
}

//MARK: - Extension UITableView
extension MyFollowerTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    //SET TABLEVIEW
    func setTable() {
        myFollowerTableView.delegate = self
        myFollowerTableView.dataSource = self
        myFollowerTableView.reloadData()
        self.myFollowerTableView.register(UINib(nibName: "MyFollowTableViewCell", bundle: nil),  forCellReuseIdentifier: "MyFollowTableViewCell")
        
    }
    
    // 몇개의 Cell을 반환할지 Return하는 메소드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followerList.count
    }
    
    //각Row에서 해당하는 Cell을 Return하는 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFollowTableViewCell", for: indexPath) as! MyFollowTableViewCell
        
//        cell.contentView.isUserInteractionEnabled = false
        cell.selectionStyle = .none
        cell.followName.text = followerList[indexPath.row].follower.user_name
        cell.followNick.text = followerList[indexPath.row].follower.user_nick
        
        let url = URL(string: followerList[indexPath.row].follower.profile_url)
        cell.followProfileImg.kf.setImage(with: url)
        
        print("이즈 팔로잉\(followerList[indexPath.row].isFollowing)")
        self.isFollowing = followerList[indexPath.row].isFollowing
        
        if isFollowing == true {
           
            cell.followBtn.layer.borderWidth = 1
            cell.followBtn.setTitle("팔로잉", for: .normal)
            cell.followBtn.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            cell.followBtn.backgroundColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1)
            cell.followBtn.layer.borderColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1).cgColor
            
        }else {
            
            cell.followBtn.layer.borderWidth = 1
            cell.followBtn.setTitle("팔로우", for: .normal)
            cell.followBtn.setTitleColor(UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1), for: .normal)
            cell.followBtn.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            cell.followBtn.layer.borderColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1).cgColor
        }
        
        
        return cell
    }
}

extension MyFollowerTabViewController: FollowBtnAction {
    func followBtnAction(button: UIButton) {
        if isFollowing == true {
           
            button.layer.borderWidth = 1
            button.setTitle("팔로잉", for: .normal)
            button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            button.backgroundColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1)
            button.layer.borderColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1).cgColor
            isFollowing = false
            
        }else {
            
            button.layer.borderWidth = 1
            button.setTitle("팔로우", for: .normal)
            button.setTitleColor(UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1), for: .normal)
            button.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            button.layer.borderColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1).cgColor
            isFollowing = true

        }
    }
    
    
}
