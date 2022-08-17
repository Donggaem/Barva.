//
//  UploadTabViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/11.
//

import UIKit

class UploadTabViewController: UIViewController {
    
    @IBOutlet weak var uploadImageView: UIImageView!
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func uploadPressed(_ sender: UIButton) {
        self.imagePickerController.delegate = self
        self.imagePickerController.sourceType = .photoLibrary
        present(self.imagePickerController, animated: true, completion: nil)
    }
    
}
extension UploadTabViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            uploadImageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil) //dismiss를 직접 해야함
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
