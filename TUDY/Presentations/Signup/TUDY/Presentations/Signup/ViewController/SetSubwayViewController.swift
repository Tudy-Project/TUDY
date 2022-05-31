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
    
    private let subwayTextField = UITextField().textField(withPlaceholder: "지하철명을 초성 혹은 단어로 검색하세요.")
    private let signUpButton = UIButton().nextButton(text: "가입하기")
    private let signUpToolbarButton = UIButton().nextButton(text: "가입하기")
    private let signUpToolbar = UIToolbar().toolbar()
    
    // 지하철 선택 view
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, Subway>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Subway>
    private var collectionView: UICollectionView!
    private var dataSource: DataSource!
    private let subwayDataManager = SubwayDataManager()
    private var subwayList: [Subway] = []
    private var filteredSubwayList: [Subway] = []
    
    private let hangul = ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]
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
        subwayTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        subwayTextField.snp.makeConstraints { make in
            make.top.equalTo(detailGuideLabel.snp.bottom).offset(60)
            make.leading.equalTo(view.snp.leading).offset(27)
            make.trailing.equalTo(view.snp.trailing).offset(-30)
        }
        view.layoutIfNeeded()
        subwayTextField.underLine()
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .DarkGray1
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(subwayTextField.snp.bottom).offset(18)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-30)
            make.height.equalTo(130)
        }
        
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
    
    private func buttonChangeEnableTrue() {
        signUpButton.changeIsEnabledTrue()
        signUpToolbarButton.changeIsEnabledTrue()
        signUpToolbar.changeColorDarkGray4()
    }
    
    private func buttonChangeEnableFalse() {
        signUpButton.changeIsEnabledFalse()
        signUpToolbarButton.changeIsEnabledFalse()
        signUpToolbar.changeColorDarkGray2()
    }
    
    // MARK: CollectionView
    private func collectionViewListLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.backgroundColor = .DarkGray1
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewListLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        configureDataSource()
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Subway> {
            cell, IndexPath, identifier in
            
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = identifier.station
            contentConfiguration.textProperties.font = .caption12
            contentConfiguration.textProperties.color = .white
            cell.contentConfiguration = contentConfiguration
            let view: UIView = {
                let view = UIView()
                view.backgroundColor = .DarkGray5
                return view
            }()
            cell.backgroundView = view
            
            let stationImageConfiguration = self.stationImageConfiguration(subway: identifier)
            cell.accessories = [.customView(configuration: stationImageConfiguration)]
        }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
        
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        subwayDataManager.fetchSubway { [weak self] result in
            switch result {
            case .success(let subwayList):
                let subwayList = subwayList.sorted { $0.station < $1.station }
                DispatchQueue.main.sync {
                    snapshot.appendItems([])
                    self?.dataSource.apply(snapshot)
                    self?.subwayList = subwayList
                }
            case.failure(let error):
                print("DEBUG: \(error.localizedDescription)")
            }
        }
    }
    
    private func stationImageConfiguration(subway: Subway) -> UICellAccessory.CustomViewConfiguration {
        let stackView = UIStackView(arrangedSubviews: subway.lines.map {
            UIButton().imageButton(imageName: $0.subwayLineName()) })
        stackView.axis = .horizontal
        stackView.spacing = 3
        
        return UICellAccessory.CustomViewConfiguration(customView: stackView, placement: .trailing(displayed: .always))
    }
    
    private func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(filteredSubwayList)
        dataSource.apply(snapshot)
    }
    
    private func filteringSubway(text: String) {
        if text == "" {
            filteredSubwayList = []
        } else {
            filteredSubwayList = subwayList.filter {
                if isSplit(text: text) {
                    return $0.station.contains(text) || splitText(text: $0.station).contains(text)
                }
                return $0.station.contains(text)
            }
        }
        updateSnapshot()
    }
    
    // 초성으로 분리
    private func splitText(text: String) -> String {
        var result = ""
        
        for char in text {
            let octal = char.unicodeScalars[char.unicodeScalars.startIndex].value
            if 44032...55203 ~= octal {
                let index = (octal - 0xac00) / 28 / 21
                result = result + hangul[Int(index)]
            }
        }
        return result
    }
    
    // 문자열이 초성으로만 이루어졌는지 확인
    func isSplit(text: String) -> Bool {
        var isSplit = false
        for char in text {
            if 0 < hangul.filter({ $0.contains(char) }).count {
                isSplit = true
            } else {
                isSplit = false
                break
            }
        }
        return isSplit
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
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        filteringSubway(text: text)
        
        buttonChangeEnableFalse()
    }
}

extension SetSubwayViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let index = indexPath.row
        let selectedSubwayStation = filteredSubwayList[index]
        subwayTextField.text = selectedSubwayStation.station
        
        filteredSubwayList = []
        updateSnapshot()
        
        buttonChangeEnableTrue()
    }
}
