//
//  ChatViewController.swift
//  TUDY
//
//  Created by neuli on 2022/05/23.
//

import UIKit
import CryptoKit

class ChatListViewController: UIViewController {
    
    // MARK: - Properties
    enum Event {
        case showChat(chatInfo: ChatInfo)
        case showLogin
    }
    var didSendEventClosure: ((Event) -> Void)?
    
    typealias TopTapDataSource = UICollectionViewDiffableDataSource<Int, ChatState>
    typealias TopTapSnapshot = NSDiffableDataSourceSnapshot<Int, ChatState>
    typealias ChatListDataSource = UITableViewDiffableDataSource<Int, ChatInfo>
    typealias ChatListSnapshot = NSDiffableDataSourceSnapshot<Int, ChatInfo>
    
    private let openGroupChatButton = UIButton().button(text: "+ 스터디챗 만들기",
                                                        font: .sub16,
                                                        backgroundColor: .PointBlue,
                                                        cornerRadius: 10)
    private let indicatorBackgroundView = UIView().view(backgroundColor: .DarkGray6)
    private let indicatorView = UIView().view(backgroundColor: .White)
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .DarkGray3
        return view
    }()
    
    private var topTapBarCollectionView: UICollectionView!
    private var topTapDataSource: TopTapDataSource!
    private var personalChatListTableView: UITableView!
    private var personalChatListDataSource: ChatListDataSource!
    private var groupChatListTableView: UITableView!
    private var groupChatListDataSource: ChatListDataSource!
    
    private var userChatInfoList: [UserChatInfo] = []
    
    private var groupChatInfoList: [ChatInfo] = [] {
        didSet {
            makeGroupChatListSnapshot()
        }
    }
    
    private var personalChatInfoList: [ChatInfo] = [] {
        didSet {
            makePersonalChatListSnapshot()
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isLogin() {
            configureTableView()
            fetchUserChatInfoList()
            fetchGroupChatList()
            fetchPersonalChatList()
        }
        
        configureCollectionView()
        configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navDisappear()
        tabAppear()
    }
}

extension ChatListViewController {
    
    // MARK: - Methods
    private func configureUI() {
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .DarkGray1
        
        view.addSubview(topTapBarCollectionView)
        topTapBarCollectionView.backgroundColor = .DarkGray2
        topTapBarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(70)
        }
        
