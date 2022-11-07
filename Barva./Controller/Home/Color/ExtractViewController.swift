//
//  ExtractViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/31.
//

import UIKit
import Alamofire

class ExtractViewController: UIViewController {

    @IBOutlet weak var extractCollectionView: UICollectionView!
    @IBOutlet weak var extractImageView: UIImageView!
    
    var extractImageArray: [String] = []
    
    var setColor = "beige"
    var paramRoadCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setCollectionView()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        
        //수정 색을 받아와 이미지 띄우기
        extractImageView.image = UIImage(named: "beage_p")
        
        let color = "beige"
        let param = ColorCheckboardRequest(color_extract: color)
        
        postColorCheckerboard(param)
        
        extractCollectionView.reloadData()
        
//        paramRoadCount += 1
//
//
//
//        if paramRoadCount == 3 {
//
//            extractImageView.image = UIImage(named: "green_p")
//
//            let color = "green"
//            let param = ColorCheckboardRequest(color_extract: color)
//
//            postColorCheckerboard(param)
//
//            extractCollectionView.reloadData()
//        }else {
//
//            extractImageView.image = UIImage(named: "beage_p")
//
//            let color = setColor
//            let param = ColorCheckboardRequest(color_extract: color)
//
//            postColorCheckerboard(param)
//
//            extractCollectionView.reloadData()
//        }
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - POST COLORCHECKBOARD
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "data")!]
    private func postColorCheckerboard(_ parameters: ColorCheckboardRequest){
        AF.request(BarvaURL.colorCheckboardURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
            .validate()
            .responseDecodable(of: ColorCheckboardResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("postColorCheckerboard - Success")
                        
                        if response.data != nil {
                            if let imgarry = response.data?.checkerboardArr?.compactMap({$0}) {
                                self.extractImageArray = imgarry
                                self.extractCollectionView.reloadData()
                                
                            }
                        }
                        
                    } else {
                        BarvaLog.error("postColorCheckerboard - fail")
                        let loginFail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        loginFail_alert.addAction(okAction)
                        present(loginFail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    BarvaLog.error("postColorCheckerboard - err")
                    let loginFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    loginFail_alert.addAction(okAction)
                    present(loginFail_alert, animated: false, completion: nil)
                }
            }
    }
    
}

//MARK: - Extension UICollectionView
extension ExtractViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // CollectionView 셋팅
    func setCollectionView() {
        self.extractCollectionView.reloadData()
        self.extractCollectionView.delegate = self
        self.extractCollectionView.dataSource = self
        self.extractCollectionView.register(UINib(nibName: "HomeImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeImageCollectionViewCell")
    }
    
    // CollectionView item 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return extractImageArray.count
    }
    
    // CollectionView Cell의 Object
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeImageCollectionViewCell", for: indexPath) as! HomeImageCollectionViewCell
                
        let url = URL(string: extractImageArray[indexPath.row])
        cell.image.kf.setImage(with: url)
        
        return cell
    }
    
    // CollectionView Cell 터치
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let cell = collectionView.cellForItem(at: indexPath) as? HomeImageCollectionViewCell
        
        let feedVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
        self.navigationController?.pushViewController(feedVC, animated: true)
        
        feedVC.paramSeletIndex = indexPath.row
        feedVC.paramSort = "Extract"
        feedVC.paramColor = setColor
    }
    
    // CollectionView Cell의 Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = collectionView.frame.width / 3 - 1.0
        
        return CGSize(width: width, height: width)
    }
    
    // CollectionView Cell의 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    // CollectionView Cell의 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}
