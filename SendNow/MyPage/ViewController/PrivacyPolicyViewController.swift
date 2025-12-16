//
//  PrivacyPolicyViewController.swift
//  SendNow
//
//  Created by 한소희 on 2/27/25.
//

import UIKit

final class PrivacyPolicyViewController: BaseUIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "바로보내 개인정보처리방침"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private let policyTextLabel: UILabel = {
        let label = UILabel()
        label.text = """
        
        안녕하세요! 😊 저희 앱은 여러분이 간편하게 정산할 수 있도록 돕는 서비스입니다.
        바로보내는 필요한 최소한의 개인정보만 수집하고 안전하게 보호하고 있어요.
        
        
        1. 우리가 수집하는 정보
        ✔️ 회원가입 시: 이메일, 카카오톡 계정, 애플 계정 정보
        ✔️ 정산 기능 사용 시: 계좌번호, 카카오페이 송금 링크
        
        
        2. 개인정보를 수집하는 이유
        ✔️ 회원가입 및 서비스 제공을 위해
        ✔️ 친구들과 정산을 쉽게 하기 위해 (계좌번호/카카오페이 송금 링크 활용)
        ✔️ 문의사항 응대 및 서비스 개선을 위해
        
        
        3. 개인정보 보관 기간
        ✔️ 회원 탈퇴 시 즉시 삭제됩니다.
        ✔️ 법적으로 일정 기간 보관해야 하는 경우, 해당 법령을 따를 수 있어요.
        
        📍 [통신비밀보호법]
        - 서비스 이용 관련 정보(로그인 기록): 3개월 
        
        
        4. 개인정보 제공 및 위탁
        ✔️ 원칙적으로 회원의 개인정보를 다른 곳에 제공하지 않아요.
        
        
        5. 내 정보는 내가 관리해요
        ✔️ 언제든지 내 정보를 확인하고 수정할 수 있어요.
        ✔️ 삭제를 원하시면 앱 내 설정에서 직접 하거나, 아래 메일을 통해 문의해 주세요.
        
        📩 balobonae@gmail.com
        """
        label.font = .customFont(.pretendardRegular, size: 15.0)
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPrivacyPolicyView()
    }
    
    private func setupPrivacyPolicyView() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .titleColor
        navigationItem.title = "개인정보처리방침"
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(policyTextLabel)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        policyTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            policyTextLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            policyTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            policyTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            policyTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)

        ])
    }
}
