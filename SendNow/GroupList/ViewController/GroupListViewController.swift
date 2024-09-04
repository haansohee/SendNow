//
//  GroupListViewController.swift
//  SendNow
//
//  Created by 한소희 on 8/23/24.
//

import Foundation
import UIKit
import RxSwift

final class GroupListViewController: UIViewController {
    private let groupListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GroupListCollectionViewCell.self, forCellWithReuseIdentifier: GroupListCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = UIColor(named: "BackColor")
        collectionView.isPagingEnabled = false
        return collectionView
    }()
    
    private let groupAddButton: AnimationButton = {
        let button = AnimationButton(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20.0, weight: .light)
        button.setImage(UIImage(systemName: "plus.app", withConfiguration: imageConfig), for: .normal)
        button.tintColor = UIColor(named: "TitleColor")
        return button
    }()
    
    private let groupListViewModel: GroupListViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: GroupListViewModel = GroupListViewModel()) {
        self.groupListViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        groupListViewModel.loadMyGroup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGroupListView()
        addSubviews()
        setLayoutConstraintsGroupListView()
        bindAll()
        addInvitedFriendNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupListViewModel.loadMyGroup()
    }
}

extension GroupListViewController {
    private func configureGroupListView() {
        groupListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        groupListCollectionView.dataSource = self
        groupListCollectionView.delegate = self
        view.backgroundColor = UIColor(named: "BackColor")
        navigationItem.title = "그룹 목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: groupAddButton)
    }
    
    private func addSubviews() {
        view.addSubview(groupListCollectionView)
    }
    
    private func setLayoutConstraintsGroupListView() {
        NSLayoutConstraint.activate([
            groupListCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18.0),
            groupListCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            groupListCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            groupListCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    private func addInvitedFriendNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(dataReceived), name: NSNotification.Name(NotificationName.invitedFriend.rawValue), object: nil)
    }
    
    @objc private func dataReceived() {
        groupListViewModel.loadMyGroup()
    }
    
    //MARK: Bind
    private func bindAll() {
        bindGroupAddButton()
        bindIsLoadedMyGroupList()
    }
    
    private func bindGroupAddButton() {
        groupAddButton.rx.tap
            .asDriver(onErrorJustReturn: Void())
            .drive(onNext: {[weak self] in
                self?.navigationController?.pushViewController(InvitedGroupViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedMyGroupList() {
        groupListViewModel.isLoadedMyGroupList
            .asDriver(onErrorJustReturn: Void())
            .drive(onNext: {[weak self] in
                self?.groupListCollectionView.reloadData()
                
            })
            .disposed(by: disposeBag)
    }
}

extension GroupListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupListViewModel.myGroupList?.count ?? 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupListCollectionViewCell.reuseIdentifier, for: indexPath) as? GroupListCollectionViewCell else { return UICollectionViewCell() }
        guard let myGroupList = groupListViewModel.myGroupList else { return cell }
        
        cell.setGroupListCollectionViewCellLabel(myGroupList[indexPath.row])
        cell.rx.tapGesture()
            .when(.recognized)
            .asDriver{ _ in .never() }
            .drive(onNext: {[weak self] _ in
                self?.navigationController?.pushViewController(SettleTabViewController(groupID: myGroupList[indexPath.row].groupID, groupName: myGroupList[indexPath.row].groupName), animated: true)
            })
            .disposed(by: cell.disposeBag)
        return cell
    }
}

extension GroupListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width) - 36.0
        let height = 100.0
        return CGSize(width: width, height: height)
    }
}
