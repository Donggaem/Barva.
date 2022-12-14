//
//  ChatViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/09/28.
//

import UIKit
import Alamofire
import Kingfisher

class ChatViewController: UIViewController {
    
    @IBOutlet weak var feedUserProfileImg: UIImageView!
    @IBOutlet weak var feedUserNameLabel: UILabel!
    @IBOutlet weak var feedUesrSpecLabel: UILabel!
    @IBOutlet weak var feedUserText: UILabel!
    
    @IBOutlet weak var chatTableView: UITableView!
    
    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var sendTextField: UITextField!
    
    var paramFeedImg = ""
    var paramFeedName = ""
    var paramFeedSpec = ""
    var paramFeedText = ""
    var paramPostid = 0
    
    var chatList: [CommentResult] = []
    //    var reChatList: [String] = ["test7", "test8", "test9", "test10","test11", "test12", "test13"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTable()
        setAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setAPI()
        chatTableView.reloadData()
    }
    
    //MARK: - IBACTION
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func sendBtnPressed(_ sender: UIButton) {
        
        let comment = sendTextField.text ?? ""
        let postid = paramPostid
        
        let param = CommentPostRequest(comment: comment, post_id: postid)
        postComment(param)
        
        sendTextField.text = ""
        
        setAPI()
        
    }
    //MARK: - INNER FUNC
    private func setUI() {
        
        let url = URL(string: paramFeedImg)
        feedUserProfileImg.kf.setImage(with: url)
        
        feedUserNameLabel.text = paramFeedName
        feedUesrSpecLabel.text = paramFeedSpec
        feedUserText.text = paramFeedText
        
        //프사 이미지 둥글게
        feedUserProfileImg.layer.cornerRadius = feedUserProfileImg.frame.height/2
        feedUserProfileImg.clipsToBounds = true
        
        //프사 이미지 둥글게
        userProfileImg.layer.cornerRadius = feedUserProfileImg.frame.height/2
        userProfileImg.clipsToBounds = true
        
    }
    
    private func setAPI() {
        let postid = paramPostid
        let param = CommentListRequest(post_id: postid)
        postCommentList(param)
        
    }
    
    //MARK: - POST COMMENT
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "data")!]
    private func postComment(_ parameters: CommentPostRequest){
        AF.request(BarvaURL.commentPostURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
            .validate()
            .responseDecodable(of: CommentPostResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("postComment - Success")
                        
                        
                    } else {
                        BarvaLog.error("postComment - fail")
                        let loginFail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        loginFail_alert.addAction(okAction)
                        present(loginFail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    BarvaLog.error("postComment - err")
                    print(error.localizedDescription)
                    let loginFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    loginFail_alert.addAction(okAction)
                    present(loginFail_alert, animated: false, completion: nil)
                }
            }
    }
    
    //MARK: - POST COMMENTLIST
    private func postCommentList(_ parameters: CommentListRequest){
        AF.request(BarvaURL.commentListURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
            .validate()
            .responseDecodable(of: CommentListResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("postCommentList - Success")
                        if response.data != nil {
                            
                            if let userProfile = response.data?.profile_url {
                                let url = URL(string: userProfile)
                                userProfileImg.kf.setImage(with: url)
                            }
                            if let commentList = response.data?.commentResult {
                                chatList = commentList
                                chatTableView.reloadData()
                            }
                        }
                        
                    } else {
                        BarvaLog.error("postCommentList - fail")
                        let loginFail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        loginFail_alert.addAction(okAction)
                        present(loginFail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    BarvaLog.error("postCommentList - err")
                    print(error.localizedDescription)
                    let loginFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    loginFail_alert.addAction(okAction)
                    present(loginFail_alert, animated: false, completion: nil)
                }
            }
    }
}

//MARK: - Extension UITableView
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - SET TABLEVIEW
    func setTable() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.reloadData()
        self.chatTableView.register(UINib(nibName: "ChatTableCell", bundle: nil),  forCellReuseIdentifier: "ChatTableViewCell")
        self.chatTableView.register(UINib(nibName: "ReChatTableCell", bundle: nil),  forCellReuseIdentifier: "ReChatTableViewCell")
    }
    
    // MARK: - Row Cell
    
    // 몇개의 Cell을 반환할지 Return하는 메소드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        var chatCount = chatList.count + reChatList.count
        return chatList.count
    }
    
    //각Row에서 해당하는 Cell을 Return하는 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        if indexPath.row % 2 == 0 {
        //            let chatCell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as! ChatTableViewCell
        //            chatCell.chatLabel.text = chatList[indexPath.row]
        //                    return chatCell
        //        }else {
        //            let reChatCell = tableView.dequeueReusableCell(withIdentifier: "ReChatTableViewCell", for: indexPath) as! ReChatTableViewCell
        //
        //            reChatCell.reChatLabel.text = reChatList[indexPath.row]
        //            return reChatCell
        //        }
        //
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as! ChatTableViewCell
        cell.selectionStyle = .none
        cell.nickLabel.text = chatList[indexPath.row].comment_users.user_nick
        let url = URL(string: chatList[indexPath.row].comment_users.profile_url)
        cell.chatProfileImg.kf.setImage(with: url)
        cell.chatLabel.text = chatList[indexPath.row].comment
        return cell
    }
}
