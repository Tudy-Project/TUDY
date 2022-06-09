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
    private let welcomeTitle = UILabel().label(text: "반가워요 다인님, 🎨\n관심있는 프로젝트가 있나요?", font: .sub20)
    
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
        let bottomSheetVC = BottomSheetViewController(contentViewController: HomePostViewController())
        bottomSheetVC.defaultHeight = UIScreen.main.bounds.size.height * 0.464
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetVC, animated: false, completion: nil)
        
        let leftItem = UIBarButtonItem(customView: logo)
        self.navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem(image:UIImage(named: "profile"), style: .plain, target: self, action: #selector(searchButtonPressed))
        self.navigationItem.rightBarButtonItem = rightItem
        
        view.addSubview(welcomeTitle)
        welcomeTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(43)
            make.leading.equalToSuperview().offset(30)
        }
        
        view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(didTapFloatingButton), for: .touchUpInside)
        
        floatingButton.snp.makeConstraints { make in
            make.width.equalTo(screenSize.height * 0.0714)
            make.height.equalTo(screenSize.height * 0.0714)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }
}

// MARK: - Action methods
extension HomeViewController {
    
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

