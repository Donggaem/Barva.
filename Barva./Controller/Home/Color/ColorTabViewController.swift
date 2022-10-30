//
//  ColorTabViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/11.
//

import UIKit
import AVFoundation
import Photos
import Gifu

class ColorTabViewController: UIViewController {
    
    @IBOutlet weak var colorImageView: UIImageView!
    @IBOutlet weak var photoIcon: UIImageView!
    @IBOutlet weak var colorExtractBtn: UIButton!
    @IBOutlet weak var colorExtractImage: GIFImageView!
    
    var colorBtnBool = false {
        didSet {
            if colorBtnBool == false {
                extractBtn_Paint(button: colorExtractBtn)
            }else {
                extractBtn_Person(button: colorExtractBtn)
            }
        }
    }
    
    let imagePickerController = UIImagePickerController()
    
    let alertController = UIAlertController(title: "올릴 방식을 선택하세요", message: "사진 찍기 또는 앨범에서 선택", preferredStyle: .actionSheet)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        enrollAlertEvent()
    }
    
    //MARK: - OBJC
    //이미지 탭 제스쳐
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - IBACTION
    @IBAction func coloreExtractBtnPressed(_ sender: UIButton) {
        if colorBtnBool == false {
            
            colorExtractImage.animate(withGIFNamed: "beage")
            colorBtnBool = true
            
            // 1초 후 실행될 부분
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.9) {
                self.colorExtractImage.stopAnimatingGIF()
            }
        }else {
            
            colorBtnBool = false

        }
    }
    
    //MARK: - INNER func
    private func setUI() {
        
        self.imagePickerController.delegate = self
        
        //익스트랙 버튼 조정

        extractBtn_Paint(button: colorExtractBtn)
        colorExtractBtn.layer.cornerRadius = colorExtractBtn.frame.height/2
        colorExtractBtn.clipsToBounds = true
        
        //이미지뷰 조정
        colorImageView.layer.borderWidth = 1
        colorImageView.layer.borderColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1).cgColor
        colorImageView.layer.cornerRadius = 5
        
        //이미지뷰 클릭동작
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        //이미지뷰가 상호작용할 수 있게 설정
        colorImageView.isUserInteractionEnabled = true
        //이미지뷰에 제스처인식기 연결
        colorImageView.addGestureRecognizer(tapImageViewRecognizer)
        
    }
    
    func extractBtn_Person (button: UIButton) {
        button.setImage(UIImage(systemName: "person.2.fill"), for: .normal)
        button.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.backgroundColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1)
    }
    
    func extractBtn_Paint (button: UIButton) {
        button.setImage(UIImage(systemName: "paintbrush.fill"), for: .normal)
        button.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.backgroundColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1)
    }
    
    //알림창 설정
    private func enrollAlertEvent() {
        let photoLibraryAlertAction = UIAlertAction(title: "사진 앨범", style: .default) {
            (action) in
            if self.PhotoAuth() {
                self.openAlbum()
            } else {
                self.AuthSettingOpen(AuthString: "앨범")
            }
            
        }
        let cameraAlertAction = UIAlertAction(title: "카메라", style: .default) {(action) in
            if self.CameraAuth() {
                self.openCamera()
            } else {
                self.AuthSettingOpen(AuthString: "카메라")
            }
            
        }
        let cancelAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        self.alertController.addAction(photoLibraryAlertAction)
        self.alertController.addAction(cameraAlertAction)
        self.alertController.addAction(cancelAlertAction)
        guard let alertControllerPopoverPresentationController
                = alertController.popoverPresentationController
        else {return}
        prepareForPopoverPresentation(alertControllerPopoverPresentationController)
    }
}

//MARK: Extension UIPopoverPresentation
extension ColorTabViewController: UIPopoverPresentationControllerDelegate {
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        if let popoverPresentationController =
            self.alertController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect
            = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverPresentationController.permittedArrowDirections = []
        }
    }
}

//MARK: - Extension UIImagePicker
extension ColorTabViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //앨범 띄우기
    func openAlbum() {
        self.imagePickerController.sourceType = .photoLibrary
        present(self.imagePickerController, animated: false, completion: nil)
    }
    
    //카메라 띄우기
    func openCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            self.imagePickerController.sourceType = .camera
            present(self.imagePickerController, animated: false, completion: nil)
        }
        else {
            print ("Camera's not available as for now.")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            colorImageView.image = image
            photoIcon.isHidden = true
        }
        
        picker.dismiss(animated: true, completion: nil) //dismiss를 직접 해야함
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 포토 라이브러리 접근 권한
    func PhotoAuth() -> Bool {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        var isAuth = false
        
        switch authorizationStatus {
        case .authorized: return true // 사용자가 앱에 사진 라이브러리에 대한 액세스 권한을 명시 적으로 부여했습니다.
        case .denied: break // 사용자가 사진 라이브러리에 대한 앱 액세스를 명시 적으로 거부했습니다.
        case .limited: break // ?
        case .notDetermined: // 사진 라이브러리 액세스에는 명시적인 사용자 권한이 필요하지만 사용자가 아직 이러한 권한을 부여하거나 거부하지 않았습니다
            PHPhotoLibrary.requestAuthorization { (state) in
                if state == .authorized {
                    isAuth = true
                }
            }
            return isAuth
        case .restricted: break // 앱이 사진 라이브러리에 액세스 할 수있는 권한이 없으며 사용자는 이러한 권한을 부여 할 수 없습니다.
        default: break
        }
        
        return false;
    }
    
    //카메라 접근 권한
    func CameraAuth() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == AVAuthorizationStatus.authorized
    }
    
    //세팅창 오픈
    func AuthSettingOpen(AuthString: String) {
        if let AppName = Bundle.main.infoDictionary!["CFBundleName"] as? String {
            let message = "\(AppName)이(가) \(AuthString) 접근 허용되어 있지않습니다. \r\n 설정화면으로 가시겠습니까?"
            let authAlert = UIAlertController(title: "설정", message: message, preferredStyle: .alert)
            
            let cancle = UIAlertAction(title: "취소", style: .default) { (UIAlertAction) in
                print("\(String(describing: UIAlertAction.title)) 클릭")
            }
            let confirm = UIAlertAction(title: "확인", style: .default) { (UIAlertAction) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            authAlert.addAction(cancle)
            authAlert.addAction(confirm)
            
            self.present(authAlert, animated: true, completion: nil)
        }
    }
}
