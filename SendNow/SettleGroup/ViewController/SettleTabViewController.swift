//
//  SettleTabViewController.swift
//  SendNow
//
//  Created by 한소희 on 5/21/24.
//

import Foundation
import Tabman
import Pageboy
import UIKit

final class SettleTabViewController: TabmanViewController {
    private var viewControllers: [UIViewController]?
    private var tabTitle: String?
    
    init(groupID: Int, groupName: String) {
        super.init(nibName: nil, bundle: nil)
        viewControllers = [SettleGroupViewController(groupID: groupID), IndividualRemmitDetailViewController(groupID: groupID)]
        tabTitle = groupName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        let bar = TMBar.TabBar()
        navigationItem.title = tabTitle
        bar.layout.transitionStyle = .snap
        addBar(bar, dataSource: self, at: .top)
        navigationController?.navigationBar.tintColor = UIColor(named: "TitleColor")
    }
}

extension SettleTabViewController: PageboyViewControllerDataSource, TMBarDataSource {

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers?.count ?? 0
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers?[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        guard index == 0 else {
            return TMBarItem(title: "정산 내역")
        }
        return TMBarItem(title: "모임 총 비용")
    }
}
