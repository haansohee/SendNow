//
//  SpendingDetailsAddView.swift
//  SendNow
//
//  Created by 한소희 on 5/14/24.
//

import UIKit

enum classificationType: String {
    case traffic = "교통"
    case accommodation = "숙박"
    case tourism = "관광"
    case food = "식비"
    case etc = "기타"
}

final class SpendingDetailsAddView: UIView {
    private let stackViewCornerRadius: CGFloat = 12.0
    
    let spendingDetailAddButton: AnimationButton = {
        let button = AnimationButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20.0, weight: .light)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus", withConfiguration: imageConfig), for: .normal)
        button.tintColor = UIColor(named: "TitleColor")
        return button
    }()
    
    let cancelButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .bold)
        return button
    }()
    
    private let dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 20.0
        return stackView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "날짜"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13.0, weight: .bold)
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko_KR")
        return datePicker
    }()
    
    private let classificationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        return stackView
    }()
    
    private let classificationImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 5.0
        return stackView
    }()
    
    private let classificationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "분류"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13.0, weight: .bold)
        return label
    }()
    
    let trafficClassificationView: SpendingDetailsClassificationView = {
        let categoryView = SpendingDetailsClassificationView()
        categoryView.classificationImage.image = UIImage(systemName: "bus")
        categoryView.classificationLabel.text = "교통"
        return categoryView
    }()
    
    let accommodationClassificationView: SpendingDetailsClassificationView = {
        let categoryView = SpendingDetailsClassificationView()
        categoryView.classificationImage.image = UIImage(systemName: "bed.double")
        categoryView.classificationLabel.text = "숙박"
        return categoryView
    }()
    
    let tourismClassificationView: SpendingDetailsClassificationView = {
        let categoryView = SpendingDetailsClassificationView()
        categoryView.classificationImage.image = UIImage(systemName: "mountain.2")
        categoryView.classificationLabel.text = "관광"
        return categoryView
    }()
    
    let foodClassificationView: SpendingDetailsClassificationView = {
        let categoryView = SpendingDetailsClassificationView()
        categoryView.classificationImage.image = UIImage(systemName: "fork.knife")
        categoryView.classificationLabel.text = "식비"
        return categoryView
    }()
    
    let etcClassificationView: SpendingDetailsClassificationView = {
        let categoryView = SpendingDetailsClassificationView()
        categoryView.classificationImage.image = UIImage(systemName: "ellipsis.circle")
        categoryView.classificationLabel.text = "기타"
        return categoryView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 20.0
        return stackView
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "내용"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13.0, weight: .bold)
        return label
    }()
    
    let contentTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = "상세 내용"
        textField.backgroundColor = .systemGray6
        textField.textColor = .label
        textField.textAlignment = .right
        textField.font = .systemFont(ofSize: 12.0, weight: .light)
        textField.layer.masksToBounds = false
        textField.layer.cornerRadius = 5.0
        return textField
    }()
    
    private let paymentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 20.0
        return stackView
    }()
    
    private let paymentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "결제금액"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13.0, weight: .bold)
        return label
    }()
    
    let paymentTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = "원"
        textField.backgroundColor = .systemGray6
        textField.textColor = .label
        textField.textAlignment = .right
        textField.font = .systemFont(ofSize: 12.0, weight: .light)
        textField.layer.masksToBounds = false
        textField.layer.cornerRadius = 5.0
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let remainderAmountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10.0
        stackView.backgroundColor = .red.withAlphaComponent(0.1)
        return stackView
    }()
    
    private let remainderAmountDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "정산 금액이 나누어 떨어지지 않을 경우, \n 나머지 금액을 더 지불할 친구를 선택해 주세요. \n 지불할 친구는 나중에도 변경이 가능해요."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13.0, weight: .bold)
        return label
    }()
    
    let remainderAmountPayUserCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(InvitedGroupCollectionViewCell.self, forCellWithReuseIdentifier: InvitedGroupCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStackView()
        addSubviews()
        setLayoutConstraints()
        backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SpendingDetailsAddView {
    private func addSubviews() {
        [
            dateStackView,
            classificationStackView,
            contentStackView,
            paymentStackView,
            remainderAmountStackView
        ].forEach { addSubview($0) }
        
        [
            dateLabel,
            datePicker
        ].forEach { dateStackView.addArrangedSubview($0) }
        
        [
            classificationLabel,
            classificationImageStackView,
        ].forEach { classificationStackView.addArrangedSubview($0) }
        
        [
            trafficClassificationView,
            accommodationClassificationView,
            tourismClassificationView,
            foodClassificationView,
            etcClassificationView
        ].forEach { classificationImageStackView.addArrangedSubview($0) }
        
        [
            contentLabel,
            contentTextField
        ].forEach { contentStackView.addArrangedSubview($0) }
        
        [
            paymentLabel,
            paymentTextField
        ].forEach { paymentStackView.addArrangedSubview($0) }
        
        [
            remainderAmountDescriptionLabel,
            remainderAmountPayUserCollectionView
        ].forEach { remainderAmountStackView.addArrangedSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            dateStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            dateStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            dateStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            dateStackView.heightAnchor.constraint(equalToConstant: 50.0),
            
            classificationStackView.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: 24.0),
            classificationStackView.leadingAnchor.constraint(equalTo: dateStackView.leadingAnchor),
            classificationStackView.trailingAnchor.constraint(equalTo: dateStackView.trailingAnchor),
            classificationStackView.heightAnchor.constraint(equalToConstant: 100.0),
            
            contentStackView.topAnchor.constraint(equalTo: classificationStackView.bottomAnchor, constant: 24.0),
            contentStackView.leadingAnchor.constraint(equalTo: dateStackView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: dateStackView.trailingAnchor),
            contentStackView.heightAnchor.constraint(equalTo: dateStackView.heightAnchor),
            
            contentLabel.heightAnchor.constraint(equalToConstant: 30.0),
            contentLabel.widthAnchor.constraint(equalToConstant: 60.0),
            contentTextField.heightAnchor.constraint(equalToConstant: 30.0),
            
            paymentStackView.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 24.0),
            paymentStackView.leadingAnchor.constraint(equalTo: dateStackView.leadingAnchor),
            paymentStackView.trailingAnchor.constraint(equalTo: dateStackView.trailingAnchor),
            paymentStackView.heightAnchor.constraint(equalTo: dateStackView.heightAnchor),
            
            paymentLabel.heightAnchor.constraint(equalToConstant: 30.0),
            paymentLabel.widthAnchor.constraint(equalToConstant: 60.0),
            paymentTextField.heightAnchor.constraint(equalToConstant: 30.0),
            
            remainderAmountStackView.topAnchor.constraint(equalTo: paymentStackView.bottomAnchor, constant: 24.0),
            remainderAmountStackView.leadingAnchor.constraint(equalTo: dateStackView.leadingAnchor),
            remainderAmountStackView.trailingAnchor.constraint(equalTo: dateStackView.trailingAnchor),
            remainderAmountStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -12.0),
            
            remainderAmountDescriptionLabel.heightAnchor.constraint(equalToConstant: 60.0)
        ])
    }
    
    private func configureStackView() {
        [
            dateStackView,
            classificationStackView,
            classificationImageStackView,
            contentStackView,
            paymentStackView,
            remainderAmountStackView
        ].forEach {
            $0.layer.masksToBounds = false
            $0.layer.cornerRadius = stackViewCornerRadius
            $0.isLayoutMarginsRelativeArrangement = true
            $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 12.0, bottom: 0, trailing: 12.0)
            $0.backgroundColor = .systemBackground
        }
    }
    
    func configureSpendingDetailView(_ detailsInfo: ExpenseDetailInformationDomain) {
        datePicker.date = detailsInfo.expenseDate.stringToDate() ?? Date()
        contentTextField.text = detailsInfo.expenseDetails
        paymentTextField.text = String(detailsInfo.expenseAmount)
        switch detailsInfo.expenseClassification {
        case classificationType.traffic.rawValue:
            trafficClassificationView.tag = 1
            trafficClassificationView.classificationImage.tintColor = UIColor(named: "TitleColor")
            trafficClassificationView.classificationLabel.textColor = UIColor(named: "TitleColor")
            
        case classificationType.accommodation.rawValue:
            accommodationClassificationView.tag = 1
            accommodationClassificationView.classificationImage.tintColor = UIColor(named: "TitleColor")
            accommodationClassificationView.classificationLabel.textColor = UIColor(named: "TitleColor")
            
        case classificationType.tourism.rawValue:
            tourismClassificationView.tag = 1
            tourismClassificationView.classificationImage.tintColor = UIColor(named: "TitleColor")
            tourismClassificationView.classificationLabel.textColor = UIColor(named: "TitleColor")
            
        case classificationType.food.rawValue:
            foodClassificationView.tag = 1
            foodClassificationView.classificationImage.tintColor = UIColor(named: "TitleColor")
            foodClassificationView.classificationLabel.textColor = UIColor(named: "TitleColor")
            
        case classificationType.etc.rawValue:
            etcClassificationView.tag = 1
            etcClassificationView.classificationImage.tintColor = UIColor(named: "TitleColor")
            etcClassificationView.classificationLabel.textColor = UIColor(named: "TitleColor")

        default:
            return
        }
    }
}
