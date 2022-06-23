//
//  setNameViewController.swift
//  TUDY
//
//  Created by neuli on 2022/05/26.
//

import UIKit

import SnapKit

class SetNameViewController: UIViewController {
    
    // MARK: - Properties
    enum Event {
        case next
    }
    var didSendEventClosure: ((Event) -> Void)?
    
    private lazy var stepStackView = UIStackView().stepStackView(currentStep: step)
    private let guideLabel = UILabel().label(text: "닉네임을\n입력해주세요. 💬", font: .sub20)
    private let nameTextField = UITextField().textField(withPlaceholder: "한글, 영문 최대 6자")
    private let checkNameLabel = UILabel().label(text: "", font: .caption12, color: .PointRed)
    private let nextButton = UIButton().nextButton()
    private let nextToolbarButton = UIButton().nextButton(text: "다음")
    private let nextToolbar = UIToolbar().toolbar()
    
    private let step = 1
    private let regexPattern = "^[0-9a-zA-Z가-힣]{2,6}$"
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        hideKeyboardWhenTappedView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
        focusOnNameTextField()
    }
}

extension SetNameViewController {
    
    // MARK: - Methods
    private func configureUI() {
        navigationItem.backButtonTitle = ""
        view.backgroundColor = .DarkGray1
        
        view.addSubview(stepStackView)
        stepStackView.stepStackViewLayout(view: view)
        
        view.addSubview(guideLabel)
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(115)
            make.leading.equalTo(view.snp.leading).offset(30)
        }
        
        view.addSubview(nameTextField)
        nameTextField.addTarget(self, action: #selector(checkNameValidation), for: .editingChanged)
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(166)
            make.leading.equalTo(view.snp.leading).offset(33)
            make.trailing.equalTo(view.snp.trailing).offset(-30)
        }
        view.layoutIfNeeded()
        nameTextField.underLine()
        
        view.addSubview(checkNameLabel)
        checkNameLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(28)
            make.leading.equalTo(view.snp.leading).offset(33)
        }
        
        view.addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
        nextButton.nextButtonLayout(view: view)
        
        let nextBarButtonItem = UIBarButtonItem(customView: nextToolbarButton)
        nextToolbarButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
        nextToolbarButton.changeIsEnabledFalse()
        nextToolbar.frame = CGRect(x: 0, y: view.frame.size.height - 50, width: view.frame.size.width, height: 50)
        nextToolbar.items = [nextBarButtonItem]
        nextToolbar.updateConstraintsIfNeeded()
        nameTextField.inputAccessoryView = nextToolbar
    }
    
    private func hideKeyboardWhenTappedView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func focusOnNameTextField() {
        nameTextField.becomeFirstResponder()
    }
    
    private func buttonChangeIsEnableTrue() {
        nextButton.changeIsEnabledTrue()
        nextToolbarButton.changeIsEnabledTrue()
        nextToolbar.changeColorDarkGray4()
    }
    
    private func buttonChangeIsEnableFalse() {
        nextButton.changeIsEnabledFalse()
        nextToolbarButton.changeIsEnabledFalse()
        nextToolbar.changeColorDarkGray2()
    }
    
    private func addCheckIconToTextField() {
        nameTextField.delegate = self
        guard let checkImage = UIImage(named: "nameCheck") else { return }
        let checkImageButton = UIButton()
        checkImageButton.isEnabled = false
        checkImageButton.setBackgroundImage(checkImage, for: .normal)
        checkImageButton.frame = CGRect(x: 0, y: 0, width: checkImage.size.width, height: checkImage.size.height)
        nameTextField.rightView = checkImageButton
        nameTextField.rightViewMode = .always
    }
    
    private func deleteCheckIconFromTextField() {
        let noSeeButton = UIButton()
        noSeeButton.isEnabled = false
        noSeeButton.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        nameTextField.rightView = noSeeButton
    }
    
    private func setUser() {
        guard let nickname = nameTextField.text else { return }
        UserForRegister.shared.nickname = nickname
    }
    
    // MARK: - Action Methods
    @objc private func checkNameValidation() {
        // 정규식으로 이름 유효성 체크
        guard let text = nameTextField.text else { return }
        if text == "" {
            self.checkNameLabel.text = ""
            return
        }
        let regex = try? NSRegularExpression(pattern: regexPattern)
        if let _ = regex?.firstMatch(in: text, range: NSRange(location: 0, length: text.count)) {
            // 유효한 경우
            addCheckIconToTextField()
            buttonChangeIsEnableTrue()
            self.checkNameLabel.text = ""
        } else { // 유효하지 않은 경우
            deleteCheckIconFromTextField()
            buttonChangeIsEnableFalse()
            self.checkNameLabel.text = "형식이 올바르지 않습니다."
        }
    }
    
    @objc private func goNext() {
        setUser()
        didSendEventClosure?(.next)
    }
}

extension SetNameViewController: UITextFieldDelegate {}


/// 옮겨야합니다.......ㅎ
extension UIStackView {
    
    func stepStackView(currentStep: Int) -> UIStackView {
        let stackView = UIStackView()
        for i in 1...3 {
            let view = i == currentStep ? UIView().currentStep() : UIView().defaultStep()
            stackView.addArrangedSubview(view)
        }
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }
    
    func stepStackViewLayout(view: UIView) {
        self.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(59)
            make.trailing.equalTo(view.snp.trailing).offset(-30)
            make.width.equalTo(61)
            make.height.equalTo(8)
        }
    }
}

extension UIView {
    
    func currentStep() -> UIView {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.width.equalTo(25)
            make.height.equalTo(8)
        }
        view.layer.cornerRadius = 4
        view.backgroundColor = .DarkGray6
        return view
    }
    
    func defaultStep() -> UIView {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.width.equalTo(8)
            make.height.equalTo(8)
        }
        view.layer.cornerRadius = 4
        view.backgroundColor = .DarkGray4
        return view
    }
}
