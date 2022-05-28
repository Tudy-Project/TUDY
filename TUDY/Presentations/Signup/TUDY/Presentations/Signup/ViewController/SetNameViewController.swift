//
//  setNameViewController.swift
//  TUDY
//
//  Created by neuli on 2022/05/26.
//

import UIKit

class SetNameViewController: UIViewController {
    
    // MARK: - Properties
    enum Event {
        case next
    }
    var didSendEventClosure: ((Event) -> Void)?
    
    private let logoLabel = UILabel().label(text: "TUDY", font: .title)
    private let guideLabel = UILabel().label(text: "닉네임을 입력해주세요.", font: .sub20)
    private let nameTextField = UITextField().textField(withPlaceholder: "한글, 영문 최대 6자")
    private let checkNameLabel = UILabel().label(text: "이미 존재하는 닉네임입니다.", font: .caption12, color: .red)
    private let nextButton = UIButton().nextButton()
    private let nextToolbarButton = UIButton().nextButton(text: "다음")
    private let nextToolbar = UIToolbar().toolbar()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        hideKeyboardWhenTappedView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension SetNameViewController {
    
    // MARK: - Methods
    private func configureUI() {
        navigationItem.backButtonTitle = ""
        view.backgroundColor = .white
        
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
            make.leading.equalTo(view.snp.leading).offset(30)
            make.trailing.equalTo(view.snp.trailing).offset(-30)
        }
        view.layoutIfNeeded()
        nameTextField.underLine()
        
        view.addSubview(checkNameLabel)
        checkNameLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(18)
            make.leading.equalTo(view.snp.leading).offset(30)
        }
        
        view.addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
        nextButton.nextButtonLayout(view: view)
        
        let nextBarButtonItem = UIBarButtonItem(customView: nextToolbarButton)
        nextToolbarButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
        nextToolbar.frame = CGRect(x: 0, y: view.frame.size.height - 50, width: view.frame.size.width, height: 50)
        nextToolbar.items = [nextBarButtonItem]
        nextToolbar.updateConstraintsIfNeeded()
        nameTextField.inputAccessoryView = nextToolbar
    }
    
    func hideKeyboardWhenTappedView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func goNext() {
        didSendEventClosure?(.next)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
