//
//  ColorTabViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/11.
//

import UIKit

class ColorTabViewController: UIViewController {
    
    @IBOutlet weak var colorImageView: UIImageView!
    
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    //MARK: OBJC
    //이미지 탭 제스쳐
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.imagePickerController.delegate = self
        self.imagePickerController.sourceType = .photoLibrary
        self.imagePickerController.allowsEditing = true
        present(self.imagePickerController, animated: true, completion: nil)
    }
    
    
    //MARK: INNER func
    private func setUI() {
        
        //이미지뷰 클릭동작
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        //이미지뷰가 상호작용할 수 있게 설정
        colorImageView.isUserInteractionEnabled = true
        //이미지뷰에 제스처인식기 연결
        colorImageView.addGestureRecognizer(tapImageViewRecognizer)
    }
}

//MARK: Extension UIImagePicker
extension ColorTabViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            colorImageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil) //dismiss를 직접 해야함
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
