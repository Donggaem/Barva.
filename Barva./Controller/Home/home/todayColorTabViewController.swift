//
//  LikeBoardViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/24.
//

import UIKit

class todayColorTabViewController: UIViewController {
    
    @IBOutlet weak var todayColorCollectionView: UICollectionView!
    
    var todayColorImageArray: [String] = ["common","common (1)","common (2)","common (3)","common (4)","common (5)","common (6)","common (7)","common (8)","common (9)","common (10)","common (11)","common (12)","common (13)","common (14)","common (15)","common (16)","common (17)","common (18)","common (19)","common (20)","common (21)","common (22)","common (23)","common (24)","common (25)","common (26)","common (27)","common (28)","common (29)","common (30)","common (31)","common (32)","common (33)","common (34)","common (35)","common (36)","common (37)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
    }
    
}

//MARK: - Extension UICollectionView
extension todayColorTabViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // CollectionView 셋팅
    func setCollectionView() {
        self.todayColorCollectionView.delegate = self
        self.todayColorCollectionView.dataSource = self
        self.todayColorCollectionView.register(UINib(nibName: "HomeImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeImageCollectionViewCell")
    }

    // CollectionView item 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todayColorImageArray.count
    }

    // CollectionView Cell의 Object
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeImageCollectionViewCell", for: indexPath) as! HomeImageCollectionViewCell

        cell.image.image = UIImage(named: todayColorImageArray[indexPath.row]) ?? UIImage()

        return cell
    }
    
    // CollectionView Cell 터치
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as? HomeImageCollectionViewCell
        
        let feedVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
        self.navigationController?.pushViewController(feedVC, animated: true)
        
        feedVC.paramImg = self.todayColorImageArray[indexPath.row]
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
