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
    
    var paramImg: [String] = []
    var imageArray: [UIImageView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: paramImg[0])
        testimage.kf.setImage(with: url)
        
    }
}
