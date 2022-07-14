//
//  NewPersonalChatVIewController.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/07/12.
//

import UIKit
import SnapKit
import KakaoSDKUser
import Firebase
import FirebaseDatabase

private let reuseIdentifier = "MessageCell"

class NewPersonalChatViewController: UICollectionViewController {
    
    // MARK: properties
    var chatInfo: ChatInfo? {
        didSet {
            configureUI()
        }
    }
    private var otherUserInfo: User?
    private var otherUserToken: String?
    private var messages = [Message]()
    let picker = UIImagePickerController()

    
    private lazy var chatinputView: NewCustomInputAccessoryView = {
        let iv = NewCustomInputAccessoryView(frame: CGRect(x: 0,
                                                           y: 0,
                                                           width: view.frame.width,
                                                           height: 50))
        iv.delegate = self
        return iv
    }()
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMessage()
        configureUI()
        configureDelegate()
        getOtherUserInfo()
        getOtherUserToken()
        chatinputView.photoButton.addTarget(self, action: #selector(handlephoto), for: .touchUpInside)

        hideKeyboardWhenTappedAround()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         let touch = touches.first as! UITouch
         if touch.view == collectionView {
             self.chatinputView.messageInputTextView.resignFirstResponder()
         }
     }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navAppear()
        tabDisappear()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardUp(notification:NSNotification) {
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
       
            UIView.animate(
                withDuration: 0.2
                , animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: 40-keyboardRectangle.height)
                }
            )
        }
    }
    
    @objc func keyboardDown(notification:NSNotification) {
        self.view.transform = .identity
        
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
       
            UIView.animate(
                withDuration: 0.2
                , animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: 0)
                }
            )
        }
    }
    
    override var inputAccessoryView: UIView? {
        get { return chatinputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}

// MARK: Helpers
extension NewPersonalChatViewController {
    func configureUI() {
        collectionView.backgroundColor = .DarkGray1

        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        configureNavigationBar()

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
    
    func configureDelegate() {
        picker.delegate = self
    }
}

extension NewPersonalChatViewController {
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

extension NewPersonalChatViewController: UICollectionViewDelegateFlowLayout {
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

extension NewPersonalChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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


// MARK: - ChatProtocol
extension NewPersonalChatViewController: ChatProtocol {
    
}


extension NewPersonalChatViewController {
    @objc func invitedButtonClicked() {
        guard let otheruserinfo = otherUserInfo else { return }
        let invitedVC = InvitedViewController(User: otheruserinfo)
        invitedVC.modalPresentationStyle = .overFullScreen
        self.present(invitedVC, animated: false, completion: nil)
    }
    
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
    
    private func getOtherUserToken() {
        FirebaseFCMToken.fetchFCMToken(userID: getOtherUserID()) { [weak self] token in
            self?.otherUserToken = token
        }
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

extension NewPersonalChatViewController: NewCustomInputAccessoryViewDelegate {
    func inputView(_ inputView: NewCustomInputAccessoryView, wantsToSend message: String) {
        print(#function)

        guard let chatinfo = self.chatInfo else { return }
        guard let user = UserInfo.shared.user else { return }
        guard let otherusertoken = otherUserToken else { return }
        
        if (!message.isEmpty) {
                let message = Message(content: message, imageURL: "", sender: user, createdDate: Date().date())
                FirestoreChat.saveChat(chatInfo: chatinfo, message: message)
                FCMDataManager.sendMessage(chatinfo.chatInfoID, message, fcmToken: otherusertoken)
                collectionView.reloadData()
        }

//        self.collectionView.isPagingEnabled = true
        self.collectionView.scrollToItem(at: [0, self.messages.count - 1], at: .bottom, animated: true)
//        self.collectionView.isPagingEnabled = false
        inputView.clearMessage()
    }
}

//extension NewPersonalChatViewController {
//    func scrollToBottom() {
//        let offsetY = self.collectionViewLayout.collectionViewContentSize.height - self.bounds.size.height
//        self.
//        self.setContentOffset(CGPoint(x: 0, y: offsetY > 0 ? offsetY : 0 ), animated: true)
//    }
//}

