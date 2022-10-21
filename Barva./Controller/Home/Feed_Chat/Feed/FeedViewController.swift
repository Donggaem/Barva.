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
    
    var paramImg = ""
    var paramSeletIndex = 0
    var feedName = ""
    var feedSpec = ""
    var imgArray: [String] = []
    var feedArray: [FeedArray] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        feedPagerView.dataSource = self
        feedPagerView.delegate = self
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
    
//    //MARK: - GET FEED
//    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "data")!]
//    private func getFeed() {
//        AF.request(BarvaURL.getFeedURL, method: .get, headers: header)
//            .validate()
//            .responseDecodable(of: GetFeedPesponse.self) { response in
//                switch response.result {
//                case .success(let response):
//                    if response.isSuccess == true {
//                        print(BarvaLog.debug("getFeed-success"))
//                        if response.data != nil {
//                            if let feedObject = response.data?.singleResult {
//                                self.feedArray = feedObject
//                            }
//                        }
//
//                    } else {
//                        print(BarvaLog.error("getFeed-fail"))
//
//                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
//                        let okAction = UIAlertAction(title: "확인", style: .default)
//                        fail_alert.addAction(okAction)
//                        self.present(fail_alert, animated: false, completion: nil)
//                    }
//                case .failure(let error):
//                    BarvaLog.error("getFeed-err")
//                    print(error.localizedDescription)
//
//                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
//                    let okAction = UIAlertAction(title: "확인", style: .default)
//                    fail_alert.addAction(okAction)
//                    self.present(fail_alert, animated: false, completion: nil)
//                }
//            }
//    }
    
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
//        cell.feedImage.image = UIImage(named: paramImg)
//        feedName = cell.feedNameLabel.text ?? ""
//        feedSpec = cell.feedSpecLabel.text ?? ""
        
        cell.paramImg = ["common","common (1)"]
        
        return cell
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        print(pagerView.currentIndex)
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
    }
    
    func moveOthereVC() {
        let storyBoard = UIStoryboard(name: "ProfileTab", bundle: nil)
        let othereVC = storyBoard.instantiateViewController(withIdentifier: "OthereUserProfileViewController") as! OthereUserProfileViewController
        self.navigationController?.pushViewController(othereVC, animated: true)
    }
    
}
