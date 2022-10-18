//
//  OUUpTabViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/18.
//

import UIKit
import Alamofire

class OUUpTabViewController: UIViewController {

    @IBOutlet weak var othereUpCollectionView: UICollectionView!
    
    var othereImageArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - GET OTHEREUPIMAGES
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "data")!]
    private func getOthereUpImages() {
        AF.request(BarvaURL.othereUpImagesURL, method: .get, headers: header)
            .validate()
            .responseDecodable(of: OthereUpImagesResponse.self) { response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        print(BarvaLog.debug("getOthereUpImages-success"))
                       
                        if response.data != nil {
                            if let imgArray = response.data?.othereFeedInfo {
                                self.othereImageArray = imgArray
                            } else {
                                print("올린 사진없음")
                                self.othereImageArray = []
                            }
                        }else {
                            print("옵셔널 에러")
                        }

//                        self.myUpImageArray = response.data?.myFeedInfo ?? []


                    } else {
                        print(BarvaLog.error("getOthereUpImages-fail"))
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        self.present(fail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    print(BarvaLog.error("getOthereUpImages-err"))
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
extension OUUpTabViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // CollectionView 셋팅
    func setCollectionView() {
        self.othereUpCollectionView.delegate = self
        self.othereUpCollectionView.dataSource = self
        self.othereUpCollectionView.register(UINib(nibName: "HomeImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeImageCollectionViewCell")
    }

    // CollectionView item 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return othereImageArray.count
    }

    // CollectionView Cell의 Object
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeImageCollectionViewCell", for: indexPath) as! HomeImageCollectionViewCell

//        cell.image.image = UIImage(named: myUpImageArray[indexPath.row]) ?? UIImage()

        //킹피셔로 이미지 띄우기
        let url = URL(string: othereImageArray[indexPath.row])
        cell.image.kf.setImage(with: url)
        
        return cell
    }
    
    // CollectionView Cell 터치
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as? HomeImageCollectionViewCell
        
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
