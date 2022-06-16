//
//  InvitedViewController.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/06/15.
//

import UIKit

class InvitedViewController: UIViewController {
    // MARK: - Properties
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .DarkGray1
        return view
    }()
    
    private lazy var bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .DarkGray3
        view.layer.cornerRadius = 19
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private var bottomsheetStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.isLayoutMarginsRelativeArrangement = true
        stackview.axis = .horizontal
        stackview.layoutMargins.left = 15.0
        stackview.layoutMargins.right = 15.0
        return stackview
    }()
    
    private lazy var bottomsheetgroupchatListLabel: UILabel = {
        let label = UILabel().label(text: "스터디챗 목록", font: .sub20)
        return label
    }()
    
    private lazy var bottomsheetgroupchatinvitedbutton: UILabel = {
        let label = UILabel().label(text: "초대", font: .sub16)
        let tap = UITapGestureRecognizer(target: self, action: #selector(bottomsheetgroupchatinvitedbuttonClicked))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        label.textColor = UIColor.PointBlue
        return label
    }()
    
    private lazy var groupChatList = [
        ChatInfo(chatState: .groupChat,
                 chatTitle: "그룹챗 테스트 그룹챗 테스트 그룹챗 테스트 그룹챗 테스트",
                 participantIDs: ["", "", ""]),
        ChatInfo(chatState: .groupChat,
                 chatTitle: "그룹챗 테스트2",
                 participantIDs: ["", ""])
    ]
    
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
    private var defaultHeight: CGFloat = 300
    
    private var groupChatListTableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = .DarkGray3
        tableview.register(PersonalBottomSheetTableViewCell.self, forCellReuseIdentifier: PersonalBottomSheetTableViewCell.reuseIdentifier)
        tableview.separatorColor = .LightGray2
        tableview.separatorStyle = .singleLine
        tableview.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableview.separatorInsetReference = .fromAutomaticInsets
        tableview.allowsMultipleSelection = true
        return tableview
    }()


    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        configurebottomSheetUI()
        configureTableView()
        groupChatListTableView.delegate = self
        groupChatListTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet()
    }
}

// MARK: - extensions about setting UI
extension InvitedViewController {
    private func configureUI() {
        view.addSubview(dimmedView)
        view.addSubview(bottomSheetView)
        
        dimmedView.alpha = 0.0
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
        
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bottomSheetView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func configurebottomSheetUI() {
        bottomSheetView.addSubview(bottomsheetStackView)
        
        bottomsheetStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
        }
    
        bottomsheetStackView.addArrangedSubview(bottomsheetgroupchatListLabel)
        bottomsheetStackView.addArrangedSubview(bottomsheetgroupchatinvitedbutton)
        bottomsheetStackView.setCustomSpacing(130, after: bottomsheetgroupchatListLabel)
    }
    
    private func configureTableView() {
        bottomSheetView.addSubview(groupChatListTableView)
        
        groupChatListTableView.snp.makeConstraints { make in
            make.top.equalTo(bottomsheetStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func bottomsheetgroupchatinvitedbuttonClicked(sender:UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
        print("tap working")
    }
}

extension InvitedViewController {
    private func showBottomSheet() {
        bottomSheetView.snp.remakeConstraints { make in
            make.top.equalTo(500)
            make.bottom.equalToSuperview()
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 0.8
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideBottomSheetAndGoBack() {
        bottomSheetView.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }

    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
}

extension InvitedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonalBottomSheetTableViewCell.reuseIdentifier) as! PersonalBottomSheetTableViewCell
        let chatinfo: ChatInfo = groupChatList[indexPath.row]
        cell.backgroundColor = .DarkGray3
        cell.titleLabel.text = chatinfo.chatTitle
        cell.participantsCountButton.setTitle("\(chatinfo.participantIDs.count)", for: .normal)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return bottomSheetView.frame.height / 5
    }
}
