//
//  PersonalChatViewController.swift
//  TUDY
//
//  Created by neuli on 2022/06/13.
//

import UIKit
import SnapKit
import KakaoSDKUser
import Firebase
import FirebaseDatabase

private let reuseIdentifier = "MessageCell"

class PersonalChatViewController: UIViewController {
    
    // MARK: - Properties
    var chatInfo: ChatInfo? {
        didSet {
            configureUI()
        }
    }
    private var otherUserInfo: User?
    private var messages = [Message]()
    private lazy var chatinputView: ChatInputAccessoryView = {
        let iv = ChatInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        iv.delegate = self
        return iv
    }()
    
    lazy var personalChatCV: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .DarkGray1
        cv.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    let picker = UIImagePickerController()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad 시작")
        fetchMessage()
        configureUI()
        configureDelegate()
        getOtherUserInfo()
        hideKeyboardWhenTappedAround()
        print("viewDidLoad 끝")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navAppear()
        tabDisappear()
    }
    
    override var inputAccessoryView: UIView? {
        get { return chatinputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}

extension PersonalChatViewController {
    

    // MARK: - Methods
    func configureDelegate() {
        personalChatCV.delegate = self
        personalChatCV.dataSource = self
        picker.delegate = self
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PersonalChatViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        personalChatCV.addGestureRecognizer(tap)
        
    }
    
    private func configureUI() {
        view.backgroundColor = .DarkGray1
        
        configureNavigationBar()
        personalChatCV.keyboardDismissMode = .interactive
        chatinputView.photoButton.addTarget(self, action: #selector(handlephoto), for: .touchUpInside)
        
        view.addSubview(personalChatCV)
        personalChatCV.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .DarkGray2
        navigationItem.backBarButtonItem?.title = ""
        if (UserInfo.shared.user?.userID == chatInfo?.projectMasterID) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "초대", style: .plain, target: self, action: #selector(invitedButtonClicked))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem()
        }
        navigationItem.rightBarButtonItem?.tintColor = .PointBlue
    }
}
// MARK: - extensions
extension PersonalChatViewController {
    @objc func invitedButtonClicked() {
        guard let otheruserinfo = otherUserInfo else { return }
        let invitedVC = InvitedViewController(User: otheruserinfo)
        invitedVC.modalPresentationStyle = .overFullScreen
        self.present(invitedVC, animated: false, completion: nil)
    }
    
    private func fetchMessage() {
        guard let chatInfo = self.chatInfo else { return }
        
        FirebaseRealtimeChat.fetchChat(chatInfoID: chatInfo.chatInfoID) { [weak self] message in
            for msg in message {
                self?.messages.append(msg)
            }
            self?.personalChatCV.reloadData()
            guard let messageCount = self?.messages.count else { return }
            self?.personalChatCV.scrollToItem(at: [0, messageCount - 1], at: .bottom, animated: true)
        }
    }
    
    private func getOtherUserID() -> String {
        let myinfo = UserInfo.shared
        var otherID: String = ""
        
        if let chatInfo = chatInfo {
            for others in chatInfo.participantIDs {
                if (myinfo.user?.userID != others) {
                    otherID = others
                }
            }
        }
        return otherID
    }
    
    private func getOtherUserInfo() {
        FirebaseUser.fetchOtherUser(userID: getOtherUserID()) { [weak self] user in
            self?.otherUserInfo = user
            self?.navigationItem.title = self?.otherUserInfo?.nickname
        }
        if otherUserInfo == nil {
            self.navigationItem.title = "알 수 없는 유저"
        }
    }
}

extension PersonalChatViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("collectionView 시작")

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MessageCell else { return UICollectionViewCell() }
        cell.message = messages[indexPath.row]
        cell.message?.sender = messages[indexPath.row].sender
        print("collectionView 끝")

        return cell
    }
}


extension PersonalChatViewController: UICollectionViewDelegateFlowLayout {
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

extension PersonalChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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

// 여기서 하는 것이 아니라 MESSAGECELL에서 해야하는건가?
extension PersonalChatViewController: ChatInputAccessoryViewDelegate {
    func inputView(_ inputView: ChatInputAccessoryView, wantsToSend message: String) {
        
        guard let chatinfo = self.chatInfo else { return }
        guard let user = UserInfo.shared.user else { return }
        
        if (!message.isEmpty) {
                let message = Message(content: message, imageURL: "", sender: user, createdDate: Date().chatDate())
                messages.append(message)
                FirebaseRealtimeChat.saveChat(chatInfoID: chatinfo.chatInfoID, message: message)
                personalChatCV.reloadData()
        }
        inputView.clearMessage()
    }
}










// MARK: - ChatProtocol
extension PersonalChatViewController: ChatProtocol {
    
}
