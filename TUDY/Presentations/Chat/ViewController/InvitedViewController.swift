//
//  InvitedViewController.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/06/15.
//

import UIKit

class InvitedViewController: UIViewController {
    // MARK: - Properties
    
    private var otherUser: User
    private var groupChatInfoList: [ChatInfo] = []
    private var selectedGroupChatInfoList: [ChatInfo] = []
    private var chatInfo: ChatInfo?

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
    
    private lazy var bottomSheetnogroupchatLabel: UILabel = {
        let label = UILabel().label(text: "진행중인 스터디 챗이 없어요!", font: .sub20)
        return label
    }()
    
    private lazy var bottomSheetMakeGroupChatButton: UIButton = {
        let button = UIButton().button(text: "스터디챗 개설하기", font: UIFont.sub16, fontColor: UIColor.white, backgroundColor: UIColor.PointBlue, cornerRadius: 15)
        button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        return button
    }()

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
    init(User: User) {
        self.otherUser = User
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configurebottomSheetUI()
        configureDelegate()
        fetchGroupChatList()
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
    }
    
    private func configureTableView() {
        bottomSheetView.addSubview(groupChatListTableView)
        
        groupChatListTableView.snp.makeConstraints { make in
            make.top.equalTo(bottomsheetStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configureNoChat() {
        bottomSheetView.addSubview(bottomSheetnogroupchatLabel)
        bottomSheetView.addSubview(bottomSheetMakeGroupChatButton)
        
        bottomSheetnogroupchatLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.centerX.equalToSuperview()
        }
        bottomSheetMakeGroupChatButton.snp.makeConstraints { make in
            make.top.equalTo(bottomSheetnogroupchatLabel.snp.bottom).offset(15)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
        }
    }
    
    func configureDelegate() {
        groupChatListTableView.delegate = self
        groupChatListTableView.dataSource = self
    }
    
    @objc func bottomsheetgroupchatinvitedbuttonClicked(sender:UITapGestureRecognizer) {
        
        print("selectedGroupChatInfoList : \(selectedGroupChatInfoList)")
        
        FirebaseUserChatInfo.addGroupChat(invitedGroupChatInfoID: selectedGroupChatInfoList, invitedUserID: self.otherUser.userID)
        
        hideBottomSheetAndGoBack()
    }
}

// MARK: - about BottomSheet
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
    
    @objc private func showAlert() {

        let alert = UIAlertController(title: "스터디 이름을 입력해주세요.", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.borderStyle = .none
            textField.placeholder = "스터디 이름"
        }
        let ok = UIAlertAction(title: "만들기", style: .default) { [weak self] _ in
            if let text = alert.textFields?[0].text {
                self?.makeGroupChat(text: text)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        ok.setValue(UIColor.PointBlue, forKey: "titleTextColor")
        cancel.setValue(UIColor.PointRed, forKey: "titleTextColor")
        
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}

// MARK: - about Firebase
extension InvitedViewController {
    private func makeGroupChat(text title: String) {
        let userID = FirebaseUser.getUserID()
        let chatInfo = ChatInfo(chatState: .groupChat,
                                chatTitle: title,
                                projectMasterID: userID,
                                participantIDs: [userID],
                                latestMessage: "새로운 채팅방이 생성되었습니다.",
                                latestMessageDate: Date().date())
        FirebaseChat.saveChatInfo(chatInfo)
    }
    
    private func fetchGroupChatList() {
        FirebaseChat.fetchChatInfo(chatState: .groupChat) { [weak self] chatInfos in
            self?.groupChatInfoList = chatInfos
            if (chatInfos.isEmpty) {
                self?.configureNoChat()
            } else {
                if let button = self?.bottomsheetgroupchatinvitedbutton,
                    let label = self?.bottomsheetgroupchatListLabel {
                    self?.bottomsheetStackView.addArrangedSubview(button)
                    self?.bottomsheetStackView.setCustomSpacing(130, after: label)
                }
                self?.configureTableView()
            }
        }
    }
}

// MARK: - about delegate and DataSource
extension InvitedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupChatInfoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonalBottomSheetTableViewCell.reuseIdentifier) as! PersonalBottomSheetTableViewCell
        let chatinfo: ChatInfo = groupChatInfoList[indexPath.row]
        cell.backgroundColor = .DarkGray3
        cell.titleLabel.text = chatinfo.chatTitle
        cell.participantsCountButton.setTitle("\(chatinfo.participantIDs.count)", for: .normal)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return bottomSheetView.frame.height / 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("===========================================================")
        selectedGroupChatInfoList.append(groupChatInfoList[indexPath.row])
        print("selectedGroupChatInfoList : \(selectedGroupChatInfoList)")
        print("===========================================================")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedGroupChatInfoList.removeAll { $0 == groupChatInfoList[indexPath.row]}
    }
}
