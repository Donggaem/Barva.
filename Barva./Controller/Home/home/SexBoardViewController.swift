//
//  SexBoardViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/24.
//

import UIKit
import DropDown
import Alamofire

class SexBoardTabViewController: UIViewController {
    
    @IBOutlet weak var sortBTn: UIButton!
    @IBOutlet weak var sexBoardCollectionView: UICollectionView!
    
    var sexBoardImageArray: [String] = []
    
    let dropDown = DropDown()
    var selectGender = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setCollectionView()
        self.sexBoardCollectionView.reloadData()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setDropDown()
        setCollectionView()
        self.sexBoardCollectionView.reloadData()

    }
    
    private func setUI() {

    }
    
    func setDropDown() {
        
        dropDown.dataSource = ["남", "여"]
        dropDown.show()
        dropDown.textColor = UIColor.gray
        dropDown.selectedTextColor = UIColor.black
        dropDown.backgroundColor = UIColor.white
        dropDown.cornerRadius = 10
        dropDown.anchorView = sortBTn
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height) ?? 35.0)
        dropDown.textFont = UIFont(name: "SpoqaHanSansNeo-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("선택한 아이템 : \(item)")
            
            if item == "남" {
                selectGender = item
                
                let param = GenderCheckboardRequest(user_gender: selectGender)
                postGenderCheckerboard(param)

            }else {
                selectGender = item
                
                let param = GenderCheckboardRequest(user_gender: selectGender)
                postGenderCheckerboard(param)

            }
        }
    }
    
    
    @IBAction func sortBtnPressed(_ sender: UIButton) {
//        setDropDown()

    }
    
    //MARK: - POST GENDERCHECKBOARD
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "data")!]
    private func postGenderCheckerboard(_ parameters: GenderCheckboardRequest){
        AF.request(BarvaURL.genderCheckerboardURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
            .validate()
            .responseDecodable(of: GenderCheckboardResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        
                        BarvaLog.debug("postGenderCheckerboard - Success")
                        
                        if response.data != nil {
                            if let imgarry = response.data?.checkerboardArr?.compactMap({$0}) {
                                self.sexBoardImageArray = imgarry
                                self.sexBoardCollectionView.reloadData()
                                
                            }
                        }
                        
                    } else {
                        BarvaLog.error("postGenderCheckerboard - fail")
                        let loginFail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        loginFail_alert.addAction(okAction)
                        present(loginFail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    BarvaLog.error("postGenderCheckerboard - err")
                    let loginFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    loginFail_alert.addAction(okAction)
                    present(loginFail_alert, animated: false, completion: nil)
                }
            }
    }
}

//MARK: - Extension UICollectionView
extension SexBoardTabViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // CollectionView 셋팅
    func setCollectionView() {
        self.sexBoardCollectionView.delegate = self
        self.sexBoardCollectionView.dataSource = self
        self.sexBoardCollectionView.register(UINib(nibName: "HomeImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeImageCollectionViewCell")
    }

    // CollectionView item 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sexBoardImageArray.count
    }

    // CollectionView Cell의 Object
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeImageCollectionViewCell", for: indexPath) as! HomeImageCollectionViewCell

        let url = URL(string: sexBoardImageArray[indexPath.row])
        cell.image.kf.setImage(with: url)

        return cell
    }
    
    // CollectionView Cell 터치
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as? HomeImageCollectionViewCell
        
        let feedVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
        self.navigationController?.pushViewController(feedVC, animated: true)
        
        print("남여\(indexPath.row)")
        feedVC.paramSeletIndex = indexPath.row
        feedVC.paramSort = "Gender"
        feedVC.paramGender = selectGender

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

