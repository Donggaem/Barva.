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

    @IBOutlet weak var userFeedFagerView: FSPagerView!{
        didSet {
            self.userFeedFagerView.register(UINib(nibName:"UserFeedViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "UserFeedViewCell")
            //아이템 크기설정
            self.userFeedFagerView.itemSize = FSPagerView.automaticSize
            
            //무한 스크롤
            self.userFeedFagerView.isInfinite = false
            self.userFeedFagerView.scrollDirection = .vertical
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
        userFeedFagerView.reloadData()
        
        userFeedFagerView.dataSource = self
        userFeedFagerView.delegate = self
    }
    
    func settest() {
        
    }
    
    //MARK: - GET USERFEED
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "data")!]
    private func getUserFeed() {
        AF.request(BarvaURL.getUserFeedURL, method: .get, headers: header)
            .validate()
            .responseDecodable(of: GetUserFeedResponse.self) { response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        print(BarvaLog.debug("getUserFeed-success"))
                        if response.data != nil {
                            if let feedObject = response.data?.singleResult {
                                self.userFeedArray = feedObject
                                self.userFeedFagerView.reloadData()
                                self.pageControl.numberOfPages = feedObject.count
                                
                                DispatchQueue.main.async {
                                    self.userFeedFagerView.scrollToItem(at: self.pageControl.currentPage, animated: false)
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
                
//        cell.userSpec_Feed.text = "\(userFeedArray[paramSeletIndex].user_gender) | \(userFeedArray[paramSeletIndex].user_tall) | \(userFeedArray[paramSeletIndex])"
        cell.textView_Feed.text = userFeedArray[index].post_content
        cell.paramImg = userFeedArray[index].post_url
        userFeedName = cell.userName_Feed.text ?? ""
        userFeedSpec = cell.userSpec_Feed.text ?? ""
                
        return cell
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
//        print("디드 스크롤\(pagerView.currentIndex)")


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
        chatVC.paramFeedName = userFeedName
        chatVC.paramFeedSpec = userFeedSpec
    }
    
}
