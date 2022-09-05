//
//  ProfileTabViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/11.
//

import UIKit

class ProfileTabViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: OBJC
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let modifyVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileModifyViewController") as! ProfileModifyViewController
        self.navigationController?.pushViewController(modifyVC, animated: true)
    }
    
    //MARK: INNER FUNC
    private func setUI(){
        
        // 이미지뷰 탭
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        //이미지뷰가 상호작용할 수 있게 설정
        profileImageView.isUserInteractionEnabled = true
        //이미지뷰에 제스처인식기 연결
        profileImageView.addGestureRecognizer(tapImageViewRecognizer)
    }
}
