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
    
    //인원
    private let personnelLabel = UILabel().label(text: "인원 : ", font: .sub14)
    var personnelThumbsLabel = UILabel().label(text: "0 명", font: .sub14)
    private let personnelSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0
        slider.minimumValue = 0
        slider.maximumValue = 8
        return slider
    }()
    
    //예상 기간
    private let expectedPeriodLabel = UILabel().label(text: "예상 기간 : ", font: .sub14)
    var expectedPeriodThumbsLabel = UILabel().label(text: "0 주", font: .sub14)
    private let expectedPeriodSlider: UISlider = {
        let slider = UISlider()
        slider.tintColor = .PointBlue
        slider.value = 0
        slider.minimumValue = 0
        slider.maximumValue = 8
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
        personnelSlider.addTarget(self, action: #selector(didChangePersonSliderValue), for: .valueChanged)
        personnelSlider.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(65)
            make.leading.equalToSuperview().offset(19)
            make.trailing.equalToSuperview().offset(-19)
        }
        
        view.addSubview(personnelThumbsLabel)
        personnelThumbsLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(37)
            make.leading.equalTo(personnelLabel.snp.trailing).offset(10)
        }
        
        view.addSubview(expectedPeriodLabel)
        expectedPeriodLabel.snp.makeConstraints { make in
            make.top.equalTo(personnelSlider.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(19)
        }
        
        view.addSubview(expectedPeriodSlider)
        expectedPeriodSlider.addTarget(self, action: #selector(didChangeTimeSliderValue), for: .valueChanged)
        expectedPeriodSlider.snp.makeConstraints { make in
            make.top.equalTo(expectedPeriodLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(19)
            make.trailing.equalToSuperview().offset(-19)
        }
        
        view.addSubview(expectedPeriodThumbsLabel)
        expectedPeriodThumbsLabel.snp.makeConstraints { make in
            make.top.equalTo(personnelSlider.snp.bottom).offset(25)
            make.leading.equalTo(expectedPeriodLabel.snp.trailing).offset(10)
        }
    }
    
    // MARK: - Action Methods
    @objc
       func tapInitButton(sender:UITapGestureRecognizer) {
           print("tap working")
       }
    
    @objc private func didChangePersonSliderValue(_ sender: UISlider) {
        let value = Int(sender.value)
        self.personnelThumbsLabel.text = ("\(String(value))명")
        NotificationCenter.default.post(name: Notification.Name("peopleCount"),
                                        object: value)
    }
    
    @objc private func didChangeTimeSliderValue(_ sender: UISlider) {
        let value = Int(sender.value)
        self.expectedPeriodThumbsLabel.text = ("\(String(value))주")
        NotificationCenter.default.post(name: Notification.Name("time"),
                                        object: value)
    }
}
