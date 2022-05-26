//
//  WelcomeViewController.swift
//  TUDY
//
//  Created by neuli on 2022/05/26.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Properties
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
        view.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(100)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        view.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
            make.height.equalTo(50)
        }
    }
}
