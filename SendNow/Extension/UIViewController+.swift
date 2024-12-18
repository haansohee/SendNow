//
//  UIViewController+.swift
//  SendNow
//
//  Created by 한소희 on 12/13/24.
//

import Foundation
import UIKit

extension UIViewController {
    func confirmAlert(title: String, message: String, collectionView: UICollectionView? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "확인", style: .cancel) { _ in
            guard let collectionView else { return }
            collectionView.reloadData()
        }
        alertController.addAction(doneAction)
        self.present(alertController, animated: true)
    }
    
    func invitedAlert(message: String? = nil, viewModel: GroupListViewModel) {
        if let alertMessage = message {
            let alertController = UIAlertController(title: "바로보내", message: alertMessage, preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "확인", style: .default) { _ in }
            alertController.addAction(doneAction)
            self.present(alertController, animated: true)
        } else {
            let alertController = UIAlertController(title: "바로보내", message: "모임 이름을 입력해 주세요.", preferredStyle: .alert)
            alertController.addTextField()
            let doneAction = UIAlertAction(title: "확인", style: .default) {[weak self] _ in
                guard let groupNameText = alertController.textFields?[0].text,
                      !groupNameText.isEmpty else {
                    self?.invitedAlert(message: "모임 이름을 꼭 입력해 주세요!", viewModel: viewModel)
                    return }
                viewModel.invitedFriendToGroup(groupName: groupNameText)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in }
            alertController.addAction(doneAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
    }
    
    func serverErrorAlert() {
        let alertController = UIAlertController(title: "바로 보내", message: "서비스가 일시적으로 이용 불가능합니다. 잠시후 다시 시도해 주세요.", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "확인", style: .cancel)
        alertController.addAction(doneAction)
        self.present(alertController, animated: true)
    }
}
