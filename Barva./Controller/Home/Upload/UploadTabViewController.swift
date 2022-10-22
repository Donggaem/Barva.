//
//  UploadTabViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/11.
//

import UIKit
import Photos
import PhotosUI
import FSPagerView
import Alamofire

class UploadTabViewController: UIViewController {
    
    @IBOutlet weak var manBtn: UIButton!
    @IBOutlet weak var womanBtn: UIButton!
    
    @IBOutlet weak var user_HeightTextField: UITextField!
    @IBOutlet weak var user_weightTextField: UITextField!
    
    @IBOutlet weak var UPloadtextView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = FSPagerView.automaticSize
        }
    }
    
    private let textViewPlaceHolder = "착용한 아이템 및 스타일을 소개해 주세요."
    private let maxCount = 99
    
    var user_Images: [UIImage] = []
    var imageData: [Data] = []
    var testImg: [String] = []
    
    var userGender = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setTextView()
        self.pagerView.delegate = self
        self.pagerView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        countLabel.text = "0 / 100"
    }
    
    //MARK: - OBJC
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        // MARK: - 본의 photo picker 수정 부분
        /// 버튼 클릭 시 갤러리 화면 보여줌
        
        // MARK: 1
        var config = PHPickerConfiguration(photoLibrary: .shared()) // 갤러리 연결
        config.selectionLimit = 5 // 최대 몇장의 사진을 선택할 지 구함
        config.filter = PHPickerFilter.any(of: [.images, .livePhotos]) // 어떤 종류의 사진들 (사진, 라이브 포토, 영상) 을 보여줄지 여기서 필터링 진행
        let vc = PHPickerViewController(configuration: config)  // 올라오는 vc 정의
        vc.delegate = self  // 포토 피커의 델리게이트 자신으로 채택
        //vc.modalPresentationStyle = .overFullScreen // 풀 스크린으로 올리고 싶으면 해당 라인 주석 풀어주세요~
        present(vc, animated: true)   // 현재 프레즌트 형식으로 올리는데 네비로도 넘길 수 있을 듯 아니면 풀 스크린으로도 가능함.
        
        // MARK: 2
        // 상단에 PHPickerViewControllerDelegate 채택
        
        // MARK: 3.
        // 채택된 델리게이트 관련 메소드 (func picker) 아래에 정의함 ⬇️
    }
    
    //MARK: - IBACTION
    
    @IBAction func manBtnPressed(_ sender: UIButton) {
        
        userGender = "male"
        manBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        manBtn.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
        womanBtn.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.941, alpha: 1)
        womanBtn.setTitleColor( UIColor(red: 0.431, green: 0.431, blue: 0.431, alpha: 1), for: .normal)
        print(userGender)
    }
    
    @IBAction func womanBtnPressed(_ sender: UIButton) {
        
        userGender = "fmale"
        womanBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        womanBtn.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
        manBtn.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.941, alpha: 1)
        manBtn.setTitleColor( UIColor(red: 0.431, green: 0.431, blue: 0.431, alpha: 1), for: .normal)
        print(userGender)
    }
    
    @IBAction func uploadBtnPressed(_ sender: UIButton) {
        print("cleck")
        let gender = self.userGender
        let height = self.user_HeightTextField.text ?? ""
        let weight = self.user_weightTextField.text ?? ""
        let content = self.UPloadtextView.text ?? ""
        let images = imageData
        
        let params = UploadRequest(gender: gender, user_height: height, user_weight: weight, content: content, userImg: images)
        postUpload(params)
    }
    
    
    //MARK: - INNER FUNC
    private func setUI() {
        
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true
        
        // 이미지뷰 탭
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        pagerView.isUserInteractionEnabled = true //이미지뷰가 상호작용할 수 있게 설정
        pagerView.addGestureRecognizer(tapImageViewRecognizer) //이미지뷰에 제스처인식기 연결
        
    }
    
    //MARK: - POST IMGUPLOAD
    func postUpload(_ parameters: UploadRequest) {
        
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data", "authorization": UserDefaults.standard.string(forKey: "data")!]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for image in self.user_Images {
                self.imageData.append(image.jpegData(compressionQuality: 0.5)!)
            
            }
            
            let gender = self.userGender
            let height = self.user_HeightTextField.text ?? ""
            let weight = self.user_weightTextField.text ?? ""
            let content = self.UPloadtextView.text ?? ""
            
            let parameters: [String : Any] = [
                        "user_gender": gender,
                        "user_tall": height,
                        "user_weight": weight,
                        "post_content": content
                    ]
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
            for images in self.imageData {
                multipartFormData.append(images,
                                         withName: "img",
                                         fileName: "test.jpeg",
                                         mimeType: "image/jpeg")
                
            }
            
        }, to: BarvaURL.uploadPostURL, method: .post, headers: headers).responseDecodable(of: UploadResponse.self) { [self] response in
            switch response.result {
            case .success(let response):
                if response.isSuccess == true {
                    BarvaLog.debug("PostUpload-success")
                    
                    let upload_alert = UIAlertController(title: "성공", message: "업로드가 완료 되었습니다.", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                        
                        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                        let homeNav = storyBoard.instantiateViewController(identifier: "HomeNav")
                        self.changeRootViewController(homeNav)
                    }
                    upload_alert.addAction(okAction)
                    present(upload_alert, animated: false, completion: nil)
                    
                    
                    
                } else {
                    BarvaLog.error("PostUpload-fail")
                    print(response.data?.err)
                    let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    present(fail_alert, animated: false, completion: nil)
                    
                }
            case .failure(let error):
                BarvaLog.error("PostUpload-err")
                print(error.localizedDescription)
                let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "확인", style: .default)
                fail_alert.addAction(okAction)
                present(fail_alert, animated: false, completion: nil)
                
            }
        }
    }
}

