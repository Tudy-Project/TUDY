//
//  ProjectDetailViewController.swift
//  TUDY
//
//  Created by jamescode on 2022/05/30.
//

import UIKit
import SDWebImage

class ProjectDetailViewController: UIViewController {
    
    enum Event {
        case showPersonalChat(projectWriter: User)
    }
    
    var didSendEventClosure: ((Event) -> Void)?
    
    // MARK: - Properties
    
    var project: Project? {
        didSet {
            configureProject()
        }
    }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var detailTitle: UILabel = {
        let label = UILabel().label(text: testData().title[0] , font: UIFont.sub20, color: UIColor.White, numberOfLines: 2)
        return label
    }()
    
    private lazy var detailDesc: UILabel = {
        let label = UILabel().label(text:testData().descLongText[0], font: UIFont.body14, color: .White)
        let attrString = NSMutableAttributedString(string: label.text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        label.attributedText = attrString
        return label
    }()
    
    private lazy var authorName: UILabel = {
        let label = UILabel().label(text: testData().author[0], font: UIFont.caption11, color: .White)
        return label
    }()
    
    lazy var authorImage: UIImageView = {
        let ImageView = UIImageView()
        ImageView.backgroundColor = .White
        ImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        ImageView.contentMode = .scaleAspectFill
        ImageView.layer.cornerRadius = ImageView.frame.width / 2
        ImageView.clipsToBounds = true
        return ImageView
    }()
    
    private lazy var photoCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.minimumLineSpacing = 10
        flowlayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:  flowlayout)
        collectionView.backgroundColor = .DarkGray1
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private let uploadDate = UILabel().label(text: "2022/4/12  14:02", font: UIFont.caption12, color: .White)
    
    private let grayBlock: UIView = {
        let view = UIView()
        view.backgroundColor = .DarkGray2
        return view
    }()
    
    private let projectConditionsLabel = UILabel().label(text: "프로젝트 조건 💡", font: UIFont.sub20, color: .white)
    private let personnelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    private let personnelTitle = UILabel().label(text: "인원", font: UIFont.sub14, color: .White)
    private let personnelLabel = UILabel().label(text: "5명", font: UIFont.sub14, color: .White)
    
    private let estimatedDurationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    private let estimatedDurationTitle = UILabel().label(text: "예상 기간", font: UIFont.sub14, color: .White)
    private let estimatedDurationLabel = UILabel().label(text: "6주", font: UIFont.sub14, color: .White)
    
    private let bottomTabView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    private lazy var chatButton: UIButton = {
        let button = UIButton()
        button.setTitle("💬 채팅보내기", for: .normal)
        button.titleLabel?.font = .sub16
        button.backgroundColor = .PointBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapChatButton), for: .touchUpInside)
        return button
    }()
    
    private var chatButtonEvent = ChatButtonEvent.sendChat
    
    private lazy var heartButton: HeartButton = {
        let button = HeartButton()
        button.sizeToFit()
        button.setState(false)
        button.addTarget(self, action: #selector(heartButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private let heartCount = UILabel().label(text: "12", font: UIFont.sub14, color: .White)
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavSettings()
        configureUI()
        tabDisappear()
    }
}

// MARK: - @objc
extension ProjectDetailViewController {
    @objc func didTapChatButton() {
        
        switch chatButtonEvent {
        case .sendChat: // 채팅보내기
            sendChat()
        case .changeFinishRecruit: // 모집완료로 변경
            showAlert(.changeFinishRecruit)
        case .changeRecruit: // 모집중으로 변경
            showAlert(.changeRecruit)
        case .finishRecruit: // 모집이 완료된 게시글입니다.
            break
        }
    }
    
    @objc func heartButtonTapped(_ sender: HeartButton) {
        guard let project = project else { return }
        FirebaseUser.updateLikeProjectID(projectID: project.projectId) { [weak self] result in
            self?.heartButton.setState(result)
            let update = result ? 1 : -1
            self?.updateHeartCount(update)
        }
    }
}

// MARK: - Methods
extension ProjectDetailViewController {
    
    private func configureProject() {
        guard let project = project else { return }
        detailTitle.text = project.title
        detailDesc.text = project.content
        FirebaseUser.fetchOtherUser(userID: project.writerId) { [unowned self] user in
            authorName.text = user.nickname
            guard let url = URL(string: user.profileImageURL) else { return }
            authorImage.sd_setImage(with: url)
        }
        
        if project.isRecruit && project.writerId == UserInfo.shared.user?.userID {
            chatButton.setTitle("모집완료로 변경", for: .normal)
            chatButton.backgroundColor = .DarkGray4
            chatButtonEvent = .changeFinishRecruit
        } else if !project.isRecruit && project.writerId == UserInfo.shared.user?.userID {
            chatButton.setTitle("모집중으로 변경", for: .normal)
            chatButton.backgroundColor = .DarkGray4
            chatButtonEvent = .changeRecruit
        } else if !project.isRecruit {
            chatButton.setTitle("모집이 완료된 게시글입니다.", for: .normal)
            chatButton.backgroundColor = .DarkGray3
            chatButton.isEnabled = false
            chatButtonEvent = .finishRecruit
        }
        uploadDate.text = project.writeDate.projectDate()
        personnelLabel.text = "\(project.maxPeople)명"
        estimatedDurationLabel.text = "\(project.endDate)주"
        heartCount.text = "\(project.favoriteCount)"
        
        FirebaseUser.fetchUser { [unowned self] user in
            if user.likeProjectIDs.contains(project.projectId) {
                heartButton.setState(true)
            }
        }
    }
    
