//
//  ProfileModifyViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/09/02.
//

import UIKit

class ProfileModifyViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    //MARK: - IBACTION
    @IBAction func backBtnPressed(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: OBJC
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.imagePickerController.delegate = self
        self.imagePickerController.sourceType = .photoLibrary
        present(self.imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: - INNER FUNC
    private func setUI() {
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true
        
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        //이미지뷰가 상호작용할 수 있게 설정
        profileImageView.isUserInteractionEnabled = true
        //이미지뷰에 제스처인식기 연결
        profileImageView.addGestureRecognizer(tapImageViewRecognizer)
    }
}

//MARK: - Extension UIImagePicker
extension ProfileModifyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil) //dismiss를 직접 해야함
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
