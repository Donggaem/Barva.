//
//  MyFollowingTabViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/28.
//

import UIKit
import Alamofire
import Kingfisher

class MyFollowingTabViewController: UIViewController {
    
    @IBOutlet weak var myFollowingTableView: UITableView!
    
    var followingList: [MyFollowingList] = []
    var isFollowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
        getMyFollowingList()
    }
    
    //MARK: - GET MY FOLLOWING
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "data")!]
    private func getMyFollowingList() {
        AF.request(BarvaURL.myFollowingListURL, method: .get, headers: header)
            .validate()
            .responseDecodable(of: MyFollowingListResponse.self) { [weak self] response in
                guard let self = self else {return}
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        print(BarvaLog.debug("getMyFolloweingList-success"))
                        
                        if response.data != nil {
                            if let myFollowingList = response.data?.myFollowingResult {
                                self.followingList = myFollowingList
                                self.myFollowingTableView.reloadData()
                            }
                        }
                        
                        
                    } else {
                        print(BarvaLog.error("getMyFolloweingList-fail"))
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        self.present(fail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    print(BarvaLog.error("getMyFolloweingList-err"))
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
extension MyFollowingTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    //SET TABLEVIEW
    func setTable() {
        myFollowingTableView.delegate = self
        myFollowingTableView.dataSource = self
        myFollowingTableView.reloadData()
        self.myFollowingTableView.register(UINib(nibName: "MyFollowTableViewCell", bundle: nil),  forCellReuseIdentifier: "MyFollowTableViewCell")
        
    }
    
    // 몇개의 Cell을 반환할지 Return하는 메소드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followingList.count
    }
    
    //각Row에서 해당하는 Cell을 Return하는 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFollowTableViewCell", for: indexPath) as! MyFollowTableViewCell
        
        //        cell.contentView.isUserInteractionEnabled = false
        cell.selectionStyle = .none
        cell.followName.text = followingList[indexPath.row].following.user_name
        cell.followNick.text = followingList[indexPath.row].following.user_nick
        
        let url = URL(string: followingList[indexPath.row].following.profile_url)
        cell.followProfileImg.kf.setImage(with: url)
        
        self.isFollowing = followingList[indexPath.row].isFollowing
        
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
