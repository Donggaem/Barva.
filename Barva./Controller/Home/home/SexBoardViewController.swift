//
//  SexBoardViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/24.
//

import UIKit
import DropDown

class SexBoardTabViewController: UIViewController {
    
    @IBOutlet weak var sortBTn: UIButton!
    @IBOutlet weak var sexBoardCollectionView: UICollectionView!
    
    var sexBoardImageArray: [String] = []
    
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setDropDown()
    }
    
    private func setUI() {

    }
    
    private func setDropDown() {
        
        dropDown.dataSource = ["남", "여"]
        dropDown.show()
        dropDown.textColor = UIColor.gray
        dropDown.selectedTextColor = UIColor.black
        dropDown.backgroundColor = UIColor.white
        dropDown.cornerRadius = 10
        dropDown.anchorView = sortBTn
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.textFont = UIFont(name: "SpoqaHanSansNeo-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("선택한 아이템 : \(item)")
            print("인덱스 : \(index)")
        }
    }
    
    
    @IBAction func sortBtnPressed(_ sender: UIButton) {
        setDropDown()

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

        cell.image.image = UIImage(named: sexBoardImageArray[indexPath.row]) ?? UIImage()

        return cell
    }
    
    // CollectionView Cell 터치
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as? HomeImageCollectionViewCell
        
        let feedVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
        self.navigationController?.pushViewController(feedVC, animated: true)
        
        feedVC.paramImg = self.sexBoardImageArray[indexPath.row]
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
