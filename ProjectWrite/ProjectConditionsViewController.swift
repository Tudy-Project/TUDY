//
//  ProjectConditionsViewController.swift
//  TUDY
//
//  Created by jamescode on 2022/06/08.
//

import UIKit
import SnapKit

class ProjectConditionsViewController: UIViewController {
    
    // MARK: - Properties
    private let initButton: UILabel = {
        let label = UILabel().label(text: "초기화", font: .sub14)
            label.underline()
        return label
    }()
    
    private let personnelLabel = UILabel().label(text: "인원", font: .sub14)
    private let personnelSlider: DoubledSlider = {
        let slider = DoubledSlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        return slider
    }()
    
    private let expectedPeriodLabel = UILabel().label(text: "예상 기간", font: .sub14)
    private let expectedPeriodSlider: DoubledSlider = {
        let slider = DoubledSlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        return slider
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension ProjectConditionsViewController {
    // MARK: - Methods
    private func configureUI() {
        view.addSubview(initButton)
        let tapInit = UITapGestureRecognizer(target: self, action: #selector(tapInitButton))
        initButton.isUserInteractionEnabled = true
        initButton.addGestureRecognizer(tapInit)
        initButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(19)
            make.trailing.equalToSuperview().offset(-25)
        }
        
        view.addSubview(personnelLabel)
        personnelLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(37)
            make.leading.equalToSuperview().offset(19)
        }
        
        view.addSubview(personnelSlider)
        personnelSlider.addTarget(self, action: #selector(didChangeSliderValue), for: .valueChanged)
        personnelSlider.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(65)
            make.leading.equalToSuperview().offset(19)
            make.trailing.equalToSuperview().offset(-19)
        }
        
        view.addSubview(expectedPeriodLabel)
        expectedPeriodLabel.snp.makeConstraints { make in
            make.top.equalTo(personnelSlider.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(19)
        }
        
        view.addSubview(expectedPeriodSlider)
        expectedPeriodSlider.addTarget(self, action: #selector(didChangeSliderValue), for: .valueChanged)
        expectedPeriodSlider.snp.makeConstraints { make in
            make.top.equalTo(expectedPeriodLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(19)
            make.trailing.equalToSuperview().offset(-19)
        }
    }
    
    // MARK: - Action Methods
    @objc
       func tapInitButton(sender:UITapGestureRecognizer) {
           print("tap working")
       }
    
    @objc private func didChangeSliderValue() {
        print(personnelSlider.values.minimum)
        print(personnelSlider.values.maximum)
    }
}
