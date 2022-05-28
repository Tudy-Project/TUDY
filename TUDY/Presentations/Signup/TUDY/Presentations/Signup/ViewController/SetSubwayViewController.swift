//
//  setSubwayViewControoler.swift
//  TUDY
//
//  Created by neuli on 2022/05/26.
//

import UIKit

class SetSubwayViewController: UIViewController {
    
    // MARK: - Properties
    enum Event {
        case next
    }
    var didSendEventClosure: ((Event) -> Void)?
    
    private let logoLabel = UILabel().label(text: "TUDY", font: .title)
    private let guideLabel = UILabel().label(text: "출발 지하철역을 입력해주세요.", font: .sub20)
    
    private let detailGuideLabel: UILabel = {
        let label = UILabel().label(text: "팀원간 중간지점을 잡을 때 활용해요 !\n남에게 보이지 않고 언제든지 수정 가능해요.", font: .caption11)
        label.numberOfLines = 0
        return label
    }()
    
    private let subwayTextField = UITextField().textField(withPlaceholder: "지하철 명을 입력해주세요.")
    private let signUpButton = UIButton().nextButton(text: "가입하기")
    private let signUpToolbarButton = UIButton().nextButton(text: "가입하기")
    private let signUpToolbar = UIToolbar().toolbar()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        hideKeyboardWhenTappedView()
    }
}

extension SetSubwayViewController {
    
    // MARK: - Methods
    private func configureUI() {
        navigationItem.backButtonTitle = ""
        view.backgroundColor = .white
        
        view.addSubview(logoLabel)
        logoLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(94)
            make.leading.equalTo(view.snp.leading).offset(26)
        }
        
        view.addSubview(guideLabel)
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(logoLabel.snp.bottom).offset(64)
            make.leading.equalTo(view.snp.leading).offset(30)
        }
        
        view.addSubview(detailGuideLabel)
        detailGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(6)
            make.leading.equalTo(view.snp.leading).offset(32)
        }
        
        view.addSubview(subwayTextField)
        subwayTextField.snp.makeConstraints { make in
            make.top.equalTo(detailGuideLabel.snp.top).offset(38)
            make.leading.equalTo(view.snp.leading).offset(30)
            make.trailing.equalTo(view.snp.trailing).offset(-30)
        }
        view.layoutIfNeeded()
        subwayTextField.underLine()
        
        view.addSubview(signUpButton)
        signUpButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
        signUpButton.nextButtonLayout(view: view)
        
        let signUpBarButtonItem = UIBarButtonItem(customView: signUpToolbarButton)
        signUpToolbarButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
        signUpToolbar.frame = CGRect(x: 0, y: view.frame.size.height - 50, width: view.frame.size.width, height: 50)
        signUpToolbar.items = [signUpBarButtonItem]
        signUpToolbar.updateConstraintsIfNeeded()
        subwayTextField.inputAccessoryView = signUpToolbar
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

