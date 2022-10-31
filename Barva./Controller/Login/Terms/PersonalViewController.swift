//
//  PersonalViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/31.
//

import UIKit

class PersonalViewController: UIViewController {

    @IBOutlet weak var persnalTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
}