        view.addSubview(indicatorBackgroundView)
        indicatorBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(topTapBarCollectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2)
        }
        
        view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.top.equalTo(topTapBarCollectionView.snp.bottom)
            make.leading.equalToSuperview()
            make.width.equalTo(view.frame.width / 2)
            make.height.equalTo(2)
        }
        
        configureOpenGroupChatButtonLayout()
        
        if let groupChatListTableView = groupChatListTableView {
            view.addSubview(groupChatListTableView)
            groupChatListTableView.backgroundColor = .DarkGray1
            groupChatListTableView.snp.makeConstraints { make in
                make.top.equalTo(indicatorBackgroundView.snp.bottom).offset(66)
                make.leading.trailing.bottom.equalToSuperview()
            }
        }
        
        if let personalChatListTableView = personalChatListTableView {
            view.addSubview(personalChatListTableView)
            personalChatListTableView.backgroundColor = .DarkGray1
            personalChatListTableView.snp.makeConstraints { make in
                make.top.equalTo(indicatorBackgroundView.snp.bottom)
                make.leading.trailing.bottom.equalToSuperview()
            }
        }
    }
    
    private func showGroupChatView() {
        groupChatListTableView.isHidden = false
        personalChatListTableView.isHidden = true
        configureOpenGroupChatButtonLayout()
    }
    
    private func showPersonalChatView() {
        groupChatListTableView.isHidden = true
        personalChatListTableView.isHidden = false
        openGroupChatButton.removeFromSuperview()
    }
    
    private func configureOpenGroupChatButtonLayout() {
        openGroupChatButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        view.addSubview(openGroupChatButton)
        openGroupChatButton.snp.makeConstraints { make in
            make.top.equalTo(indicatorBackgroundView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(40)
        }
    }
    
    private func toggleNotification(chatInfoID: String) {
        guard let index = userChatInfoList.firstIndex(where: { $0.chatInfoID == chatInfoID }) else { return }
        userChatInfoList[index].chatNotification.toggle()
    }
    
    private func toggleBookMark(chatInfoID: String) {
        guard let index = userChatInfoList.firstIndex(where: { $0.chatInfoID == chatInfoID }) else { return }
        userChatInfoList[index].bookMark.toggle()
    }
    
    private func showDeleteAlert(_ chatInfo: ChatInfo) {
        let alert = UIAlertController(title: "채팅방 나가기", message: "채팅목록에서 삭제됩니다.", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "나가기", style: .default) { [weak self] _ in
            self?.leaveChat(chatInfo: chatInfo)
        }
        ok.setValue(UIColor.PointRed, forKey: "titleTextColor")
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        cancel.setValue(UIColor.PointBlue, forKey: "titleTextColor")
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
    
    // MARK: - API
    private func fetchGroupChatList() {
        FirebaseChat.fetchChatInfo(chatState: .groupChat) { [weak self] chatInfos in
            self?.groupChatInfoList = chatInfos
        }
    }
    
    private func fetchPersonalChatList() {
        FirebaseChat.fetchChatInfo(chatState: .personalChat) { [weak self] chatInfos in
            self?.personalChatInfoList = chatInfos
        }
    }
    
    private func fetchUserChatInfoList() {
        FirebaseUserChatInfo.fetchUserChatInfos { [weak self] userChatInfos in
            self?.userChatInfoList = userChatInfos
        }
    }
    
    // 그룹챗 생성
    private func makeGroupChat(text title: String) {
        let userID = FirebaseUser.getUserID()
        let chatInfo = ChatInfo(chatState: .groupChat,
                                chatTitle: title,
                                projectMasterID: userID,
                                participantIDs: [userID],
                                latestMessage: "새로운 채팅방이 생성되었습니다.",
                                latestMessageDate: Date().chatListDate())
        FirebaseChat.saveChatInfo(chatInfo)
        fetchUserChatInfoList()
    }
    
    func makePersonalChat(with projectWriter: User) {
        let userID = FirebaseUser.getUserID()
        let projectWriterID = projectWriter.userID
        let chatInfo = ChatInfo(chatState: .personalChat,
                                chatTitle: "",
                                projectMasterID: projectWriterID,
                                participantIDs: [userID, projectWriterID],
                                latestMessage: "새로운 채팅방이 생성되었습니다.",
                                latestMessageDate: Date().chatListDate())
        FirebaseChat.saveChatInfo(chatInfo)
        fetchUserChatInfoList()
        
        let index = IndexPath(index: 1)
        topTapBarCollectionView.selectItem(at: index, animated: true, scrollPosition: .right)
        didSendEventClosure?(.showChat(chatInfo: chatInfo))
    }
    
    func leaveChat(chatInfo: ChatInfo) {
        FirebaseChat.leaveChat(chatInfo: chatInfo)
        FirebaseUserChatInfo.deleteUserChatInfo(at: chatInfo.chatInfoID)
    }
    
    // MARK: - CollectionView
    private func configureCollectionView() {
        topTapBarCollectionView = UICollectionView(frame: .zero,
                                                   collectionViewLayout: topTapBarlayout())
        topTapBarCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        topTapBarCollectionView.isScrollEnabled = false
        topTapBarCollectionView.delegate = self
        topTapBarCollectionView.automaticallyAdjustsScrollIndicatorInsets = false
        
        configureCollectionViewDataSource()
    }
    
    private func topTapBarlayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureCollectionViewDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TopBarCell, ChatState> {
            cell, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .groupChat:
                cell.label.text = "스터디챗"
            case .personalChat:
                cell.label.text = "개인챗"
                cell.label.textColor = .DarkGray6
            }
        }
        
        topTapDataSource = TopTapDataSource(collectionView: topTapBarCollectionView, cellProvider: {
            collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                         for: indexPath,
                                                         item: itemIdentifier)
        })
        
        var topTapSnapshot = TopTapSnapshot()
        topTapSnapshot.appendSections([0])
        topTapSnapshot.appendItems([.groupChat, .personalChat])
        topTapDataSource.apply(topTapSnapshot)
    }
    
    // MARK: - TableView
    private func configureTableView() {
        personalChatListTableView = UITableView(frame: view.bounds, style: .plain)
        personalChatListTableView.delegate = self
        personalChatListTableView.register(PersonalChatListCell.self,
                                           forCellReuseIdentifier: PersonalChatListCell.reuseIdentifier)
        personalChatListTableView.rowHeight = 108
        personalChatListTableView.separatorColor = .DarkGray3
        personalChatListTableView.separatorInset = .init(top: 0, left: 13, bottom: 0, right: 13)
        personalChatListTableView.tableFooterView = UIView(frame: .zero)
        
        groupChatListTableView = UITableView(frame: view.bounds, style: .plain)
        groupChatListTableView.delegate = self
        groupChatListTableView.register(GroupChatListCell.self,
                                        forCellReuseIdentifier: GroupChatListCell.reuseIdentifier)
        groupChatListTableView.rowHeight = 108
        groupChatListTableView.separatorColor = .DarkGray3
        groupChatListTableView.separatorInset = .init(top: 0, left: 13, bottom: 0, right: 13)
        groupChatListTableView.tableFooterView = UIView(frame: .zero)
        
        configureTableViewDataSource()
        personalChatListTableView.isHidden = true
    }
    
    private func configureTableViewDataSource() {
        
        // 개인챗
        personalChatListDataSource = ChatListDataSource(tableView: personalChatListTableView,
                                                        cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonalChatListCell.reuseIdentifier,
                                                           for: indexPath) as? PersonalChatListCell else { return UITableViewCell() }
            cell.chatInfo = itemIdentifier
            cell.backgroundView = self?.backgroundView
            cell.selectedBackgroundView = self?.backgroundView
            return cell
        })
        
        personalChatListDataSource.apply(snapshot(chatState: .personalChat))
        
        // 그룹챗
        groupChatListDataSource = ChatListDataSource(tableView: groupChatListTableView,
                                                     cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupChatListCell.reuseIdentifier,
                                                           for: indexPath) as? GroupChatListCell else { return UITableViewCell() }
            cell.chatInfo = itemIdentifier
            cell.backgroundView = self?.backgroundView
            cell.selectedBackgroundView = self?.backgroundView
            return cell
        })
        
        groupChatListDataSource.apply(snapshot(chatState: .groupChat))
    }
    
    private func snapshot(chatState: ChatState) -> ChatListSnapshot {
        var chatListSnapshot = ChatListSnapshot()
        chatListSnapshot.appendSections([0])
        
        switch chatState {
        case .personalChat:
            chatListSnapshot.appendItems(personalChatInfoList)
        case .groupChat:
            chatListSnapshot.appendItems(groupChatInfoList)
        }
        return chatListSnapshot
    }
    
    private func makeGroupChatListSnapshot() {
        var snapshot = ChatListSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(groupChatInfoList)
        groupChatListDataSource.apply(snapshot)
    }
    
    private func makePersonalChatListSnapshot() {
        var snapshot = ChatListSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(personalChatInfoList)
        personalChatListDataSource.apply(snapshot)
    }
    
    private func updateGroupChatListSnapshot(_ chatInfo: ChatInfo) {
        var snapshot = groupChatListDataSource.snapshot()
        snapshot.reloadItems([chatInfo])
        groupChatListDataSource.apply(snapshot)
    }
    
    private func updatePersonalChatListSnapshot(_ chatInfo: ChatInfo) {
        var snapshot = personalChatListDataSource.snapshot()
        snapshot.reloadItems([chatInfo])
        personalChatListDataSource.apply(snapshot)
    }
}

