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
    
    var paramSeletIndex = 0
    var paramSort = ""
    var paramGender = ""
    var paramUserNick = ""
    var paramColor = ""
    
    var feedNick = ""
    var feedSpec = ""
    var feedText = ""
    var feedProfilImg = ""
    var postid = 0
    
    var imgArray: [String] = []
    var feedArray: [FeedArray] = []
    var savePostArray: [SavedPosts] = []
    var stringArray: [String] = []
    
    var sisSave: [Bool] = []
    var sisLike: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedPagerView.dataSource = self
        feedPagerView.delegate = self
        
        setUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    //MARK: - IBACTION
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    //MARK: - INNER FUNC
    private func setUI(){
        feedPagerView.reloadData()
        
        feedPageControl.setStrokeColor(.white, for: .normal)
        feedPageControl.setStrokeColor(.white, for: .selected)
        
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true
        
        if paramSort == "Newest" {
            getNewestFeed()
            feedPagerView.reloadData()
            
        } else if paramSort == "Gender" {
            let gender = paramGender
            let param = GenderSingleRequest(user_gender: gender)
            postGenderFeed(param)
            feedPagerView.reloadData()
            
        } else if paramSort == "Storage" {
            getStorageFeed()
            feedPagerView.reloadData()
            
        } else if paramSort == "Other" {
            let nick = paramUserNick
            let param = OtherSingleRequest(user_nick: nick)
            postOtherFeed(param)
            feedPagerView.reloadData()
        }else if paramSort == "Color" {
            let color = paramColor
            let param = ColorSingleRequest(color_extract: color)
            postColorFeed(param)
        }else if paramSort == "Extract" {
            let color = paramColor
            let param = ColorSingleRequest(color_extract: color)
            postColorFeed(param)
        }
        
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
                        self.feedArray.removeAll()
                        self.feedPagerView.reloadData()
                        if response.data != nil {
                            if let newestFeedObject = response.data?.singleResult {
                                self.feedArray = newestFeedObject
                                self.feedPagerView.reloadData()
                                self.feedPageControl.numberOfPages = newestFeedObject.count
                                
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
    
    //MARK: - POST COLORFEED
    private func postColorFeed(_ parameters: ColorSingleRequest){
        AF.request(BarvaURL.colorSingleURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
            .validate()
            .responseDecodable(of: ColorSingleResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("postColorFeed - Success")
                        self.feedArray.removeAll()
                        self.feedPagerView.reloadData()
                        
                        if response.data != nil {
                            if let colorFeedObject = response.data?.singleResult {
                                self.feedArray = colorFeedObject
                                self.feedPagerView.reloadData()
                                self.feedPageControl.numberOfPages = colorFeedObject.count
                                
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
                        BarvaLog.error("postColorFeed - fail")
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        present(fail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    BarvaLog.error("postColorFeed - err")
                    print(error.localizedDescription)
                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    present(fail_alert, animated: false, completion: nil)
                }
            }
    }
    //MARK: - POST GENDERFEED
    private func postGenderFeed(_ parameters: GenderSingleRequest){
        AF.request(BarvaURL.genderSingleURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
            .validate()
            .responseDecodable(of: GenderSingleResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("postGenderFeed - Success")
                        self.feedArray.removeAll()
                        self.feedPagerView.reloadData()
                        
                        if response.data != nil {
                            if let genderFeedObject = response.data?.singleResult {
                                self.feedArray = genderFeedObject
                                self.feedPagerView.reloadData()
                                self.feedPageControl.numberOfPages = genderFeedObject.count
                                
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
                        BarvaLog.error("postGenderFeed - fail")
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        present(fail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    BarvaLog.error("postGenderFeed - err")
                    print(error.localizedDescription)
                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    present(fail_alert, animated: false, completion: nil)
                }
            }
    }
    
    //MARK: - GET STORAGEFEED
    private func getStorageFeed() {
        AF.request(BarvaURL.savePostSingleURL, method: .get, headers: header)
            .validate()
            .responseDecodable(of: SavePostSingleResponse.self) { [weak self] response in
                guard let self = self else {return}
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        print(BarvaLog.debug("getStorageFeed-success"))
                        self.feedArray.removeAll()
                        self.feedPagerView.reloadData()
                        if response.data != nil {
                            if let storageFeedObject = response.data?.singleArr{
                                self.savePostArray = storageFeedObject
                                for index in 0..<self.savePostArray.count {
                                    self.feedArray.append(self.savePostArray[index].saved_posts)
                                    self.sisSave.append(self.savePostArray[index].isSave)
                                    self.sisLike.append(self.savePostArray[index].isLike)
                                    
                                }
                                self.feedPagerView.reloadData()
                                self.feedPageControl.numberOfPages = storageFeedObject.count
                                
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
                        print(BarvaLog.error("getStorageFeed-fail"))
                        
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        self.present(fail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    BarvaLog.error("getStorageFeed-err")
                    print(error.localizedDescription)
                    
                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    self.present(fail_alert, animated: false, completion: nil)
                }
            }
    }
    
    //MARK: - POST OTHERFEED
    private func postOtherFeed(_ parameters: OtherSingleRequest){
        AF.request(BarvaURL.otherSingleURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
            .validate()
            .responseDecodable(of: OtherSingleResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("postOtherFeed - Success")
                        self.feedArray.removeAll()
                        self.feedPagerView.reloadData()
                        
                        if response.data != nil {
                            if let otherFeedObject = response.data?.singleResult {
                                self.feedArray = otherFeedObject
                                self.feedPagerView.reloadData()
                                self.feedPageControl.numberOfPages = otherFeedObject.count
                                
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
                        BarvaLog.error("postOtherFeed - fail")
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        present(fail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    BarvaLog.error("postOtherFeed - err")
                    print(error.localizedDescription)
                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    present(fail_alert, animated: false, completion: nil)
                }
            }
    }
    
    
    //MARK: - POST SAVEPOST
    private func postSavePost(_ parameters: SavePostRequest){
        AF.request(BarvaURL.savePostURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
            .validate()
            .responseDecodable(of: SavePostResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("postSavePost - Success")
                        let succedd_alert = UIAlertController(title: "저장완료", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        succedd_alert.addAction(okAction)
                        present(succedd_alert, animated: false, completion: nil)
                        
                        
                    } else {
                        BarvaLog.error("postSavePost - fail")
                        
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        present(fail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    BarvaLog.error("postSavePost - err")
                    print(error.localizedDescription)
                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    present(fail_alert, animated: false, completion: nil)
                }
            }
    }
    
    //MARK: - POST CANCELSAVEPOST
    private func postCancelSavePost(_ parameters: CancelSavePostRequest){
        AF.request(BarvaURL.cancelSavePostURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
            .validate()
            .responseDecodable(of: CancelSavePostResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("postCancelSavePost - Success")
                        let succedd_alert = UIAlertController(title: "취소완료", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        succedd_alert.addAction(okAction)
                        present(succedd_alert, animated: false, completion: nil)
                        
                        
                    } else {
                        BarvaLog.error("postCancelSavePost - fail")
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        present(fail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    BarvaLog.error("postCancelSavePost - err")
                    print(error.localizedDescription)
                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    present(fail_alert, animated: false, completion: nil)
                }
            }
    }
    
    //MARK: - POST LIKEPOST
    func postLikePost(_ parameters: LikePostRequest) {
        AF.request(BarvaURL.likePostURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
            .validate()
            .responseDecodable(of: LikePostResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("postLikePost - Success")
                        
                    } else {
                        BarvaLog.error("postLikePost - fail")
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        present(fail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    BarvaLog.error("postLikePost - err")
                    print(error.localizedDescription)
                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    present(fail_alert, animated: false, completion: nil)
                }
            }
    }
    
    //MARK: - POST CENCELLIKEPOST
    func postCencelLikePost(_ parameters: CencelLikePostRequest) {
        AF.request(BarvaURL.cancelLikePostURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
            .validate()
            .responseDecodable(of: CencelLikePostResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("postCencelLikePost - Success")
                        
                        
                    } else {
                        BarvaLog.error("postCencelLikePost - fail")
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        present(fail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    BarvaLog.error("postCencelLikePost - err")
                    print(error.localizedDescription)
                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    present(fail_alert, animated: false, completion: nil)
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
        cell.feedText.text = feedArray[index].post_content
        
        stringArray = feedArray[index].created_at.components(separatedBy: "T")
        cell.feedDay.text = stringArray[0]
        
        cell.paramImg = feedArray[index].post_url
        cell.pageControl.numberOfPages = feedArray[index].post_url.count
        cell.bookmarkBool = feedArray[index].isSave ?? false
        
        cell.likeBool = feedArray[index].isLike ?? false
        cell.heartCount.text = String(feedArray[index].likeCount)
        cell.heartIntCount = feedArray[index].likeCount
        
        if paramSort == "Storage" {
            //영상용, 개인 저장피드에 좋아요와 북마크 표시가 안됌
            cell.likeBool = sisLike[index]
            cell.bookmarkBool = sisSave[index]
        }
        
        
        feedNick = feedArray[index].post_users.user_nick
        feedSpec = "\(feedArray[index].user_gender) | \(feedArray[index].user_tall)cm | \(feedArray[index].user_weight)kg"
        feedText = feedArray[index].post_content
        feedProfilImg = feedArray[index].post_users.profile_url
        
        //postid 값 받기
        postid = feedArray[index].post_id
        
        return cell
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.feedPageControl.currentPage = targetIndex
    }
}

//MARK: - Extension NaviAction
extension FeedViewController: NaviAction {
    func checkLike(like: Bool) {
        if like == false {
            let postid = postid
            let param = LikePostRequest(post_id: postid)
            postLikePost(param)
        }else {
            let postid = postid
            let param = CencelLikePostRequest(post_id: postid)
            postCencelLikePost(param)
        }
    }
    
    
    func checkBookmark(bookmark: Bool) {
        if bookmark == false {
            let postid = postid
            let param = SavePostRequest(post_id: postid)
            postSavePost(param)
            
        }else {
            let postid = postid
            let param = CancelSavePostRequest(post_id: postid)
            postCancelSavePost(param)
        }
    }
    
    func moveChatVC() {
        
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let chatVC = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        self.navigationController?.pushViewController(chatVC, animated: true)
        chatVC.paramFeedName = feedNick
        chatVC.paramFeedSpec = feedSpec
        chatVC.paramFeedImg = feedProfilImg
        chatVC.paramFeedText = feedText
        chatVC.paramPostid = postid
    }
    
    func moveOtherVC() {
        let storyBoard = UIStoryboard(name: "ProfileTab", bundle: nil)
        let otherVC = storyBoard.instantiateViewController(withIdentifier: "OtherUserProfileViewController") as! OtherUserProfileViewController
        self.navigationController?.pushViewController(otherVC, animated: true)
        
        otherVC.paramOtherNick = feedNick
    }
    
    
    
}
