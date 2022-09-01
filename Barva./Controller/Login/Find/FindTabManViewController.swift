//
//  IDFindViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/15.
//

import UIKit
import Tabman
import Pageboy

class FindTabManViewController: TabmanViewController {

    @IBOutlet weak var tabView: UIView!
    
    private var viewControllers: [UIViewController] = []
    let idVC = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "IDFindTabViewController") as! IDFindTabViewController
    
    let pwVC = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "PWFindTabViewController") as! PWFindTabViewController
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabView()
    }
    
    func setTabView() {
        viewControllers.append(idVC)
        viewControllers.append(pwVC)
        
        self.dataSource = self
                
        let bar = TMBar.ButtonBar()
                
        //탭바 레이아웃 설정
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit

                
        //배경색
        bar.backgroundView.style = .clear
        bar.backgroundColor = UIColor.white
                                
        //버튼 글시 커스텀
        bar.buttons.customize{(button) in
            button.tintColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            button.selectedTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            button.font = UIFont(name: "SpoqaHanSansNeo-Regular", size: 16)!
            
        }
        
        //indicator
        bar.indicator.weight = .custom(value: 3)
        bar.indicator.overscrollBehavior = .bounce
        bar.indicator.tintColor = UIColor.black

        addBar(bar, dataSource: self, at:.top)
    }


}

extension FindTabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "아이디 찾기")
        case 1:
            return TMBarItem(title: "비밀번호 찾기")
        default:
            let title = "Page \(index)"
           return TMBarItem(title: title)
        }
    }

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