//MARK: - Extension PICKER
extension UploadTabViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        self.user_Images.removeAll() // 이전 데이터 지워주기 위해서 배열 초기화
        let group = DispatchGroup()
        results.forEach { result in
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { [ weak self ] reading, error in
                // weak self 는 '약한 참조'의 개념인데 순환 참조를 막기 위해 클로저 내부에서 많이 사용함 이건 나중에 찾아봐
                defer { group.leave() }
                guard let self = self else { return }
                guard let image = reading as? UIImage, error == nil else { return }
                
                self.user_Images.append(image)
                
            }
        }
        group.notify(queue: .main) {
            print(self.user_Images.count)
            //self.pageControl.re
            self.pagerView.reloadData()
        }
    }
}


//MARK: - Extension FSPagerView
extension UploadTabViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    
    //이미지 개수
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.user_Images.count
    }
    
    //각셀에 대한 설정
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = self.user_Images[index]
        return cell
    }
}

//MARK: - Extension UITextViewDelegate
extension UploadTabViewController: UITextViewDelegate {
    
    private func setTextView(){
        
        countLabel.text = "0 / 100"
        
        //플레이스홀더 설정
        UPloadtextView.text = textViewPlaceHolder
        UPloadtextView.textColor = .placeholderText
        UPloadtextView.font = UIFont(name: "Inter-Medium", size: 12)
        
        UPloadtextView.sizeToFit()
        textViewDidChange(UPloadtextView)
        
        UPloadtextView.delegate = self
        self.UPloadtextView.textContainerInset =
        UIEdgeInsets(top: 0, left: -UPloadtextView.textContainer.lineFragmentPadding, bottom: 0, right: -UPloadtextView.textContainer.lineFragmentPadding) // 텍스트뷰 안쪽 marin없애기
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //이전 글자 - 선택된 글자 + 새로운 글자(대체될 글자)
        let newLength = textView.text.count - range.length + text.count
        let koreanMaxCount = maxCount + 1
        //글자수가 초과 된 경우 or 초과되지 않은 경우
        if newLength > koreanMaxCount {
            let overflow = newLength - koreanMaxCount //초과된 글자수
            if text.count < overflow {
                return true
            }
            let index = text.index(text.endIndex, offsetBy: -overflow)
            let newText = text[..<index]
            guard let startPosition = textView.position(from: textView.beginningOfDocument, offset: range.location) else { return false }
            guard let endPosition = textView.position(from: textView.beginningOfDocument, offset: NSMaxRange(range)) else { return false }
            guard let textRange = textView.textRange(from: startPosition, to: endPosition) else { return false }
            
            textView.replace(textRange, withText: String(newText))
            
            return false
        }
        return true
    }
    
    //텍스트뷰 열릴시
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if UPloadtextView.text == textViewPlaceHolder {
            UPloadtextView.text = nil
            UPloadtextView.textColor = .black
            countLabel.text = "0 / 100"
            
        }
    }
    
    //텍스트뷰 동작시
    func textViewDidChange(_ textView: UITextView) {
        
        countLabel.text = "\(UPloadtextView.text.count) / 100" //아래 글자수 표시
        
    }
    
    //텍스트뷰 닫힐시
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || textView.text == textViewPlaceHolder {
            UPloadtextView.text = textViewPlaceHolder
            UPloadtextView.textColor = .placeholderText
            UPloadtextView.font = UIFont(name: "Inter-SemiBold", size: 14.5)
            countLabel.text = "0 / 100"
        }
        
        if textView.text.count > maxCount {
            //글자수 제한에 걸리면 마지막 글자를 삭제함.
            UPloadtextView.text.removeLast()
            let alert = UIAlertController(title: "알림", message: "100자 이내로 적어주시기 바랍니다.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
        }
    }
    
    
}

