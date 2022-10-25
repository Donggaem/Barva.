//
//  UserFeedViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/21.
//

import UIKit
import FSPagerView
import Alamofire

class UserFeedViewController: UIViewController{
    
    @IBOutlet weak var userFeedPagerView: FSPagerView!{
        didSet {
            self.userFeedPagerView.register(UINib(nibName:"UserFeedViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "UserFeedViewCell")
            //아이템 크기설정
            self.userFeedPagerView.itemSize = FSPagerView.automaticSize
            
            //무한 스크롤
            self.userFeedPagerView.isInfinite = false
            self.userFeedPagerView.scrollDirection = .vertical
        }
    }
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            self.pageControl.currentPage = self.paramSeletIndex
        }
    }
    
    
    var paramSeletIndex = 0
    
    var userFeedName = ""
    var userFeedSpec = ""
    var userFeedText = ""
    var userFeedProfilImg = ""
    
    var imgArray: [String] = []
    var userFeedArray: [FeedArray] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        getUserFeed()

    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: - INNER FUNC
    private func setUI(){
        
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true
        userFeedPagerView.reloadData()
        
        userFeedPagerView.dataSource = self
        userFeedPagerView.delegate = self
    }
    
    
    //MARK: - GET USERFEED
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "data")!]
    private func getUserFeed() {
        AF.request(BarvaURL.userSingleURL, method: .get, headers: header)
            .validate()
            .responseDecodable(of: UserSingleResponse.self) { response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        print(BarvaLog.debug("getUserFeed-success"))
                        if response.data != nil {
                            if let feedObject = response.data?.singleResult {
                                self.userFeedArray = feedObject
                                self.userFeedPagerView.reloadData()
                                self.pageControl.numberOfPages = feedObject.count
                                
                                DispatchQueue.main.async {
                                    
                                    self.userFeedPagerView.reloadData()
                                    self.pageControl.numberOfPages = self.userFeedArray.count
                                    self.pageControl.currentPage = self.paramSeletIndex
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.03){
                                        self.userFeedPagerView.scrollToItem(at: self.pageControl.currentPage, animated: false)
                                    }
                                }
                            }
                        }
                        
                    } else {
                        print(BarvaLog.error("getUserFeed-fail"))
                        
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        self.present(fail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    BarvaLog.error("getUserFeed-err")
                    print(error.localizedDescription)
                    
                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    self.present(fail_alert, animated: false, completion: nil)
                }
            }
    }
    
}

//MARK: - Extension FSPagerView
extension UserFeedViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    
    //이미지 갯수
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return userFeedArray.count
    }
    
    //각셀의 대한 설정
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "UserFeedViewCell", at: index) as! UserFeedViewCell
        
        cell.contentView.isUserInteractionEnabled = false
        cell.delegate = self
        cell.userFeedImg.reloadData()
        
        let url = URL(string: userFeedArray[index].post_users.profile_url)
        cell.userImg_Feed.kf.setImage(with: url)
        
        cell.userName_Feed.text = userFeedArray[index].post_users.user_nick
        cell.userSpec_Feed.text = "\(userFeedArray[index].user_gender) | \(userFeedArray[index].user_tall)cm | \(userFeedArray[index].user_weight)kg"
        cell.userFeedText.text = userFeedArray[index].post_content
        cell.paramImg = userFeedArray[index].post_url
        
        userFeedName = userFeedArray[index].post_users.user_nick
        userFeedSpec = "\(userFeedArray[index].user_gender) | \(userFeedArray[index].user_tall)cm | \(userFeedArray[index].user_weight)kg"
        userFeedText = userFeedArray[index].post_content
        userFeedProfilImg = userFeedArray[index].post_users.profile_url
        
        return cell
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        //        print("드래깅 \(targetIndex), \(pagerView.currentIndex)")
        self.pageControl.currentPage = targetIndex
    }
    
}

//MARK: - Extension NaviAction
extension UserFeedViewController: UserFeedNaviAction {
    func moveChatVC() {
        
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let chatVC = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        self.navigationController?.pushViewController(chatVC, animated: true)
        
        chatVC.paramFeedImg = userFeedProfilImg
        chatVC.paramFeedName = userFeedName
        chatVC.paramFeedSpec = userFeedSpec
        chatVC.paramFeedText = userFeedText
    }
    
}
