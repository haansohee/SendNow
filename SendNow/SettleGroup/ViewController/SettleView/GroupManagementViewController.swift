//
//  GroupManagementViewController.swift
//  SendNow
//
//  Created by 한소희 on 11/29/25.
//

import Foundation
import UIKit
import RxSwift
import Toast

final class GroupManagementViewController: BaseUIViewController {
    private let groupManagementView = GroupManagementView()
    private let settleGroupViewModel: SettleGroupViewModel
    private let disposeBag = DisposeBag()
    
    init(settleGroupViewModel: SettleGroupViewModel = SettleGroupViewModel(
        userID: UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)),
         groupID: Int) {
        self.settleGroupViewModel = settleGroupViewModel
        super.init(nibName: nil, bundle: nil)
        self.settleGroupViewModel.setGroupID(groupID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settleGroupViewModel.loadGroupMemberInformation()
        configureGroupManagementViewController()
        addSubviews()
        setLayoutConstraintsGroupManagementViewController()
        bindAll()
    }
}

extension GroupManagementViewController {
    private func configureGroupManagementViewController() {
        groupManagementView.translatesAutoresizingMaskIntoConstraints = false
        groupManagementView.groupMemberListCollectionView.delegate = self
        groupManagementView.groupMemberListCollectionView.dataSource = self
        groupManagementView.groupRemainderMemberListCollectionView.delegate = self
        groupManagementView.groupRemainderMemberListCollectionView.dataSource = self
        view.backgroundColor = . secondarySystemBackground
    }
    
    private func addSubviews() {
        view.addSubview(groupManagementView)
    }
    