    private func configureNavSettings() {
        view.backgroundColor = .DarkGray1
        navigationController?.navigationBar.backgroundColor = .DarkGray2
        title = ""
        //네비게이션바 왼쪽 타이틀
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        
        let moreVertical = UIBarButtonItem(image: UIImage(named: "more_vertical"), style: UIBarButtonItem.Style.plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [moreVertical]
    }
    
    private func configureUI() {
        
        view.addSubview(scrollView)
        view.addSubview(bottomTabView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(bottomTabView.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        
        bottomTabView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(68)
            make.width.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.addSubview(detailTitle)
        detailTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.leading.equalToSuperview().offset(30)
            make.width.equalTo(248)
            make.height.equalTo(60)
        }
        
        contentView.addSubview(detailDesc)
        detailDesc.snp.makeConstraints { make in
            make.top.equalTo(detailTitle.snp.bottom).offset(55)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        contentView.addSubview(authorImage)
        authorImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.trailing.equalToSuperview().offset(-40)
            make.width.height.equalTo(50)
        }
        
        contentView.addSubview(authorName)
        authorName.snp.makeConstraints { make in
            make.top.equalTo(authorImage.snp.bottom).offset(5)
            make.centerX.equalTo(authorImage)
        }
        
        contentView.addSubview(photoCollectionView)
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(detailDesc.snp.bottom).offset(20)
            make.height.equalTo(80)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        contentView.addSubview(uploadDate)
        uploadDate.snp.makeConstraints { make in
            make.top.equalTo( photoCollectionView.snp.bottom).offset(77)
            make.leading.equalToSuperview().offset(30)
        }
        
        contentView.addSubview(grayBlock)
        grayBlock.snp.makeConstraints { make in
            make.top.equalTo(uploadDate.snp.bottom).offset(23)
            make.width.equalToSuperview()
            make.height.equalTo(5)
        }
        
        contentView.addSubview(projectConditionsLabel)
        projectConditionsLabel.snp.makeConstraints { make in
            make.top.equalTo(grayBlock.snp.bottom).offset(22)
            make.leading.equalToSuperview().offset(30)
        }
        
        contentView.addSubview(personnelStackView)
        personnelStackView.snp.makeConstraints { make in
            make.top.equalTo(projectConditionsLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-219)
        }
        personnelStackView.addArrangedSubview(personnelTitle)
        personnelStackView.addArrangedSubview(personnelLabel)
        
        contentView.addSubview(estimatedDurationStackView)
        estimatedDurationStackView.snp.makeConstraints { make in
            make.top.equalTo(personnelTitle.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-219)
        }
        estimatedDurationStackView.addArrangedSubview(estimatedDurationTitle)
        estimatedDurationStackView.addArrangedSubview(estimatedDurationLabel)
        
        bottomTabView.addSubview(heartButton)
        heartButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(21)
            make.bottom.equalToSuperview().offset(-41)
        }
        bottomTabView.addSubview(heartCount)
        heartCount.snp.makeConstraints { make in
            make.centerX.equalTo(heartButton)
            make.top.equalTo(heartButton.snp.bottom)
        }
        
        bottomTabView.addSubview(chatButton)
        chatButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.bottom.equalTo(bottomTabView).offset(-20)
            make.leading.equalTo(heartButton.snp.trailing).offset(22)
            make.trailing.equalToSuperview().offset(-18)
        }
    }
    
    private func fetchProject(_ projectID: String) {
        FirebaseProject.fetchProjectByProjectID(projectID: projectID) { [unowned self] project in
            self.project = project
        }
    }
    
    private func sendChat() {
        guard let project = project else { return }
        FirebaseUser.fetchOtherUser(userID: project.writerId) { [weak self] user in
            self?.didSendEventClosure?(.showPersonalChat(projectWriter: user))
        }
    }
    
    private func showAlert(_ event: ChatButtonEvent) {
        guard let project = project else { return }
        
        var message: String!
        if event == .changeFinishRecruit {
            message = "프로젝트 모집을 완료하시나요?"
        } else if event == .changeRecruit {
            message = "프로젝트를 모집중으로 변경하시나요?"
        }
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            FirebaseProject.updateIsRecruit(project) {
                self?.fetchProject(project.projectId)
            }
        }
        ok.setValue(UIColor.PointRed, forKey: "titleTextColor")
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        cancel.setValue(UIColor.PointBlue, forKey: "titleTextColor")

        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
    
    private func updateHeartCount(_ update: Int) {
        guard let project = project else { return }
        FirebaseProject.updateProjectHeart(update, project) { [weak self] result in
            self?.heartCount.text = "\(result)"
        }
    }
}

extension ProjectDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}

extension ProjectDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as? PhotoCell else {
            fatalError()
        }
        return cell
    }
}
