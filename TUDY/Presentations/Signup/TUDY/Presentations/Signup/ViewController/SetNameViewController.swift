//
//  setNameViewController.swift
//  TUDY
//
//  Created by neuli on 2022/05/26.
//

import UIKit

class SetNameViewController: UIViewController {
    
    // MARK: - Properties
    private let logoLabel = UILabel().label(text: "TUDY", font: .title)
    private let guideLabel = UILabel().label(text: "닉네임을 입력해주세요.", font: .sub20)
    private let nameTextField = UITextField().textField(withPlaceholder: "한글, 영문 최대 6자")
    private let checkNameLabel = UILabel().label(text: "이미 존재하는 닉네임입니다.", font: .caption12, color: UIColor(red: 255, green: 97, blue: 97, alpha: 1.0))
    private let nextButton = UIButton().nextButton()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension SetNameViewController {
    
    // MARK: - Methods
    private func configureUI() {
        view.addSubview(logoLabel)
        logoLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(94)
            make.leading.equalTo(view.snp.leading).offset(30)
        }
        
        view.addSubview(guideLabel)
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(logoLabel.snp.bottom).offset(64)
            make.leading.equalTo(view.snp.leading).offset(30)
        }
        
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(39)
            make.leading.equalTo(view.snp.leading).offset(20)
        }
        
        view.addSubview(checkNameLabel)
        checkNameLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom)
            make.leading.equalTo(view.snp.leading).offset(20)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
            make.height.equalTo(50)
        }
    }
}
