//
//  IDFindViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/15.
//

import UIKit

class IDFindTabViewController: UIViewController {

    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var checkNumBtn: UIButton!
    @IBOutlet weak var idFindBtn: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var checkNumTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    //MARK: SET UI
    private func setUI() {
        
        //버튼 모서리
        emailBtn.layer.cornerRadius = 15
        checkNumBtn.layer.cornerRadius = 15
        idFindBtn.layer.cornerRadius = 5
        
        //버튼 활성/비활성 액션
        self.emailTextField.addAction(UIAction(handler: { _ in
            if self.emailTextField.text?.isEmpty == true {
                self.emailBtn.isEnabled = false
                self.emailBtn.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.941, alpha: 1)
            } else {
                self.emailBtn.isEnabled = true
                self.emailBtn.backgroundColor = .black
            }
        }), for: .editingChanged)
        
        self.checkNumTextField.addAction(UIAction(handler: { _ in
            if self.checkNumTextField.text?.isEmpty == true {
                self.checkNumBtn.isEnabled = false
                self.checkNumBtn.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.941, alpha: 1)
            } else {
                self.checkNumBtn.isEnabled = true
                self.checkNumBtn.backgroundColor = .black
            }
        }), for: .editingChanged)
    }
}
