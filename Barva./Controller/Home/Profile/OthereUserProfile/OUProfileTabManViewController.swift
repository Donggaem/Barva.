//
//  OUProfileTabManViewController.swift
//  Barva.
//
//  Created by 김동겸 on 2022/10/18.
//

import UIKit
import Tabman
import Pageboy

class OUProfileTabManViewController: TabmanViewController {

    private var viewControllers: [UIViewController] = []
    let othereUpVC = UIStoryboard.init(name: "ProfileTab", bundle: nil).instantiateViewController(withIdentifier: "OUUpTabViewController") as! OUUpTabViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTabView()
    }

    //MARK: - INNER FUNC
    func setTabView() {
        viewControllers.append(othereUpVC)
        
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
            button.selectedTintColor = UIColor(red: 0.11, green: 0.106, blue: 0.122, alpha: 1)
        }
        
        //indicator
        bar.indicator.weight = .custom(value: 1)
        bar.indicator.overscrollBehavior = .bounce
        bar.indicator.tintColor = UIColor.black
        
        addBar(bar, dataSource: self, at:.top)
    }
}

//MARK: - Extension Pageboy,TMBar
extension OUProfileTabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            let firstitem = TMBarItem(title: "")

            firstitem.image = UIImage(systemName: "square.grid.2x2")
            firstitem.selectedImage = UIImage(systemName: "square.grid.2x2.fill")
            return firstitem
            
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

