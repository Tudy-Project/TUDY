//
//  HomeViewController.swift
//  TUDY
//
//  Created by jamescode on 2022/05/18.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    enum Event {
        case showSearch
        case showProjectWrite
        case showProjectDetail(project: Project)
        case showLogin
    }
    
    var didSendEventClosure: ((Event) -> Void)?
    
    let screenSize: CGRect = UIScreen.main.bounds
    private let logo = UILabel().label(text: "TUDY", font: .logo26)
    
    private let welcomeHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .DarkGray1
        return view
    }()
    
    private let welcomeTitle = UILabel().label(text: "반가워요 다인님, 🎨\n관심있는 프로젝트가 있나요?", font: .sub20)
    
    
    private let fakeSearchBarView: UIView = {
        
        let view = UIView()
        view.layer.cornerRadius = 7
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.DarkGray4.cgColor
        view.backgroundColor = .DarkGray3
        return view
    }()
    
    private let searchIcon = UIImageView(image: UIImage(named: "searchIcon"))
    
    private var fastSearchButtonList = ["백엔드", "프론트엔드", "iOS", "Android", "그래픽디자인", "UX/UI","3D/모션그래픽","브랜딩"]
    
    private lazy var fastSearchCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView =  UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FastSearchCell.self, forCellWithReuseIdentifier: FastSearchCell.identifier)
        collectionView.backgroundColor = .DarkGray1
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.tag = 1
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private let FilterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        return stackView
    }()
    
    private let bottomSheetFilterLabel = UILabel().label(text: "모집중인 스터디만 보기", font: .body14, numberOfLines: 1)
    private lazy var switchButton: UISwitch = {
        let switchButton = UISwitch()
        switchButton.thumbTintColor = .DarkGray6
        let onColor = UIColor.systemBlue
        let offColor = UIColor.DarkGray5
        
        //for on State
        switchButton.onTintColor = onColor
        
        //for off State
        switchButton.tintColor = offColor
        switchButton.layer.cornerRadius = switchButton.frame.height / 2.0
        //        switchButton.layer.borderWidth = 2
        //        switchButton.layer.borderColor = UIColor.LightGray1.cgColor
        switchButton.backgroundColor = offColor
        switchButton.clipsToBounds = true
        return switchButton
    }()
    
//    private lazy var bottomSheetCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(BottomSheetCell.self, forCellWithReuseIdentifier: BottomSheetCell.identifier)
//        collectionView.backgroundColor = .DarkGray3
//        collectionView.isScrollEnabled = false
//        collectionView.tag = 2
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        return collectionView
//    }()
    
    typealias ProjectDataSource = UICollectionViewDiffableDataSource<Int, Project>
    typealias ProjectSnapshot = NSDiffableDataSourceSnapshot<Int, Project>
    
    private var projectCollectionView: UICollectionView!
    private var projectDataSource: ProjectDataSource!
    private var projects: [Project] = []
    
    enum BottomSheetViewState {
        case expanded
        case normal
    }
    
    // Bottom Sheet과 safe Area Top 사이의 최소값을 지정하기 위한 프로퍼티
    //기본값을 0으로 해서 드래그하면 네브바 바로 아래까지 딱 붙게 설정
    var bottomSheetPanMinTopConstant: CGFloat = 0.0
    // 드래그 하기 전에 Bottom Sheet의 top Constraint value를 저장하기 위한 프로퍼티
    private lazy var bottomSheetPanStartingTopConstant: CGFloat = bottomSheetPanMinTopConstant
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .DarkGray3
        view.layer.cornerRadius = 17
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    //bottomSheet이 view의 상단에서 떨어진 거리를 설정
    //해당 프로퍼티를 이용하여 bottomSheet의 높이를 조절
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    private lazy var defaultHeight: CGFloat = screenSize.height * 0.464
    
    
    private lazy var floatingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .DarkGray5
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.layer.cornerRadius = 30
        return button
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseUser.addUserSnapshotListener()
        configureCollectionView()
        configureUI()
        
        fetchProject()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNav()
    }
}

extension HomeViewController {
    // MARK: - Methods
    
