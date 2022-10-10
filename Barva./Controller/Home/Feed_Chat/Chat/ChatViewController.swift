//
//  ChatViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/09/28.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var feedUserNameLabel: UILabel!
    @IBOutlet weak var feedUesrSpecLabel: UILabel!
    
    @IBOutlet weak var chatTableView: UITableView!
    var paramFeedName = ""
    var paraFeedSpec = ""
    
    var chatList: [String] = ["test", "test1", "test2", "test3","test4", "test5", "test6"]
    var reChatList: [String] = ["test7", "test8", "test9", "test10","test11", "test12", "test13"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setTable()
    }
    
    //MARK: - IBACTION
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: - INNER FUNC
    private func setUI(){
        feedUserNameLabel.text = paramFeedName
        feedUesrSpecLabel.text = paraFeedSpec
        
        
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - SET TABLEVIEW
    func setTable() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.reloadData()
        self.chatTableView.register(UINib(nibName: "ChatTableCell", bundle: nil),  forCellReuseIdentifier: "ChatTableViewCell")
        self.chatTableView.register(UINib(nibName: "ReChatTableCell", bundle: nil),  forCellReuseIdentifier: "ReChatTableViewCell")
    }

//    // MARK: - Section
//
//    // 몇개의 Cell을 반환할지 Return하는 메소드
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return chatList.count
//    }
//
//    private func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> UITableViewCell {
//        let chatCell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as! ChatTableViewCell
//        chatCell.chatLabel.text = chatList[0]
//        return chatCell
//    }


    // MARK: - Row Cell

    // 몇개의 Cell을 반환할지 Return하는 메소드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var chatCount = chatList.count + reChatList.count
        return 6
    }

    //각Row에서 해당하는 Cell을 Return하는 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let chatCell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as! ChatTableViewCell
            chatCell.chatLabel.text = chatList[indexPath.row]
                    return chatCell
        }else {
            let reChatCell = tableView.dequeueReusableCell(withIdentifier: "ReChatTableViewCell", for: indexPath) as! ReChatTableViewCell
            
            reChatCell.reChatLabel.text = reChatList[indexPath.row]
            return reChatCell
        }
       
    }
}