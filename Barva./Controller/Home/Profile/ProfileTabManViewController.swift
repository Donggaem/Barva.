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
    
    let StorVC = UIStoryboard.init(name: "ProfileTab", bundle: nil).instantiateViewController(withIdentifier: "StorageTabViewController") as! StorageTabViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabView()
    }
    
    //MARK: - INNER FUNC
    func setTabView() {
        viewControllers.append(myUpVC)
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
        
        bar.buttons.customize { (button) in
            button.tintColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            button.selectedTintColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1)
        }
        
        //indicator
        bar.indicator.weight = .custom(value: 1)
        bar.indicator.overscrollBehavior = .bounce
        bar.indicator.tintColor = UIColor(red: 0.483, green: 0.835, blue: 0.883, alpha: 1)
        
        addBar(bar, dataSource: self, at:.top)
    }
    
}

//MARK: - Extension Pageboy,TMBar
extension ProfileTabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            let firstitem = TMBarItem(title: "")

            firstitem.image = UIImage(systemName: "square.grid.2x2")
            firstitem.selectedImage = UIImage(systemName: "square.grid.2x2.fill")
            return firstitem
        case 1:
            let thirditem = TMBarItem(title: "")

            thirditem.image = UIImage(systemName: "bookmark")
            thirditem.selectedImage = UIImage(systemName: "bookmark.fill")
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
