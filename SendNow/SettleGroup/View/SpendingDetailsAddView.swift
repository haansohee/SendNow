//
//  SpendingDetailsAddView.swift
//  SendNow
//
//  Created by 한소희 on 5/14/24.
//

import UIKit

enum classficationType: String {
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
        button.tintColor = .titleColor
        return button
    }()
    
    let cancelButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = UIFont(name: FontName.pretendardBold.rawValue, size: FontSize.small.rawValue)
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
        label.font = UIFont(name: FontName.pretendardBold.rawValue, size: FontSize.extraSmall.rawValue)
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
    
    private let classficationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        return stackView
    }()
    
    private let classficationImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 5.0
        return stackView
    }()
    
    private let classficationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "분류"
        label.textAlignment = .left
        label.font = UIFont(name: FontName.pretendardBold.rawValue, size: FontSize.extraSmall.rawValue)
        return label
    }()
    
    let trafficclassficationView: SpendingDetailsclassficationView = {
        let categoryView = SpendingDetailsclassficationView()
        categoryView.classficationImage.image = UIImage(systemName: "bus")
        categoryView.classficationLabel.text = "교통"
        return categoryView
    }()
    
    let accommodationclassficationView: SpendingDetailsclassficationView = {
        let categoryView = SpendingDetailsclassficationView()
        categoryView.classficationImage.image = UIImage(systemName: "bed.double")
        categoryView.classficationLabel.text = "숙박"
        return categoryView
    }()
    
    let tourismclassficationView: SpendingDetailsclassficationView = {
        let categoryView = SpendingDetailsclassficationView()
        categoryView.classficationImage.image = UIImage(systemName: "mountain.2")
        categoryView.classficationLabel.text = "관광"
        return categoryView
    }()
    
    let foodclassficationView: SpendingDetailsclassficationView = {
        let categoryView = SpendingDetailsclassficationView()
        categoryView.classficationImage.image = UIImage(systemName: "fork.knife")
        categoryView.classficationLabel.text = "식비"
        return categoryView
    }()
    
    let etcclassficationView: SpendingDetailsclassficationView = {
        let categoryView = SpendingDetailsclassficationView()
        categoryView.classficationImage.image = UIImage(systemName: "ellipsis.circle")
        categoryView.classficationLabel.text = "기타"
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
        label.font = UIFont(name: FontName.pretendardBold.rawValue, size: FontSize.extraSmall.rawValue)
        return label
    }()
    
    let contentTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = "상세 내용"
        textField.backgroundColor = .systemGray6
        textField.textColor = .label
        textField.textAlignment = .right
        textField.font = UIFont(name: FontName.pretendardLight.rawValue, size: FontSize.extraSmall.rawValue)
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
        label.font = UIFont(name: FontName.pretendardBold.rawValue, size: FontSize.extraSmall.rawValue)
        return label
    }()
    
    let paymentTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = "원"
        textField.backgroundColor = .systemGray6
        textField.textColor = .label
        textField.textAlignment = .right
        textField.font = UIFont(name: FontName.pretendardLight.rawValue, size: FontSize.extraSmall.rawValue)
        textField.layer.masksToBounds = false
        textField.layer.cornerRadius = 5.0
        textField.keyboardType = .numberPad
        return textField
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
            classficationStackView,
            contentStackView,
            paymentStackView
        ].forEach { addSubview($0) }
        
        [
            dateLabel,
            datePicker
        ].forEach { dateStackView.addArrangedSubview($0) }
        
        [
            classficationLabel,
            classficationImageStackView,
        ].forEach { classficationStackView.addArrangedSubview($0) }
        
        [
            trafficclassficationView,
            accommodationclassficationView,
            tourismclassficationView,
            foodclassficationView,
            etcclassficationView
        ].forEach { classficationImageStackView.addArrangedSubview($0) }
        
        [
            contentLabel,
            contentTextField
        ].forEach { contentStackView.addArrangedSubview($0) }
        
        [
            paymentLabel,
            paymentTextField
        ].forEach { paymentStackView.addArrangedSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            dateStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            dateStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            dateStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            dateStackView.heightAnchor.constraint(equalToConstant: 50.0),
            
            classficationStackView.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: 24.0),
            classficationStackView.leadingAnchor.constraint(equalTo: dateStackView.leadingAnchor),
            classficationStackView.trailingAnchor.constraint(equalTo: dateStackView.trailingAnchor),
            classficationStackView.heightAnchor.constraint(equalToConstant: 100.0),
            
            contentStackView.topAnchor.constraint(equalTo: classficationStackView.bottomAnchor, constant: 24.0),
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
        ])
    }
    
    private func configureStackView() {
        [
            dateStackView,
            classficationStackView,
            classficationImageStackView,
            contentStackView,
            paymentStackView
        ].forEach {
            $0.layer.masksToBounds = false
            $0.layer.cornerRadius = stackViewCornerRadius
            $0.isLayoutMarginsRelativeArrangement = true
            $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 12.0, bottom: 0, trailing: 12.0)
            $0.backgroundColor = .systemBackground
        }
    }
    
    func configureSpendingDetailView(_ detailsInfo: ExpenseDetailInformation) {
        datePicker.date = detailsInfo.expenseDate.stringToDate() ?? Date()
        contentTextField.text = detailsInfo.expenseDetails
        paymentTextField.text = String(detailsInfo.expenseAmount)
        switch detailsInfo.expenseClassfication {
        case classficationType.traffic.rawValue:
            trafficclassficationView.tag = 1
            trafficclassficationView.classficationImage.tintColor = .titleColor
            trafficclassficationView.classficationLabel.textColor = .titleColor
            
        case classficationType.accommodation.rawValue:
            accommodationclassficationView.tag = 1
            accommodationclassficationView.classficationImage.tintColor = .titleColor
            accommodationclassficationView.classficationLabel.textColor = .titleColor
            
        case classficationType.tourism.rawValue:
            tourismclassficationView.tag = 1
            tourismclassficationView.classficationImage.tintColor = .titleColor
            tourismclassficationView.classficationLabel.textColor = .titleColor
            
        case classficationType.food.rawValue:
            foodclassficationView.tag = 1
            foodclassficationView.classficationImage.tintColor = .titleColor
            foodclassficationView.classficationLabel.textColor = .titleColor
            
        case classficationType.etc.rawValue:
            etcclassficationView.tag = 1
            etcclassficationView.classficationImage.tintColor = .titleColor
            etcclassficationView.classficationLabel.textColor = .titleColor

        default:
            return
        }
    }
}