    private func configureNav() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        view.backgroundColor = .DarkGray1
        navigationController?.navigationBar.tintColor = .white
        navAppear()
        tabAppear()
    }
    
    private func configureUI() {
        view.addSubview(welcomeHeaderView)
        welcomeHeaderView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        welcomeHeaderView.addSubview(welcomeTitle)
        welcomeTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(43)
            make.leading.equalToSuperview().offset(30)
        }
        
        welcomeHeaderView.addSubview(fakeSearchBarView)
        let tapFakeSearchBar = UITapGestureRecognizer(target: self, action: #selector(didTapFakeSearchBar))
        fakeSearchBarView.addGestureRecognizer(tapFakeSearchBar)
        fakeSearchBarView.snp.makeConstraints { make in
            make.top.equalTo(welcomeTitle.snp.bottom).offset(19)
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(36)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        welcomeHeaderView.addSubview(fastSearchCollectionView)
        fastSearchCollectionView.snp.makeConstraints { make in
            make.top.equalTo(fakeSearchBarView.snp.bottom).offset(32)
            make.leading.width.equalToSuperview()
            make.height.equalTo(100)
        }
        
        fakeSearchBarView.addSubview(searchIcon)
        searchIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(bottomSheetView)
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        let topConstant: CGFloat = screenSize.height * 0.464
        //top Constraint의 constant 값은 미리 계산해준 topConstant 값으로 지정해줍니다! 계산해준 topConstant 값은 bottomSheet이 처음에 보이지 않도록 하는 것을 목적으로 계산한 값
        //           let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        NSLayoutConstraint.activate([
            bottomSheetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSheetViewTopConstraint,
        ])
        // Pan Gesture Recognizer를 view controller의 view에 추가하기 위한 코드
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        // 기본적으로 iOS는 터치가 드래그하였을 때 딜레이가 발생함
        // 우리는 드래그 제스쳐가 바로 발생하길 원하기 때문에 딜레이가 없도록 아래와 같이 설정
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        view.addGestureRecognizer(viewPan)
        
        let leftItem = UIBarButtonItem(customView: logo)
        self.navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem(image:UIImage(named: "profile"), style: .plain, target: self, action: #selector(didTapProfile))
        self.navigationItem.rightBarButtonItem = rightItem
        
        //floatingButton
        view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(didTapFloatingButton), for: .touchUpInside)
        
        floatingButton.snp.makeConstraints { make in
            make.width.equalTo(screenSize.height * 0.0714)
            make.height.equalTo(screenSize.height * 0.0714)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }
    
    
    private func setUpNavBarSearchBar() {
        let fakeSearchBarView: UIView = {
            
            let view = UIView()
            view.layer.cornerRadius = 7
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.DarkGray4.cgColor
            view.backgroundColor = .DarkGray3
            view.frame = CGRect(x: 0.0, y: 0.0, width: 306, height: 36)
            return view
        }()
        
        let fakeSearchNavBar = UIBarButtonItem(customView: fakeSearchBarView)
        let currWidth = fakeSearchNavBar.customView?.widthAnchor.constraint(equalToConstant: 306)
        currWidth?.isActive = true
        let currHeight = fakeSearchNavBar.customView?.heightAnchor.constraint(equalToConstant:  36)
        currHeight?.isActive = true
        self.navigationItem.leftBarButtonItem = fakeSearchNavBar
        let tapFakeSearchBar = UITapGestureRecognizer(target: self, action: #selector(didTapFakeSearchBar))
        fakeSearchBarView.addGestureRecognizer(tapFakeSearchBar)
        
    }
    
    private func resetUpNavBar() {
        let leftItem = UIBarButtonItem(customView: logo)
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    //바텀시트뷰 스냅 효과
    //주어진 CGFloat 배열의 값 중 number로 주어진 값과 가까운 값을 찾아내는 메소드
    private func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
        guard let nearestVal = values.min(by: { abs(number - $0) < abs(number - $1) })
        else { return number }
        return nearestVal
    }
    
    private func showBottomSheet(atState: BottomSheetViewState = .normal) {
        if atState == .normal {
            let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding: CGFloat = view.safeAreaInsets.bottom
            
            bottomSheetViewTopConstraint.constant = 415.744
            //아래 주석값이 디폴트높이값과 같아야지만 바텀시트의 움직임이 없어짐
            //            (safeAreaHeight + bottomPadding) - defaultHeight
            print("safeAreaHeight:\(safeAreaHeight)")
            print("bottomPadding:\(bottomPadding)")
            print("defaultHeight:\(defaultHeight)")
            print("bottomSheetViewTopConstraint.constant: \(bottomSheetViewTopConstraint.constant)")
//            bottomSheetCollectionView.isScrollEnabled = false
            bottomSheetView.layer.cornerRadius = 17
            navigationController?.navigationBar.isHidden = false
            
            resetUpNavBar()
            
        } else {
            bottomSheetViewTopConstraint.constant = bottomSheetPanMinTopConstant
            
            //expanded상태에서는 스크롤 가능하게 설정
//            bottomSheetCollectionView.isScrollEnabled = true
            bottomSheetView.layer.cornerRadius = 0
            
            setUpNavBarSearchBar()
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func collectionViewlayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(146))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.edgeSpacing = .init(leading: .fixed(18), top: .fixed(18), trailing: .fixed(-36), bottom: .fixed(0))
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 36)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureCollectionView() {
        projectCollectionView = UICollectionView(frame: .zero,
                                                 collectionViewLayout: collectionViewlayout())
        projectCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        projectCollectionView.delegate = self
        configureCollectionViewDataSource()

        
        
        bottomSheetView.addSubview(FilterStackView)
        FilterStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(19)
            make.trailing.equalToSuperview().offset(-17)
        }
        
        FilterStackView.addArrangedSubview(bottomSheetFilterLabel)
        FilterStackView.addArrangedSubview(switchButton)
        
//        bottomSheetView.addSubview(bottomSheetCollectionView)
//        bottomSheetCollectionView.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(56)
//            make.leading.trailing.bottom.equalToSuperview()
//        }
        
        projectCollectionView.backgroundColor = .DarkGray3
        bottomSheetView.addSubview(projectCollectionView)
        projectCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(56)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureCollectionViewDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<BottomSheetCell, Project> {
            [unowned self] cell, indexPath, itemIdentifier in
            cell.titleLabel.text = projects[indexPath.row].title
            cell.contentsLabel.text = projects[indexPath.row].content
            cell.writeDateLabel.text = projects[indexPath.row].writeDate
            FirebaseUser.fetchOtherUser(userID: projects[indexPath.row].writerId) { user in
                cell.authorLabel.text = user.nickname
            }
        }
        
        projectDataSource = ProjectDataSource(collectionView: projectCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                         for: indexPath,
                                                         item: itemIdentifier)
        })
        
        makeSnapshot()
    }
    
    private func makeSnapshot() {
        var snapshot = ProjectSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(projects)
        projectDataSource.apply(snapshot)
    }
}

