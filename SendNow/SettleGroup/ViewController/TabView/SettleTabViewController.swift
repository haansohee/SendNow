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
    
    init(
        groupID: Int,
        groupName: String,
        isActiveSettlement: Bool
    ) {
        super.init(nibName: nil, bundle: nil)
        viewControllers = [SettleGroupViewController(
            groupID: groupID,
            isActiveSettlement: isActiveSettlement
        ),IndividualRemmitDetailViewController(groupID: groupID)]
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
        navigationController?.navigationBar.tintColor = .titleColor
        
        bar.backgroundView.style = .blur(style: .regular)
        bar.indicator.tintColor = .label
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .centerDistributed
        
        bar.buttons.customize { (button) in
            button.tintColor = .label
            button.selectedTintColor = .titleColor
            button.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            button.backgroundColor = .secondarySystemBackground
        }
        
        addBar(bar, dataSource: self, at: .top)
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
        guard index == 1 else {
            let item = TMBarItem(title: "")
            item.title = "정산 내역"
            item.image = UIImage(systemName: "note.text")
            return item
        }
        let item = TMBarItem(title: "")
        item.title = "모임 총 비용"
        item.image = UIImage(systemName: "wonsign.circle")
        return item
    }
}
