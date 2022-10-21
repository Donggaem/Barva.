//
//  MyUpTabViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/31.
//

import UIKit
import Alamofire

class MyUpTabViewController: UIViewController {
    
    @IBOutlet weak var myUpCollectionView: UICollectionView!
    
    var userCheckerBoardArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        getuserCheckerBoard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getuserCheckerBoard()
        setCollectionView()
    }
    
    //MARK: - GET MYUPIMAGES
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "data")!]
    private func getuserCheckerBoard() {
        AF.request(BarvaURL.yourCheckerBoardURL, method: .get, headers: header)
            .validate()
            .responseDecodable(of: UserCheckerBoardResponse.self) { [weak self] response in
                guard let self = self else {return}
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        print(BarvaLog.debug("getMyUpImages-success"))
                        //                        print(response.data?.checkerboardArr)
                        //                        self.latestImageArray = response.data?.checkerboardArr?.compactMap{$0} ?? []
                        
                        if response.data != nil {
                            if let imgarry = response.data?.checkerboardArr?.compactMap({$0}) {
                                self.userCheckerBoardArray = imgarry
                                self.myUpCollectionView.reloadData()
                                
                            }
                        }


                    } else {
                        print(BarvaLog.error("getMyUpImages-fail"))
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        self.present(fail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    print(BarvaLog.error("getMyUpImages-err"))
                    print("failure: \(error.localizedDescription)")
                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    self.present(fail_alert, animated: false, completion: nil)
                }
            }
    }
    
}

//MARK: - Extension UICollectionView
extension MyUpTabViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // CollectionView 셋팅
    func setCollectionView() {
        self.myUpCollectionView.reloadData()
        self.myUpCollectionView.delegate = self
        self.myUpCollectionView.dataSource = self
        self.myUpCollectionView.register(UINib(nibName: "HomeImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeImageCollectionViewCell")
    }

    // CollectionView item 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userCheckerBoardArray.count
    }

    // CollectionView Cell의 Object
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeImageCollectionViewCell", for: indexPath) as! HomeImageCollectionViewCell

//        cell.image.image = UIImage(named: myUpImageArray[indexPath.row]) ?? UIImage()

        //킹피셔로 이미지 띄우기
        let url = URL(string: userCheckerBoardArray[indexPath.row])
        cell.image.kf.setImage(with: url)
        
        return cell
    }
    
    // CollectionView Cell 터치
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as? HomeImageCollectionViewCell
        
        let feedVC = self.storyboard?.instantiateViewController(withIdentifier: "UserFeedViewController") as! UserFeedViewController
        self.navigationController?.pushViewController(feedVC, animated: true)
        
        print(indexPath.row)
        feedVC.paramSeletIndex = indexPath.row
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