// MARK: - API
extension HomeViewController {
    func fetchProject() {
        FirebaseProject.fetchProject { [unowned self] projects in
            self.projects = projects
            self.makeSnapshot()
        }
    }
}

// MARK: - Action methods
extension HomeViewController {
    // 해당 메소드는 사용자가 view를 드래그하면 실행됨
    @objc private func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: self.view)
        switch panGestureRecognizer.state {
        case .began:
            print("뷰 드래그 bottomSheetPanStartingTopConstant 기본값 : \(bottomSheetPanStartingTopConstant)")
            bottomSheetPanStartingTopConstant = bottomSheetViewTopConstraint.constant
            print("뷰 드래그 시작 후 bottomSheetPanStartingTopConstant 변화값 : \(bottomSheetPanStartingTopConstant)")
        case .changed:
            //네브바와 닿으면 더이상 안올라가게
            //            print("현재바텀시트탑위치 + 드래그y값 : \(bottomSheetPanStartingTopConstant + translation.y)")
            //            print("바텀시트 최대화 시 네브바와의 패딩값: \(bottomSheetPanMinTopConstant)")
            if bottomSheetPanStartingTopConstant + translation.y > bottomSheetPanMinTopConstant {
                bottomSheetViewTopConstraint.constant = bottomSheetPanStartingTopConstant + translation.y
            }
            
            //바텀시트를 아래로 드래그 해도 기본높이 바텀시트 나오게 고정
            if bottomSheetPanStartingTopConstant + translation.y > defaultHeight {
                bottomSheetViewTopConstraint.constant = defaultHeight
            }
            
        case .ended:
            
            //화면전체 높이
            let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding = view.safeAreaInsets.bottom
            
            //defaultHeight일 때 safeAreaTop과 bottomSheet 사이의 거리를 계산한 변수
            let defaultPadding = safeAreaHeight+bottomPadding - defaultHeight
            
            let nearestValue = nearest(to: bottomSheetViewTopConstraint.constant, inValues: [bottomSheetPanMinTopConstant, defaultPadding, safeAreaHeight + bottomPadding])
            print("니얼값:\(nearestValue)")
            print("니얼값 비교 bottomSheetPanMinTopConstant값: \(bottomSheetPanMinTopConstant)")
            if nearestValue == bottomSheetPanMinTopConstant {
                showBottomSheet(atState: .expanded)
            } else if nearestValue == defaultPadding {
                showBottomSheet(atState: .normal)
            }
        default:
            break
        }
        
        //        사용자가 위로 드래그할 경우 translation.y의 값은 음수가 되고, 사용자가 아래로 드래그할 경우 translation.y의 값은 양수가 되는 걸 확인할 수 있다. translation.y의 값을 top constraint value와 합하여 Bottom Sheet을 움직여줄 수 있답니다.
        //        print("유저가 위아래로 \(translation.y)만큼 드래그하였습니다.")
    }
    
    @objc private func didTapProfile() {
        if isLogin() {
            //로그인 되어 있으면 마이페이지로
        }
        didSendEventClosure?(.showLogin)
    }
    
    @objc private func didTapFakeSearchBar() {
        didSendEventClosure?(.showSearch)
    }
    
    @objc private func didTapFloatingButton() {
        if isLogin() {
            didSendEventClosure?(.showProjectWrite)
        } else {
            didSendEventClosure?(.showLogin)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var idx: Int = 0
        if(collectionView.tag == 1) {
            idx = fastSearchButtonList.count
        } else {
            idx = projects.count
        }
        return idx
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bottomSheetWidth = bottomSheetView.bounds.width
        if collectionView.tag == 1 {
            return CGSize(width: bottomSheetWidth * 0.227, height: 100)
        } else {
            return  CGSize(width: bottomSheetWidth * 0.906, height: 146)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            guard let fastSearchCell =
                    fastSearchCollectionView.dequeueReusableCell(withReuseIdentifier: FastSearchCell.identifier, for: indexPath) as? FastSearchCell else {
                return UICollectionViewCell()
            }
            fastSearchCell.contentView.layer.cornerRadius = 10
            fastSearchCell.workIcon.image = UIImage(named: "mac_icon")
            fastSearchCell.workTitle.text = fastSearchButtonList[indexPath.row]
            fastSearchCell.contentView.backgroundColor = UIColor.DarkGray5
            fastSearchCell.contentView.backgroundColor = UIColor.WorkColorArr[indexPath.row]
            
            if (indexPath.row == 2) {
                fastSearchCell.workTitle.textColor = .black
                fastSearchCell.workCircle.backgroundColor = .black
                fastSearchCell.workIcon.image = UIImage(named:"apple_icon")
            } else if indexPath.row == 3 {
                fastSearchCell.workIcon.image = UIImage(named:"android_icon")
            } else if indexPath.row == 4 {
                fastSearchCell.workIcon.image = UIImage(named:"‍‍design_icon")
            } else if indexPath.row == 5 {
                fastSearchCell.workIcon.image = UIImage(named:"uxui_icon")
            } else if indexPath.row == 6 {
                fastSearchCell.workTitle.font = .sub13
            } else if indexPath.row == 7 {
                fastSearchCell.workIcon.image = UIImage(named:"branding_icon")
            }
            
            return  fastSearchCell
        }
//        else {
//            guard let cell = bottomSheetCollectionView.dequeueReusableCell(withReuseIdentifier: BottomSheetCell.identifier, for: indexPath) as? BottomSheetCell else {
//                return UICollectionViewCell()
//            }
//            cell.layer.cornerRadius = 5
//            cell.backgroundColor = .DarkGray1
//            cell.titleLabel.text = projects[indexPath.row].title
//            cell.contentsLabel.text = projects[indexPath.row].content
//            cell.writeDateLabel.text = projects[indexPath.row].writeDate
//            FirebaseUser.fetchOtherUser(userID: projects[indexPath.row].writerId) { user in
//                cell.authorLabel.text = user.nickname
//            }
//            return cell
//        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            print("선택하면 빠른 검색 \(fastSearchButtonList[indexPath.row])")
        } else {
            let index = indexPath.row
            didSendEventClosure?(.showProjectDetail(project: projects[index]))
        }
        
    }
}


// MARK: - Login Check Protocol
extension HomeViewController: LoginCheck {}

extension UIApplication {
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
}
