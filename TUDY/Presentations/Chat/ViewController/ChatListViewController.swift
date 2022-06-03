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
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .White
        return view
    }()
    
    private var topTapBarCollectionView: UICollectionView!
    private var topTapDataSource: TopTapDataSource!
    private var chatListTableView: UITableView!
    private var chatListDataSource: ChatListDataSource!
    
    private var chatList: [ChatList] = [
        ChatList(chatState: .personalChat,
                 chatNotification: true,
                 bookMark: false,
                 profileImageURL: "",
                 name: "하늘이",
                 latestMessage: "프로젝트 참여 가능한가요?",
                 latestMessageDate: "2022/06/03"),
        ChatList(chatState: .personalChat,
                 chatNotification: true,
                 bookMark: false,
                 profileImageURL: "",
                 name: "장호진",
                 latestMessage: "프로젝트 참여 가능한가요?",
                 latestMessageDate: "2022/06/03"),
        ChatList(chatState: .groupChat,
                 chatNotification: true,
                 bookMark: false,
                 profileImageURL: "",
                 name: "이상운",
                 latestMessage: "프로젝트 참여 가능한가요?",
                 latestMessageDate: "2022/06/03")]
    
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
        view.backgroundColor = .DarkGray1
        
        view.addSubview(topTapBarCollectionView)
        topTapBarCollectionView.backgroundColor = .DarkGray1
        topTapBarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.top.equalTo(topTapBarCollectionView.snp.bottom)
            make.leading.equalToSuperview()
            make.width.equalTo(view.frame.width / 2)
            make.height.equalTo(2)
        }
        
        view.addSubview(chatListTableView)
        chatListTableView.backgroundColor = .DarkGray1
        chatListTableView.snp.makeConstraints { make in
            make.top.equalTo(indicatorView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: CollectionView
    private func configureCollectionView() {
        topTapBarCollectionView = UICollectionView(frame: view.bounds,
                                                   collectionViewLayout: topTapBarlayout())
        topTapBarCollectionView.isScrollEnabled = false
        topTapBarCollectionView.delegate = self
        
        configureCollectionViewDataSource()
    }
    
    private func topTapBarlayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureCollectionViewDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ChatState> {
            cell, indexPath, itemIdentifier in
            var config = cell.defaultContentConfiguration()
            config.text = itemIdentifier.rawValue
            config.textProperties.alignment = .center
            config.textProperties.font = .sub14
            config.textProperties.color = .White
            let backgroundView: UIView = {
                let view = UIView()
                view.backgroundColor = .DarkGray1
                return view
            }()
            cell.backgroundView = backgroundView
            cell.selectedBackgroundView = backgroundView
            cell.contentConfiguration = config
        }
        
        topTapDataSource = TopTapDataSource(collectionView: topTapBarCollectionView, cellProvider: {
            collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                         for: indexPath,
                                                         item: itemIdentifier)
        })
        
        var topTapSnapshot = TopTapSnapshot()
        topTapSnapshot.appendSections([0])
        topTapSnapshot.appendItems([.personalChat, .groupChat])
        topTapDataSource.apply(topTapSnapshot)
    }
    
    // MARK: - TableView
    private func configureTableView() {
        chatListTableView = UITableView(frame: view.bounds, style: .plain)
        chatListTableView.register(ChatListCell.self, forCellReuseIdentifier: ChatListCell.reuseIdentifier)
        chatListTableView.rowHeight = 100
        configureTableViewDataSource()
    }
    
    private func configureTableViewDataSource() {
        chatListDataSource = ChatListDataSource(tableView: chatListTableView,
                                                cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatListCell.reuseIdentifier,
                                                           for: indexPath) as? ChatListCell else { fatalError() }
            cell.chatListInfo = itemIdentifier
            let backgroundView: UIView = {
                let view = UIView()
                view.backgroundColor = .DarkGray3
                return view
            }()
            cell.backgroundView = backgroundView
            cell.selectedBackgroundView = backgroundView
            return cell
        })
        
        var chatListSnapshot = ChatListSnapshot()
        chatListSnapshot.appendSections([0])
        chatListSnapshot.appendItems(chatList.filter { $0.chatState == .personalChat })
        
        chatListDataSource.apply(chatListSnapshot)
    }
    
    private func updateChatListSnapshot(selected: ChatState) {
        var snapshot = ChatListSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(chatList.filter { $0.chatState == selected })
        chatListDataSource.apply(snapshot)
    }
}

// MARK: - UICollectionViewDelegate
extension ChatListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 개인챗, 단체챗 선택시 indicator 이동 애니메이션
        // constraints를 지우고 다시 설정해야합니다. removeConstraints()
        // 안그러면 중복되서 constraints가 안바뀝니다.
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        indicatorView.snp.removeConstraints()
        indicatorView.snp.makeConstraints { make in
            make.top.equalTo(topTapBarCollectionView.snp.bottom)
            make.leading.equalTo(cell.snp.leading)
            make.trailing.equalTo(cell.snp.trailing)
            make.height.equalTo(2)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        // chatList 업데이트
        if indexPath.row == 0 {
            updateChatListSnapshot(selected: .personalChat)
        } else {
            updateChatListSnapshot(selected: .groupChat)
        }
    }
}

// MARK: - UITableViewDelegate
extension ChatListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
