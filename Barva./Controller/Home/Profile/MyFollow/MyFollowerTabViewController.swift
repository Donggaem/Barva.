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
        getMyFollowerList()
        setTable()
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
                                self.myFollowerTableView.reloadData()
                                
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowTableViewCell", for: indexPath) as! FollowTableViewCell
        cell.nameLabel.text = followerList[indexPath.row].follower.user_name
        cell.nickLabel.text = followerList[indexPath.row].follower.user_nick
        
        let url = URL(string: followerList[indexPath.row].follower.profile_url)
        cell.profileImage.kf.setImage(with: url)
        
        self.isFollowing = followerList[indexPath.row].isFollowing
        
        if isFollowing == true {
            
            cell.folowBtn.setTitle("팔로잉", for: .normal)
            cell.folowBtn.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            cell.folowBtn.backgroundColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1)
            
        }else {
            
            cell.folowBtn.setTitle("팔로우", for: .normal)
            cell.folowBtn.setTitleColor(UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1), for: .normal)
            cell.folowBtn.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            cell.folowBtn.layer.borderColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1).cgColor
        }
        
        
        return cell
    }
}
