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
    
    private let fakeTextFieldView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.DarkGray4.cgColor
        view.backgroundColor = .DarkGray3
        return view
    }()
    
    private let searchIcon = UIImageView(image: UIImage(named: "searchIcon"))
    
    enum BottomSheetViewState {
        case expanded
        case normal
    }
    
    private let dragIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 3
        return view
    }()
    
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
        //        print("=================BEFORE===================")
        //        let user = User(userId: 123, signUpDate: 456, nickname: "호진", profileImage: "123", interestedJob: ["123","123"], subways: "123", likeProjectId: "123", personalChat: ["123","123"], groupChat: ["123","123"])
        //        let A = CommonFirebaseDatabaseNetworkServiceClass()
        //
        //        A.save(user) { error in
        //            if let error = error {
        //                print("error : \(error)")
        //                print("ERROR!!!!!!")
        //            }
        //        }
        //        print("=================AFTER===================")
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        view.backgroundColor = .DarkGray1
        navigationController?.navigationBar.backgroundColor = .DarkGray1
        navigationController?.navigationBar.tintColor = .white
        tabBarController?.tabBar.isHidden = false
    }
}

extension HomeViewController {
    // MARK: - Methods
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
        welcomeHeaderView.addSubview(fakeTextFieldView)
        fakeTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(welcomeTitle.snp.bottom).offset(19)
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(36)
            make.trailing.equalToSuperview().offset(-30)
        }
        fakeTextFieldView.addSubview(searchIcon)
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
        
        view.addSubview(dragIndicatorView)
        dragIndicatorView.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(dragIndicatorView.layer.cornerRadius * 2)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(bottomSheetView.snp.top).offset(-10)
        }
        
        let leftItem = UIBarButtonItem(customView: logo)
        self.navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem(image:UIImage(named: "profile"), style: .plain, target: self, action: #selector(searchButtonPressed))
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
            
            bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - defaultHeight
        } else {
            bottomSheetViewTopConstraint.constant = bottomSheetPanMinTopConstant
        }

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

// MARK: - Action methods
extension HomeViewController {
    // 해당 메소드는 사용자가 view를 드래그하면 실행됨
    @objc private func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: self.view)
        switch panGestureRecognizer.state {
        case .began:
            bottomSheetPanStartingTopConstant = bottomSheetViewTopConstraint.constant
        case .changed:
            //네브바와 닿으면 더이상 안올라가게
            print("현재바텀시트탑위치 + 드래그y값 : \(bottomSheetPanStartingTopConstant + translation.y)")
            print("바텀시트 최대화 시 네브바와의 패딩값: \(bottomSheetPanMinTopConstant)")
            if bottomSheetPanStartingTopConstant + translation.y > bottomSheetPanMinTopConstant {
                bottomSheetViewTopConstraint.constant = bottomSheetPanStartingTopConstant + translation.y
            }
            
            //기본 바텀시트 높이보다 아래로 드래그 시 바텀시트 높이 변화하지 않게 만들기
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
            
            // 2
            let nearestValue = nearest(to: bottomSheetViewTopConstraint.constant, inValues: [bottomSheetPanMinTopConstant, defaultPadding, safeAreaHeight + bottomPadding])
            
            // 3
            if nearestValue == bottomSheetPanMinTopConstant {
                print("Bottom Sheet을 Expanded 상태로 변경하기!")
                showBottomSheet(atState: .expanded)
            } else if nearestValue == defaultPadding {
                // Bottom Sheet을 .normal 상태로 보여주기
                showBottomSheet(atState: .normal)
            } else {
                // Bottom Sheet을 숨기고 현재 View Controller를 dismiss시키기
//                hideBottomSheetAndGoBack()
            }
        default:
            break
        }
        
        //        사용자가 위로 드래그할 경우 translation.y의 값은 음수가 되고, 사용자가 아래로 드래그할 경우 translation.y의 값은 양수가 되는 걸 확인할 수 있다. translation.y의 값을 top constraint value와 합하여 Bottom Sheet을 움직여줄 수 있답니다.
//        print("유저가 위아래로 \(translation.y)만큼 드래그하였습니다.")
    }
    
    @objc private func didTapFloatingButton() {
        if isLogin() {
            didSendEventClosure?(.showProjectWrite)
        } else {
            didSendEventClosure?(.showLogin)
        }
    }
    
    @objc private func searchButtonPressed(_: UIButton) {
        didSendEventClosure?(.showSearch)
        //        let searchVC = SearchViewController()
        //        self.navigationController?.isNavigationBarHidden = false
        //        self.navigationController?.pushViewController(searchVC, animated: true)
    }
}

// MARK: - Login Check Protocol
extension HomeViewController: LoginCheck {}

extension UIApplication {
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct InfoVCPreview: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        Group {
            HomeViewController().toPreview().previewDevice(PreviewDevice(rawValue: "iPhone XS"))
                .previewDisplayName("iPhone XS")
            HomeViewController().toPreview().previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max")).previewDisplayName("iPhone 12 Pro Max")
        }
    }
}
#endif


#if DEBUG
import SwiftUI

@available(iOS 13, *)
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        // this variable is used for injecting the current view controller
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
    
    func toPreview() -> some View {
        // inject self (the current view controller) for the preview
        Preview(viewController: self)
    }
}
#endif
