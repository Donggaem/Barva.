//
//  UploadTabViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/11.
//

import UIKit
//import YPImagePicker
import BSImagePicker
import Photos

protocol AddImageDelegate {
    func didPickImagesToUpload(images: [UIImage])
}

class UploadTabViewController: UIViewController {
    
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
//    var images: [UIImage] = []
    
    var delegate: AddImageDelegate!
    var selectedAssets: [PHAsset] = [PHAsset]()
    var userSelectedImages: [UIImage] = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(uploadImageView.image)
    }
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        uploadImageView.image = userSelectedImages[pageControl.currentPage]
    }
    
    @IBAction func uploadPressed(_ sender: UIButton) {
        
        selectedAssets.removeAll()
        userSelectedImages.removeAll()
        
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 5
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        
        
        presentImagePicker(imagePicker, select: { (asset) in
            
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
            
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
            
        }, cancel: { (assets) in
            // User canceled selection.
            
        }, finish: { (assets) in
            // User finished selection assets.
            
            for i in 0..<assets.count {
                self.selectedAssets.append(assets[i])
            }
            self.convertAssetToImages()
            self.delegate?.didPickImagesToUpload(images: self.userSelectedImages)
        })
        
//        var config = YPImagePickerConfiguration()
//        config.screens = [.library]
//        config.library.maxNumberOfItems = 6
//        let picker = YPImagePicker(configuration: config)
//
//        picker.didFinishPicking { [unowned picker] items, cancelled in
//            self.images = []
//
//            if cancelled {
//                picker.dismiss(animated: true, completion: nil)
//                return
//            }
//
//            // 여러 이미지를 넣어주기 위해 하나씩 넣어주는 반복문
//            for item in items {
//                switch item {
//                    // 이미지만 받기때문에 photo case만 처리
//                case .photo(let p):
//                    // 이미지를 해당하는 이미지 배열에 넣어주는 code
//                    self.images.append(p.image)
//
//                default:
//                    print("")
//
//                }
//
//            }
//            //사진 선택창 닫기
//            picker.dismiss(animated: true, completion: nil)
//        }
//        //선택창 보여주기
//        present(picker, animated: true, completion: nil)
        
    }
    
    func convertAssetToImages() {
            
            if selectedAssets.count != 0 {
                
                for i in 0..<selectedAssets.count {
                    
                    let imageManager = PHImageManager.default()
                    let option = PHImageRequestOptions()
                    option.isSynchronous = true
                    var thumbnail = UIImage()
                    
                    imageManager.requestImage(for: selectedAssets[i],
                                              targetSize: CGSize(width: 200, height: 200),
                                              contentMode: .aspectFit,
                                              options: option) { (result, info) in
                        thumbnail = result!
                    }
                    
                    let data = thumbnail.jpegData(compressionQuality: 0.7)
                    let newImage = UIImage(data: data!)
                    
                    self.userSelectedImages.append(newImage! as UIImage)
                }
            }
        }
    
    
    private func setUI() {
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        view.isOpaque = false
        
        pageControl.numberOfPages = userSelectedImages.count
        pageControl.currentPage = 0
        // 페이지 표시 색상
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        // 현재 페이지 표시 색상
        pageControl.currentPageIndicatorTintColor = UIColor.black
        uploadImageView.image = userSelectedImages[0]
        
        // 한 손가락 스와이프 제스쳐 등록(좌, 우)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(PopupViewController.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(PopupViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        // 만일 제스쳐가 있다면
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            
            // 발생한 이벤트가 각 방향의 스와이프 이벤트라면
            // pageControl이 가르키는 현재 페이지에 해당하는 이미지를 imageView에 할당
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left :
                pageControl.currentPage += 1
                uploadImageView.image = userSelectedImages[pageControl.currentPage]
            case UISwipeGestureRecognizer.Direction.right :
                pageControl.currentPage -= 1
                uploadImageView.image = userSelectedImages[pageControl.currentPage]
            default:
                break
            }
        }
    }
    
}
