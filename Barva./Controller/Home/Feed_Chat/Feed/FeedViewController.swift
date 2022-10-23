//
//  FeedViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/09/28.
//

import UIKit
import FSPagerView
import Alamofire


class FeedViewController: UIViewController {
    

    @IBOutlet weak var feedPagerView: FSPagerView!{
        didSet {
            self.feedPagerView.register(UINib(nibName:"FeedViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "FeedViewCell")
            //아이템 크기설정
            self.feedPagerView.itemSize = FSPagerView.automaticSize
            
            //무한 스크롤
            self.feedPagerView.isInfinite = false
            self.feedPagerView.scrollDirection = .vertical
        }
    }
    
    @IBOutlet weak var feedPageControl: FSPageControl!{
        didSet {
            self.feedPageControl.currentPage = self.paramSeletIndex
        }
    }
    
    var paramImg = ""
    var paramSeletIndex = 0
    var paramSort = ""
    
    var feedName = ""
    var feedSpec = ""
    var feedText = ""
    var feedProfilImg = ""
    
    var imgArray: [String] = []
    var feedArray: [FeedArray] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        feedPagerView.dataSource = self
        feedPagerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
                
        if paramSort == "Newest" {
            getNewestFeed()
        }
        
    }
    
    //MARK: - IBACTION
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: - INNER FUNC
    private func setUI(){
        
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true
        

    }
    
    //MARK: - GET NEWESTFEED
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "data")!]
    private func getNewestFeed() {
        AF.request(BarvaURL.newestSingleURL, method: .get, headers: header)
            .validate()
            .responseDecodable(of: NewestSingleResponse.self) { response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        print(BarvaLog.debug("getNewestFeed-success"))
                        if response.data != nil {
                            if let feedObject = response.data?.singleResult {
                                self.feedArray = feedObject
                                self.feedPagerView.reloadData()
                                self.feedPageControl.numberOfPages = feedObject.count
                                
                                DispatchQueue.main.async {
                                    
                                    self.feedPagerView.reloadData()
                                    self.feedPageControl.numberOfPages = self.feedArray.count
                                    self.feedPageControl.currentPage = self.paramSeletIndex
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.03){
                                        self.feedPagerView.scrollToItem(at: self.feedPageControl.currentPage, animated: false)
                                    }
                                    
                                }
                            }
                        }

                    } else {
                        print(BarvaLog.error("getNewestFeed-fail"))

                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        self.present(fail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    BarvaLog.error("getNewestFeed-err")
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
extension FeedViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    
    //이미지 갯수
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return feedArray.count
    }
    
    //각셀의 대한 설정
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "FeedViewCell", at: index) as! FeedViewCell
        
        cell.contentView.isUserInteractionEnabled = false
        cell.delegate = self
        cell.feedImage.reloadData()
        
        let url = URL(string: feedArray[index].post_users.profile_url)
        cell.feedProfileImg.kf.setImage(with: url)
        
        cell.feedNameLabel.text = feedArray[index].post_users.user_nick
        cell.feedSpecLabel.text = "\(feedArray[index].user_gender) | \(feedArray[index].user_tall)cm | \(feedArray[index].user_weight)kg"
        cell.feedTextView.text = feedArray[index].post_content
        cell.paramImg = feedArray[index].post_url
        
        feedName = feedArray[index].post_users.user_nick
        feedSpec = "\(feedArray[index].user_gender) | \(feedArray[index].user_tall)cm | \(feedArray[index].user_weight)kg"
        feedText = feedArray[index].post_content
        feedProfilImg = feedArray[index].post_users.profile_url
        
        return cell
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        print("피드드래깅 \(targetIndex), \(pagerView.currentIndex)")
        self.feedPageControl.currentPage = targetIndex
    }
}

//MARK: - Extension NaviAction
extension FeedViewController: NaviAction {
    func moveChatVC() {
        
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let chatVC = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        self.navigationController?.pushViewController(chatVC, animated: true)
        chatVC.paramFeedName = feedName
        chatVC.paramFeedSpec = feedSpec
        chatVC.paramFeedImg = feedProfilImg
        chatVC.paramFeedText = feedText
    }
    
    func moveOthereVC() {
        let storyBoard = UIStoryboard(name: "ProfileTab", bundle: nil)
        let othereVC = storyBoard.instantiateViewController(withIdentifier: "OthereUserProfileViewController") as! OthereUserProfileViewController
        self.navigationController?.pushViewController(othereVC, animated: true)
    }
    
}
