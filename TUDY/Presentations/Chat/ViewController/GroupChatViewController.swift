//
//  ChatViewController.swift
//  TUDY
//
//  Created by neuli on 2022/06/13.
//

import UIKit
import SnapKit
import KakaoSDKUser
import Firebase
import FirebaseDatabase
import SideMenu

private let reuseIdentifier = "MessageCell"

class GroupChatViewController: UICollectionViewController {
    
    // MARK: - Properties
    enum MenuState {
        case opened
        case closed
    }
    
    private var menuState: MenuState = .closed
    
    var chatInfo: ChatInfo? {
        didSet {
            configureUI()
        }
    }
    
    private lazy var chatinputView: NewCustomInputAccessoryView = {
        let iv = NewCustomInputAccessoryView(frame: CGRect(x: 0,
                                                           y: 0,
                                                           width: view.frame.width,
                                                           height: 50))
        iv.delegate = self
        return iv
    }()
    
    var isSlideInMenuPresented = false
    lazy var slideInMenuPadding: CGFloat = self.view.frame.width * 0.3
    private var otherUserInfoArr = [String]()
    private var otherAllUserArr = [User]()
    private var messages = [Message]()
    let picker = UIImagePickerController()
    
    lazy var menuView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    private let sideMenu = SideMenuNavigationController(rootViewController: UIViewController())

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMessage()
        configureUI()
        configureNavigationBar()
        chatinputView.photoButton.addTarget(self, action: #selector(handlephoto), for: .touchUpInside)
        configureDelegate()
//        view.addSubview(menuView)
        SideMenuManager.default.rightMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navAppear()
        tabDisappear()
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GroupChatViewController {
    
    // MARK: - Methods
    private func configureUI() {
        collectionView.backgroundColor = .DarkGray1
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .DarkGray2
        self.navigationItem.title = self.chatInfo?.chatTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ham"), style: .plain, target: self, action: #selector(sideMenuButtonClicked(_:)))
    }
    
    @objc func sideMenuButtonClicked(_ sender: Any) {
  
        present(sideMenu, animated: true)
//        switch menuState {
//            case .closed:
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
//                self.menuView.frame.origin.x = self.view.frame.size.width - 100
//            } completion: { [weak self] done in
//                if done {
//                    self?.menuState = .opened
//                }
//            }
//        case .opened:
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
//                self.menuView.frame.origin.x = 0
//            } completion: { [weak self] done in
//                if done {
//                    self?.menuState = .closed
//                }
//            }
//        }
        
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
//            self.view.frame.origin.x = self.isSlideInMenuPresented ? 0 : self.view.frame.width - self.slideInMenuPadding
//        } completion: { (finished) in
//            print("finished : \(finished)")
//            self.isSlideInMenuPresented.toggle()
//        }

    }
    
    override var inputAccessoryView: UIView? {
        get { return chatinputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func configureDelegate() {
        picker.delegate = self
    }
}

// MARK: - ChatProtocol
extension GroupChatViewController: ChatProtocol {
    
}

extension GroupChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handlephoto() {
        let alert = UIAlertController(title: "사진을 골라주세요.", message: "원하시는 버튼을 클릭해주세요.", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
        }
        let camera = UIAlertAction(title: "카메라", style: .default) { (action) in self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(camera)
        alert.addAction(library)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        } else {
            print("Camera not available")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            // 채팅 사진을 넣어주면 됨
            // imageView.image = image
            print(info)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension GroupChatViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MessageCell else { return UICollectionViewCell() }
        cell.message = messages[indexPath.row]
        cell.message?.sender = messages[indexPath.row].sender

        return cell
    }
}

extension GroupChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let estimatedSizeCell = MessageCell(frame: frame)
        estimatedSizeCell.message = messages[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
        
        return .init(width: view.frame.width, height: estimatedSize.height)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
}

extension GroupChatViewController {
    private func fetchMessage() {
        guard let chatInfo = self.chatInfo else { return }

        
        FirestoreChat.fetchChat(chatInfo: chatInfo) { [weak self] message in
            print("============================================================THIS IS OBSERVECHAT!============================================================")
            if ((self?.messages.isEmpty) != nil) {
                self?.messages = message
            } else {
                self?.messages.append(message[message.count - 1])
            }
            guard let messsageCount = self?.messages.count else { return }
            self?.collectionView.reloadData()
            self?.collectionView.scrollToItem(at: [0, messsageCount - 1], at: .bottom, animated: false)
            self?.collectionView.layoutIfNeeded()
        }
    }
    
    private func getAllOtherUserID() -> [String]{
        let myinfo = UserInfo.shared
        
        if let chatInfo = chatInfo {
            for others in chatInfo.participantIDs {
                if (myinfo.user?.userID != others) {
                    otherUserInfoArr.append(others)
                }
            }
        }
        return otherUserInfoArr
    }
    
    private func getOtherUserToken(content : String) {
        guard let chatinfo = self.chatInfo else { return }
        guard let user = UserInfo.shared.user else { return }
        getOtherUserInfo()
        for otheruser in otherUserInfoArr {
            FirebaseFCMToken.fetchFCMToken(userID: otheruser) { [weak self] token in
                if (!content.isEmpty) {
                        let message = Message(content: content, imageURL: "", sender: user, createdDate: Date().date())
                        print("message : \(message)")
                        FirestoreChat.saveChat(chatInfo: chatinfo, message: message)
                        FCMDataManager.sendMessage(chatinfo.chatInfoID, message, fcmToken: token)
                        self?.collectionView.reloadData()
                }
            }
        }
        
    }
    
    private func getOtherUserInfo() {
        FirebaseUser.fetchAllOtherUser(userID: getAllOtherUserID()) { [weak self] user in
            self?.otherAllUserArr = user
        }
    }
 
}

extension GroupChatViewController: NewCustomInputAccessoryViewDelegate {
    func inputView(_ inputView: NewCustomInputAccessoryView, wantsToSend message: String) {
        print(#function)

        guard let chatinfo = self.chatInfo else { return }
        guard let user = UserInfo.shared.user else { return }
        print("===========IS IT WORKING? =============")
        getOtherUserToken(content: message)
        print("===========IS IT WORKING? =============")
        self.collectionView.isPagingEnabled = true
        self.collectionView.scrollToItem(at: [0, self.messages.count - 1], at: .bottom, animated: true)
        self.collectionView.isPagingEnabled = false
        inputView.clearMessage()
    }
}
