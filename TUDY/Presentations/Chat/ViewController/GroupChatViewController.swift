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

private let reuseIdentifier = "MessageCell"

class GroupChatViewController: UICollectionViewController {
    
    // MARK: - Properties
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
    
    private var messages = [Message]()
    let picker = UIImagePickerController()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
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
        configureNavigationBar()
        view.backgroundColor = .DarkGray1
    }
    
    private func configureNavigationBar() {
//        navigationItem.titleView = attributeTitleView("개발자!")
        navigationController?.navigationBar.backgroundColor = .DarkGray2
        navigationItem.backBarButtonItem?.title = ""
        navigationItem.rightBarButtonItem?.tintColor = .PointBlue
    }
    
    
    override var inputAccessoryView: UIView? {
        get { return chatinputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
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

extension GroupChatViewController: NewCustomInputAccessoryViewDelegate {
    func inputView(_ inputView: NewCustomInputAccessoryView, wantsToSend message: String) {
        print(#function)

        guard let chatinfo = self.chatInfo else { return }
        guard let user = UserInfo.shared.user else { return }
        
        if (!message.isEmpty) {
                let message = Message(content: message, imageURL: "", sender: user, createdDate: Date().date())
                FirestoreChat.saveChat(chatInfo: chatinfo, message: message)
                collectionView.reloadData()
        }
        self.collectionView.isPagingEnabled = true
        self.collectionView.scrollToItem(at: [0, self.messages.count - 1], at: .bottom, animated: true)
        self.collectionView.isPagingEnabled = false
        inputView.clearMessage()
    }
}
