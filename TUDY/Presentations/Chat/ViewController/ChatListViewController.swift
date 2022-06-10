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
    
    typealias TopTapDataSource = UICollectionViewDiffableDataSource<Int, ChatState>
    typealias TopTapSnapshot = NSDiffableDataSourceSnapshot<Int, ChatState>
    typealias ChatListDataSource = UITableViewDiffableDataSource<Int, ChatList>
    typealias ChatListSnapshot = NSDiffableDataSourceSnapshot<Int, ChatList>
    
    private let openGroupChatButton = UIButton().button(text: "+ 스터디챗 개설",
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
    
    private var chatList: [ChatList] = [
        ChatList(chatState: .personalChat,
                 chatNotification: false,
                 bookMark: true,
                 chatTitle: "상운",
                 profileImageURL: "",
                 projectMasterID: "",
                 participantIDs: [""],
                 latestMessage: "마지막",
                 latestMessageDate: "1일전"),
        ChatList(chatState: .personalChat,
                 chatNotification: false,
                 bookMark: false,
                 chatTitle: "호진",
                 profileImageURL: "",
                 projectMasterID: "",
                 participantIDs: [""],
                 latestMessage: "마지막 메세지 마지막 메세지 마지막 메세지",
                 latestMessageDate: "3일전"),
        ChatList(chatState: .groupChat,
                 chatNotification: false,
                 bookMark: true,
                 chatTitle: "그룹챗 테스트",
                 profileImageURL: "",
                 projectMasterID: "",
                 participantIDs: ["", "", ""],
                 latestMessage: "마지막",
                 latestMessageDate: "1일전"),
        ChatList(chatState: .groupChat,
                 chatNotification: false,
                 bookMark: false,
                 chatTitle: "그룹챗 테스트2",
                 profileImageURL: "",
                 projectMasterID: "",
                 participantIDs: ["", ""],
                 latestMessage: "마지막",
                 latestMessageDate: "1일전")
    ]
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureTableView()
        configureUI()
    }
}

extension ChatListViewController {
    
    // MARK: - Methods
    private func configureUI() {
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .DarkGray1
        
        view.addSubview(topTapBarCollectionView)
        topTapBarCollectionView.backgroundColor = .DarkGray1
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
        
        view.addSubview(groupChatListTableView)
        groupChatListTableView.backgroundColor = .DarkGray1
        groupChatListTableView.snp.makeConstraints { make in
            make.top.equalTo(indicatorBackgroundView.snp.bottom).offset(80)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        view.addSubview(personalChatListTableView)
        personalChatListTableView.backgroundColor = .DarkGray1
        personalChatListTableView.snp.makeConstraints { make in
            make.top.equalTo(indicatorBackgroundView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
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
        view.addSubview(openGroupChatButton)
        openGroupChatButton.snp.makeConstraints { make in
            make.top.equalTo(indicatorBackgroundView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(40)
        }
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
        personalChatListTableView.register(PersonalChatListCell.self, forCellReuseIdentifier: PersonalChatListCell.reuseIdentifier)
        personalChatListTableView.rowHeight = 100
        
        groupChatListTableView = UITableView(frame: view.bounds, style: .plain)
        groupChatListTableView.register(GroupChatListCell.self, forCellReuseIdentifier: GroupChatListCell.reuseIdentifier)
        groupChatListTableView.rowHeight = 100
        configureTableViewDataSource()
        
        personalChatListTableView.isHidden = true
    }
    
    private func configureTableViewDataSource() {
        
        // 개인챗
        personalChatListDataSource = ChatListDataSource(tableView: personalChatListTableView,
                                                cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonalChatListCell.reuseIdentifier,
                                                           for: indexPath) as? PersonalChatListCell else { fatalError() }
            cell.chatListInfo = itemIdentifier
            cell.backgroundView = self.backgroundView
            cell.selectedBackgroundView = self.backgroundView
            return cell
        })
        
        personalChatListDataSource.apply(snapshot(chatState: .personalChat))
        
        // 그룹챗
        groupChatListDataSource = ChatListDataSource(tableView: groupChatListTableView,
                                                     cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupChatListCell.reuseIdentifier,
                                                           for: indexPath) as? GroupChatListCell else { fatalError() }
            cell.chatListInfo = itemIdentifier
            cell.backgroundView = self.backgroundView
            cell.selectedBackgroundView = self.backgroundView
            return cell
        })
        
        groupChatListDataSource.apply(snapshot(chatState: .groupChat))
    }
    
    private func snapshot(chatState: ChatState) -> ChatListSnapshot {
        var chatListSnapshot = ChatListSnapshot()
        chatListSnapshot.appendSections([0])
        chatListSnapshot.appendItems(chatList.filter { $0.chatState == chatState })
        return chatListSnapshot
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
    }
}
