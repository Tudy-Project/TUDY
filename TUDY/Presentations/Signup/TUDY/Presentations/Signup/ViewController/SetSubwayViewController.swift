//
//  setSubwayViewControoler.swift
//  TUDY
//
//  Created by neuli on 2022/05/26.
//

import UIKit

import SnapKit

class SetSubwayViewController: UIViewController {
    
    // MARK: - Properties
    enum Event {
        case next
    }
    var didSendEventClosure: ((Event) -> Void)?
    
    private lazy var stepStackView = UIStackView().stepStackView(currentStep: step)
    private let guideLabel = UILabel().label(text: "출발 지하철역을\n입력 해주세요. 🚍", font: .sub20)

    private let detailGuideLabel: UILabel = {
        let label = UILabel().label(text: "팀원간 중간지점을 잡을 때 활용해요 !\n남에게 보이지 않고 언제든지 수정 가능해요.", font: .caption11, color: .DarkGray6)
        label.numberOfLines = 0
        return label
    }()
    
    private let subwayTextField = UITextField().textField(withPlaceholder: "지하철 명을 입력해주세요.")
    private let signUpButton = UIButton().nextButton(text: "가입하기")
    private let signUpToolbarButton = UIButton().nextButton(text: "가입하기")
    private let signUpToolbar = UIToolbar().toolbar()
    
    // 지하철 선택 view
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, Subway>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Subway>
    private var collectionView: UICollectionView!
    private var dataSource: DataSource!
    
    private let step = 3
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureUI()
        hideKeyboardWhenTappedView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        focusOnSubwayTextField()
    }
}

extension SetSubwayViewController {
    
    // MARK: - Methods
    private func configureUI() {
        setNavigationBar()
        view.backgroundColor = .DarkGray1
        
        view.addSubview(stepStackView)
        stepStackView.stepStackViewLayout(view: view)
        
        view.addSubview(guideLabel)
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(115)
            make.leading.equalTo(view.snp.leading).offset(30)
        }
        
        view.addSubview(detailGuideLabel)
        detailGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(7)
            make.leading.equalTo(view.snp.leading).offset(30)
        }
        
        view.addSubview(subwayTextField)
        subwayTextField.snp.makeConstraints { make in
            make.top.equalTo(detailGuideLabel.snp.bottom).offset(67)
            make.leading.equalTo(view.snp.leading).offset(30)
            make.trailing.equalTo(view.snp.trailing).offset(-30)
        }
        view.layoutIfNeeded()
        subwayTextField.underLine()
        
        // view.addSubview(collectionView)
        // 제약 추가
        
        view.addSubview(signUpButton)
        signUpButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
        signUpButton.nextButtonLayout(view: view)
        
        let signUpBarButtonItem = UIBarButtonItem(customView: signUpToolbarButton)
        signUpToolbarButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
        signUpToolbar.frame = CGRect(x: 0, y: view.frame.size.height - 50, width: view.frame.size.width, height: 50)
        signUpToolbar.items = [signUpBarButtonItem]
        signUpToolbar.updateConstraintsIfNeeded()
        subwayTextField.inputAccessoryView = signUpToolbar
    }
    
    private func setNavigationBar() {
        navigationItem.backButtonTitle = ""
    }
    
    private func hideKeyboardWhenTappedView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func focusOnSubwayTextField() {
        subwayTextField.becomeFirstResponder()
    }
    
    // MARK: CollectionView
    private func collectionViewListLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewListLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func configureDataSource() {
        //let cellRegistration = UICollectionView.CellRegistration
    }
}

extension SetSubwayViewController {
    
    // MARK: - Action Methods
    @objc private func goNext() {
        didSendEventClosure?(.next)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
