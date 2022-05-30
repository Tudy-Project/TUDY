//
//  WelcomeViewController.swift
//  TUDY
//
//  Created by neuli on 2022/05/26.
//

import UIKit

import SnapKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Properties
    enum Event {
        case start
    }
    var didSendEventClosure: ((Event) -> Void)?
    
    private let welcomeLabel = UILabel().label(text: "", font: .sub20)
    private let startButton = UIButton().nextButton(text: "시작하기")
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension WelcomeViewController {
    
    // MARK: - Methods
    private func configureUI() {
        view.backgroundColor = .DarkGray1
        
        view.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(100)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(start), for: .touchUpInside)
        startButton.nextButtonLayout(view: view)
    }
    
    @objc private func start() {
        didSendEventClosure?(.start)
    }
}
