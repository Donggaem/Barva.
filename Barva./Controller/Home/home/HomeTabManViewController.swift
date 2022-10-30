//
//  HomeTabManViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/24.
//

import UIKit
import Tabman
import Pageboy

class HomeTabManViewController: TabmanViewController {
        
    private var viewControllers: [UIViewController] = []
    let latestVC = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "LatestBoardTabViewController") as! LatestBoardTabViewController
    
    let todayColorVC = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "todayColorTabViewController") as! todayColorTabViewController
    
    let sexVC = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "SexBoardTabViewController") as! SexBoardTabViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabView()
    }
    
    //MARK: - INNER FUNC
    func setTabView() {
        viewControllers.append(latestVC)
        viewControllers.append(todayColorVC)
        viewControllers.append(sexVC)
        
        
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
            button.selectedTintColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1)
            button.font = UIFont(name: "SpoqaHanSansNeo-Medium", size: 14)!
            
        }
        
        //indicator
        bar.indicator.weight = .custom(value: 1)
        bar.indicator.overscrollBehavior = .bounce
        bar.indicator.tintColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1)
        
        addBar(bar, dataSource: self, at:.top)
    }
    
}

//MARK: - Extension Pageboy, TMBar
extension HomeTabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "최신순 보기")
        case 1:
            return TMBarItem(title: "오늘의 색상")
        case 2:
            return TMBarItem(title: "남/ 여 정렬")
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        print(index)
        if (index == 2) {
            sexVC.setDropDown()

        }
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
