//
//  IDFindViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/15.
//

import UIKit
import Tabman
import Pageboy

class TabManViewController: TabmanViewController {

    @IBOutlet weak var tabView: UIView!
    
    private var viewControllers: [UIViewController] = []
    let idVC = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "IDFindViewController") as! IDFindViewController
    
    let pwVC = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "PWFindViewController") as! PWFindViewController
    
    
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
        bar.layout.contentMode = .intrinsic
        //        .fit : indicator가 버튼크기로 설정됨
        bar.layout.interButtonSpacing = view.bounds.width / 8

                
        //배경색
        bar.backgroundView.style = .clear
        bar.backgroundColor = UIColor.black
                
        //간격설정
        bar.layout.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10)
                
        //버튼 글시 커스텀
        bar.buttons.customize{
            (button)
            in
            button.tintColor = UIColor.gray
            button.selectedTintColor = UIColor.white
            button.font = UIFont.systemFont(ofSize: 14)
        }
        //indicator
        bar.indicator.weight = .custom(value: 3)
        bar.indicator.overscrollBehavior = .bounce
        bar.indicator.tintColor = UIColor.blue

        addBar(bar, dataSource: self, at:.top)
    }


}

extension TabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
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