    private func setLayoutConstraintsGroupManagementViewController() {
        NSLayoutConstraint.activate([
            groupManagementView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            groupManagementView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            groupManagementView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            groupManagementView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: Bind
    private func bindAll() {
        bindGroupNameTextField()
        bindGroupNameUpdateButton()
        bindIsLoadedGroupMemberInfo()
        bindIsUpdatedGroupInformations()
        bindIsCanceledState()
    }
    
    private func bindGroupNameTextField() {
        groupManagementView.groupNameTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(onNext: {[weak self] inputGroupName in
                self?.groupManagementView.groupNameUpdateButton.isEnabled = !inputGroupName.isEmpty
                self?.groupManagementView.groupNameUpdateButton.backgroundColor = !inputGroupName.isEmpty ? UIColor(named: "TitleColor") : .systemGray
            })
            .disposed(by: disposeBag)
    }
    
    private func bindGroupNameUpdateButton() {
        groupManagementView.groupNameUpdateButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let newGroupName = self?.groupManagementView.groupNameTextField.text,
                      !newGroupName.isEmpty else { return }
                self?.groupInformationUpdateAlert(updateOption: .groupName(newName: newGroupName))
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedGroupMemberInfo() {
        settleGroupViewModel.isLoadedGroupMemberInfo
            .asDriver(onErrorJustReturn: .failure(ErrorName.serverError))
            .drive(onNext: {[weak self] isLoadedGroupMemberInfo in
                switch isLoadedGroupMemberInfo {
                case .success(let isLoaded):
                    guard isLoaded,
                          let groupMemberInformation = self?.settleGroupViewModel.groupMemberInformations,
                          let creatorUserIndex = self?.settleGroupViewModel.creatorUserIndex,
                          let remainderUserIndex = self?.settleGroupViewModel.remainderUserIndex else { return }
                    let isCreatorUser = self?.settleGroupViewModel.userID == groupMemberInformation[0].groupCreatorID
                    self?.groupManagementView.configureGroupManagementView(
                        groupName: groupMemberInformation[0].groupName,
                        isCreatorUser: isCreatorUser)
                    self?.groupManagementView.groupMemberListCollectionView.reloadData()
                    self?.groupManagementView.groupMemberListCollectionView.selectItem(
                        at: .init(item: creatorUserIndex, section: 0),
                        animated: false,
                        scrollPosition: .bottom)
                    self?.groupManagementView.groupRemainderMemberListCollectionView.reloadData()
                    self?.groupManagementView.groupRemainderMemberListCollectionView.selectItem(
                        at: .init(item: remainderUserIndex, section: 0),
                        animated: false,
                        scrollPosition: .bottom)
                    
                case .failure(_):
                    self?.serverErrorAlert()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsUpdatedGroupInformations() {
        settleGroupViewModel.isUpdatedGroupInformations
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isUpdatedGroupInformations in
                guard isUpdatedGroupInformations else {
                    self?.serverErrorAlert()
                    return
                }
                self?.view.makeToast("수정이 완료되었어요.", duration: 0.5) { _ in }
                self?.settleGroupViewModel.loadGroupMemberInformation()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsCanceledState() {
        settleGroupViewModel.isCanceledState
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {[weak self] _ in
                guard let groupMemberInformation = self?.settleGroupViewModel.groupMemberInformations,
                      let creatorUserIndex = self?.settleGroupViewModel.creatorUserIndex,
                      let remainderUserIndex = self?.settleGroupViewModel.remainderUserIndex else { return }
                let isCreatorUser = self?.settleGroupViewModel.userID == groupMemberInformation[0].groupCreatorID
                self?.groupManagementView.configureGroupManagementView(
                    groupName: groupMemberInformation[0].groupName,
                    isCreatorUser: isCreatorUser)
                self?.groupManagementView.groupMemberListCollectionView.reloadData()
                self?.groupManagementView.groupMemberListCollectionView.selectItem(
                    at: .init(item: creatorUserIndex, section: 0),
                    animated: false,
                    scrollPosition: .bottom)
                self?.groupManagementView.groupRemainderMemberListCollectionView.reloadData()
                self?.groupManagementView.groupRemainderMemberListCollectionView.selectItem(
                    at: .init(item: remainderUserIndex, section: 0),
                    animated: false,
                    scrollPosition: .bottom)
            })
            .disposed(by: disposeBag)
    }

    
    //MARK: Alert
    private func presentConfirmAlert(option: GroupInformationUpdateOption) {
        let alert = UIAlertController(title: "바로보내", message: option.message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "확인", style: .default) {[weak self] _ in
            switch option {
            case .management(_, let userID):
                self?.settleGroupViewModel.updateGroupManagementUser(userID)
            case .remainder(_, let userID):
                self?.settleGroupViewModel.updateGroupRemainderUser(userID)
            case .groupName(let newName):
                self?.settleGroupViewModel.updateGroupName(newName)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) {[weak self] _ in
            self?.settleGroupViewModel.cancelUpdate()
        }
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func groupInformationUpdateAlert(updateOption: GroupInformationUpdateOption) {
        switch updateOption {
        case .management(let nickname, let userID):
            presentConfirmAlert(option: .management(nickname: nickname, userID: userID))
        case .remainder(let nickname, let userID):
            presentConfirmAlert(option: .remainder(nickname: nickname, userID: userID))
        case .groupName(let newName):
            presentConfirmAlert(option: .groupName(newName: newName))
        }
    }
}

extension GroupManagementViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let groupMemberInformations = settleGroupViewModel.groupMemberInformations else { return 0 }
        return groupMemberInformations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InvitedGroupCollectionViewCell.reuseIdentifier, for: indexPath) as? InvitedGroupCollectionViewCell else { return UICollectionViewCell() }
        guard let groupMemberInformationList = settleGroupViewModel.groupMemberInformations,
              let groupMemberInformation = groupMemberInformationList[safe: indexPath.row] else { return cell }
        let isCreatorUser = groupMemberInformation.groupCreatorID == settleGroupViewModel.userID
        cell.isUserInteractionEnabled = isCreatorUser
        switch collectionView {
        case groupManagementView.groupMemberListCollectionView:
            cell.configureGroupManagementCollecionViewCell(nickname: groupMemberInformation.nickname)
            return cell
        case groupManagementView.groupRemainderMemberListCollectionView:
            cell.configureGroupRemainderCollectionViewCell(nickname: groupMemberInformation.nickname)
            return cell
        default: return cell 
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let groupMemberInformationList = settleGroupViewModel.groupMemberInformations,
              let groupMemberInformation = groupMemberInformationList[safe: indexPath.row] else { return }
        switch collectionView {
        case groupManagementView.groupMemberListCollectionView:
            groupInformationUpdateAlert(updateOption: GroupInformationUpdateOption.management(nickname: groupMemberInformation.nickname, userID: groupMemberInformation.userID))
        case groupManagementView.groupRemainderMemberListCollectionView:
            groupInformationUpdateAlert(updateOption: GroupInformationUpdateOption.remainder(nickname: groupMemberInformation.nickname, userID: groupMemberInformation.userID))
        default: return
        }
    }
}
extension GroupManagementViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (groupManagementView.groupMemberListCollectionView.bounds.width) - 10.0
        let height = 40.0
        return CGSize(width: width, height: height)
    }
}