// MARK: - Actions
extension ChatListViewController {
    
    @objc private func showAlert() {
        
        if !isLogin() {
            didSendEventClosure?(.showLogin)
            return
        }
        
        let alert = UIAlertController(title: "스터디 이름을 입력해주세요.", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.borderStyle = .none
            textField.placeholder = "스터디 이름"
        }
        
        let ok = UIAlertAction(title: "만들기", style: .default) { [weak self] _ in
            if let text = alert.textFields?[0].text {
                self?.makeGroupChat(text: text)
//                self?.fetchGroupChatList()
            }
        }
        ok.setValue(UIColor.PointBlue, forKey: "titleTextColor")
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        cancel.setValue(UIColor.PointRed, forKey: "titleTextColor")
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDelegate
extension ChatListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? TopBarCell else { return }
        let unselectedIndexPath = IndexPath(row: 0, section: 0) == indexPath ? IndexPath(row: 1, section: 0) : IndexPath(row: 0, section: 0)
        guard let unselectedCell = collectionView.cellForItem(at: unselectedIndexPath)  as? TopBarCell else { return }
        
        selectedCell.label.textColor = .White
        unselectedCell.label.textColor = .DarkGray6
        
        // 개인챗, 단체챗 선택시 indicator 이동 애니메이션
        // constraints를 지우고 다시 설정해야합니다. removeConstraints()
        // 안그러면 중복되서 constraints가 안바뀝니다.
        indicatorView.snp.removeConstraints()
        indicatorView.snp.makeConstraints { make in
            make.top.equalTo(topTapBarCollectionView.snp.bottom)
            make.leading.equalTo(selectedCell.snp.leading)
            make.trailing.equalTo(selectedCell.snp.trailing)
            make.height.equalTo(2)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        if !isLogin() {
            return
        }
        
        // chatList 업데이트
        if indexPath.row == 0 {
            showGroupChatView()
        } else {
            showPersonalChatView()
        }
    }
}

// MARK: - UITableViewDelegate
extension ChatListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == personalChatListTableView {
            didSendEventClosure?(.showChat(chatInfo: personalChatInfoList[indexPath.row]))
        } else {
            didSendEventClosure?(.showChat(chatInfo: groupChatInfoList[indexPath.row]))
        }
    }
    
    // MARK: - Swipe actions
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var chatInfo: ChatInfo
        if tableView == groupChatListTableView {
            chatInfo = groupChatInfoList[indexPath.row]
        } else {
            chatInfo = personalChatInfoList[indexPath.row]
        }
        
        // MARK: 스와이프 액션 Delete
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            self?.showDeleteAlert(chatInfo)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.White, renderingMode: .alwaysOriginal)
        deleteAction.backgroundColor = .DarkGray4
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 채팅정보 가져오기
        var chatInfo: ChatInfo
        if tableView == groupChatListTableView {
            chatInfo = groupChatInfoList[indexPath.row]
        } else {
            chatInfo = personalChatInfoList[indexPath.row]
        }
        
        // 유저 채팅 정보 가져오기
        guard let userChatInfo = userChatInfoList.filter({ $0.chatInfoID == chatInfo.chatInfoID }).first else { return nil }
        
        // MARK: 스와이프 액션 알림, 즐겨찾기
        let notificationAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in
            // DB에 알림설정 업데이트
            FirebaseUserChatInfo.updateNotification(chatInfoID: chatInfo.chatInfoID,
                                                    chatNotification: !userChatInfo.chatNotification) {
                self?.toggleNotification(chatInfoID: chatInfo.chatInfoID)
                completion(true)
            }
        }
        
        let notificationImage = userChatInfo.chatNotification ? UIImage(named: "bell.fill") : UIImage(named: "bell.cancel")
        notificationAction.image = notificationImage?.withTintColor(.White, renderingMode: .alwaysOriginal)
        notificationAction.backgroundColor = .LightGray1
        
        // 즐겨찾기 [추후 기능]
//        let bookmarkAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in
//            // DB에 즐겨찾기 설정 업데이트
//            FirebaseUserChatInfo.updateBookMark(chatInfoID: chatInfo.chatInfoID,
//                                                bookMark: !userChatInfo.bookMark) {
//                self?.toggleBookMark(chatInfoID: chatInfo.chatInfoID)
//                switch chatInfo.chatState {
//                case .groupChat:
//                    self?.updateGroupChatListSnapshot(chatInfo)
//                case .personalChat:
//                    self?.updatePersonalChatListSnapshot(chatInfo)
//                }
//                completion(true)
//            }
//        }
//
//        let bookmarkImage = userChatInfo.bookMark ? UIImage(systemName: "pin.fill") : UIImage(systemName: "pin")
//        bookmarkAction.image = bookmarkImage?.withTintColor(.White, renderingMode: .alwaysOriginal)
//        bookmarkAction.backgroundColor = .DarkGray5
        
        return UISwipeActionsConfiguration(actions: [notificationAction])
    }
}

//  MARK: - Login Check
extension ChatListViewController: LoginCheck {}
