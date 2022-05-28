//
//  setInterestedJobViewController.swift
//  TUDY
//
//  Created by neuli on 2022/05/26.
//

import UIKit

class SetInterestedJobViewController: UIViewController {
    
    // MARK: - Properties
    enum Event {
        case next
    }
    var didSendEventClosure: ((Event) -> Void)?
    
    private let logoLabel = UILabel().label(text: "TUDY", font: .title)
    private let guideLabel = UILabel().label(text: "관심 직무를 선택해주세요.", font: .sub20)
    private let detailGuideLabel = UILabel().label(text: "관심 직무는 언제든지 마이 페이지에서 수정이 가능해요.", font: .caption11)
    // 직무선택 collectionView
    private let nextButton = UIButton().nextButton()
    private let nextToolbarButton = UIButton().nextButton(text: "다음")
    private let nextToolbar = UIToolbar().toolbar()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension SetInterestedJobViewController {
    
    // MARK: - Methods
    private func configureUI() {
        navigationItem.backButtonTitle = ""
        navigationController?.setNavigationBarHidden(false, animated: true)
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
        
        view.addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
        nextButton.nextButtonLayout(view: view)
    }
    
    @objc func goNext() {
        didSendEventClosure?(.next)
    }
}
