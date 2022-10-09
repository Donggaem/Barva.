//
//  StorageTabViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/31.
//

import UIKit

class StorageTabViewController: UIViewController {

    @IBOutlet weak var strogrCollectionView: UICollectionView!
    
    var storageImageArray: [String] = ["common (16)","common (17)","common (18)","common (19)","common (20)","common (21)","common (22)","common (23)","common (24)","common (25)","common (26)","common (27)","common (28)","common (29)","common (30)","common (31)","common (32)","common (33)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
    }


}
//MARK: - Extension UICollectionView
extension StorageTabViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // CollectionView 셋팅
    func setCollectionView() {
        self.strogrCollectionView.delegate = self
        self.strogrCollectionView.dataSource = self
        self.strogrCollectionView.register(UINib(nibName: "HomeImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeImageCollectionViewCell")
    }

    // CollectionView item 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storageImageArray.count
    }

    // CollectionView Cell의 Object
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeImageCollectionViewCell", for: indexPath) as! HomeImageCollectionViewCell

        cell.image.image = UIImage(named: storageImageArray[indexPath.row]) ?? UIImage()

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
