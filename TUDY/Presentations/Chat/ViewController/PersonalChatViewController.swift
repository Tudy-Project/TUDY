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
    
    enum Event {
        case showChat(chatInfo: ChatInfo)
        case showLogin
    }
    var didSendEventClosure: ((Event) -> Void)?
    
    var bottomLayoutConstrain : NSLayoutConstraint?

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
        cv.keyboardDismissMode = .interactive
        return cv
    }()
    
    private func attributeTitleView(_ title: String) -> UIView {
        let label: UILabel = UILabel()
        let boldText: NSMutableAttributedString =
        NSMutableAttributedString(string: title, attributes: [
            .foregroundColor: UIColor.White,
            .font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ])
        
        let naviTitle: NSMutableAttributedString = boldText
        label.attributedText = naviTitle
        
        return label
    }
    
    let picker = UIImagePickerController()
    var listener: ListenerRegistration?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMessage()
        configureUI()
        configureDelegate()
        getOtherUserInfo()
        hideKeyboardWhenTappedAround()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chatinputView.messageInputTextView.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navAppear()
        tabDisappear()
//        self.addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.removeKeyboardNotifications()
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
        
        personalChatCV.showsVerticalScrollIndicator = false
        configureNavigationBar()
        chatinputView.photoButton.addTarget(self, action: #selector(handlephoto), for: .touchUpInside)
        
        view.addSubview(personalChatCV)
        personalChatCV.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.titleView = attributeTitleView("개발자!")
        navigationController?.navigationBar.backgroundColor = .DarkGray2
        navigationItem.backBarButtonItem?.title = ""
        if (UserInfo.shared.user?.userID == chatInfo?.projectMasterID) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "초대", style: .plain, target: self, action: #selector(invitedButtonClicked))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem()
        }
        navigationItem.rightBarButtonItem?.tintColor = .PointBlue
    }
    
    private func addKeyBoardNotification() {
            // 1) 키보드가 올라올 때
            NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            // 2) 키보드가 내려갈 때
            NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
    @objc private func keyBoardWillShow(_ noti : Notification){
            guard let userInfo = noti.userInfo else {return}
            
            if let keyBoardFrame : NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                print( "cgRectVale : " ,keyBoardFrame.cgRectValue)
                print("widht : " ,keyBoardFrame.cgRectValue.width)
                print("height : " ,keyBoardFrame.cgRectValue.height)
                            
                bottomLayoutConstrain?.isActive = false
                
                UIView.animate(withDuration: 0) {
                    self.bottomLayoutConstrain = self.personalChatCV.bottomAnchor.constraint(equalTo: self.chatinputView.bottomAnchor, constant: -keyBoardFrame.cgRectValue.height)
                    
                    self.bottomLayoutConstrain?.isActive = true
                    
                    self.view.layoutIfNeeded()
                } completion: { _ in
                    
                    let indexPathItem = IndexPath(item: self.messages.count - 1, section: 0)
                    self.personalChatCV.scrollToItem(at: indexPathItem, at: .bottom, animated: true)
                }
            }
        }
    
    @objc private func keyBoardWillHide(_ noti : Notification){
            
      bottomLayoutConstrain?.isActive = false

        self.bottomLayoutConstrain = self.personalChatCV.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)

      UIView.animate(withDuration: 0) {

          self.bottomLayoutConstrain?.isActive = true

          self.view.layoutIfNeeded()
      }

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

        
        FirestoreChat.observeChat(chatInfo: chatInfo) { [weak self] message in
            if ((self?.messages.isEmpty) != nil) {
                self?.messages = message
            } else {
                self?.messages.append(message[message.count - 1])
            }
            guard let messsageCount = self?.messages.count else { return }
            self?.personalChatCV.reloadData()
            self?.personalChatCV.layoutIfNeeded()
            self?.personalChatCV.scrollToItem(at: [0, messageCount - 1], at: .bottom, animated: false)
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

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MessageCell else { return UICollectionViewCell() }
        cell.message = messages[indexPath.row]
        cell.message?.sender = messages[indexPath.row].sender

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
        print(#function)

        guard let chatinfo = self.chatInfo else { return }
        guard let user = UserInfo.shared.user else { return }
        
        if (!message.isEmpty) {
                let message = Message(content: message, imageURL: "", sender: user, createdDate: Date().date())
                FirestoreChat.saveChat(chatInfo: chatinfo, message: message)
                personalChatCV.reloadData()
        }
        self.personalChatCV.isPagingEnabled = true
        self.personalChatCV.scrollToItem(at: [0, self.messages.count - 1], at: .bottom, animated: true)
        self.personalChatCV.isPagingEnabled = false
        inputView.clearMessage()
        
        let bottomOffset = CGPoint(x: 0, y: personalChatCV.contentSize.height - personalChatCV.bounds.height + personalChatCV.contentInset.bottom)
        personalChatCV.setContentOffset(bottomOffset, animated: true)

    }
}










// MARK: - ChatProtocol
extension PersonalChatViewController: ChatProtocol {
    
}
