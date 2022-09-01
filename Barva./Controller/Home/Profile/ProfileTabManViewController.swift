//
//  ProfileTabmanViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/08/31.
//

import UIKit
import Tabman
import Pageboy

class ProfileTabManViewController: TabmanViewController {

    private var viewControllers: [UIViewController] = []
    let myUpVC = UIStoryboard.init(name: "ProfileTab", bundle: nil).instantiateViewController(withIdentifier: "MyUpTabViewController") as! MyUpTabViewController
    
    let likeVC = UIStoryboard.init(name: "ProfileTab", bundle: nil).instantiateViewController(withIdentifier: "LikeTabViewController") as! LikeTabViewController
    
    let StorVC = UIStoryboard.init(name: "ProfileTab", bundle: nil).instantiateViewController(withIdentifier: "StorageTabViewController") as! StorageTabViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabView()
    }
    
    func setTabView() {
        viewControllers.append(myUpVC)
        viewControllers.append(likeVC)
        viewControllers.append(StorVC)

        
        self.dataSource = self
                
        let bar = TMBar.coustomBar()
                
        //탭바 레이아웃 설정
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit

                
        //배경색
        bar.backgroundView.style = .clear
        bar.backgroundColor = UIColor.white
                                
//        //버튼 글시 커스텀
//        bar.buttons.customize{(button) in
//            button.tintColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
//            button.selectedTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
//            button.font = UIFont(name: "SpoqaHanSansNeo-Medium", size: 14)!
//
//        }
        
        //indicator
        bar.indicator.weight = .custom(value: 1)
        bar.indicator.overscrollBehavior = .bounce
        bar.indicator.tintColor = UIColor.black

        addBar(bar, dataSource: self, at:.top)
    }

}

extension ProfileTabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            let firstitem = TMBarItem(title: "")
            firstitem.image = UIImage(named: "grid_view-1")
            firstitem.selectedImage = UIImage(named: "grid_view")
            return firstitem
        case 1:
            let seconditem = TMBarItem(title: "")
            seconditem.image = UIImage(named: "favorite-1")
            seconditem.selectedImage = UIImage(named: "favorite")
            return seconditem
        case 2:
            let thirditem = TMBarItem(title: "")
            thirditem.image = UIImage(named: "bookmark-1")
            thirditem.selectedImage = UIImage(named: "bookmark")
            return thirditem
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
