//
//  TestUploadViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/06.
//

import UIKit
import Kingfisher


class TestUploadViewController: UIViewController {
    
    @IBOutlet weak var testimage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://barva-dot.s3.ap-northeast-2.amazonaws.com/7721665045675137.png")
        testimage.kf.setImage(with: url)
        
    }
}
