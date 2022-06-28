//  ProjectWriteViewController.swift
//  TUDY
//
//  Created by jamescode on 2022/05/27.
//

import UIKit
import SnapKit
import PhotosUI

class ProjectWriteViewController: UIViewController {
    
    // MARK: - Properties
    enum Event {
        case registerProject(viewController: UIViewController)
    }
    
    var didSendEventClosure: ((Event) -> Void)?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    //카테고리바
    private let categoriesView = OptionSelectionBar.init(title: "관련 직무 카테고리 📌")
    private let resultSeletedCategoriesLabel = UILabel().label(text: "", font: UIFont.body14, color: .White, numberOfLines: 0)
    var isHiddenResultCategoriesLabel: Bool = true
    
    private var develops: [String] = []
    private var designs: [String] = []
    
    //프로젝트 조건바
    private let projectConditionsView = OptionSelectionBar.init(title: "프로젝트 조건 💡")
    private let resultPersonnelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    private let personnelTitle = UILabel().label(text: "인원", font: UIFont.sub14, color: .White)
    private let personnelLabel = UILabel().label(text: "0명", font: UIFont.sub14, color: .White)
    private var peopleCount = 0
    
    private let resultEstimatedDurationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    private let estimatedDurationTitle = UILabel().label(text: "예상 기간", font: UIFont.sub14, color: .White)
    private let estimatedDurationLabel = UILabel().label(text: "0주", font: UIFont.sub14, color: .White)
    private var duration = 0
    
    private var optionState: String = "categoriesBar"
    private var imageArray = [UIImage]()
    private var itemProviders: [NSItemProvider] = []
    private let photoCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.minimumLineSpacing = 10
        flowlayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:  flowlayout)
        collectionView.backgroundColor = .DarkGray1
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var contentsViewPhotoToolbar: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .DarkGray1
        return view
    }()
    
    let titleTextFieldPlaceHolder = "제목을 입력해 주세요. (최대 30자)"
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.body16
        textField.textColor = .White
        textField.attributedPlaceholder = NSAttributedString(string: titleTextFieldPlaceHolder, attributes:   [NSAttributedString.Key.foregroundColor: UIColor.DarkGray4])
        textField.delegate = self
        return textField
    }()
    
    private let grayDivider1 = UIView().grayBlock()
    private let grayDivider2 = UIView().grayBlock()
    private let grayDivider3 = UIView().grayBlock()
    private let grayDivider4 = UIView().grayBlock()
    
    let contentsTextViewPlaceHolder = "내용을 입력해 주세요. (최대 1,200자)"
    private lazy var contentsTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.backgroundColor = .DarkGray1
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.text = contentsTextViewPlaceHolder
        textView.font = UIFont.body16
        textView.textColor = .DarkGray4
        textView.delegate = self
        return textView
    }()
    
    private let projectWriteToolbar = UIToolbar().toolbar()
    
    private lazy var toolbarPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "photo"), for: .normal)
        button.addTarget(self, action: #selector(didTapPhotoButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var contentsViewPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "photo"), for: .normal)
        button.addTarget(self, action: #selector(didTapPhotoButton), for: .touchUpInside)
        return button
    }()
    
    private let toolbarPhotoLabel = UILabel().label(text: "(사진 최대 1장)", font: .caption12, color: .LightGray5)
    
    private let contentsViewPhotoLabel = UILabel().label(text: "(사진 최대 1장)", font: .caption12, color: .LightGray5)
    
    private let selectWorksMessage = "관련 직무 카테고리를 선택해주세요 ! 📌"
    private let titleMessage = "제목을 입력해주세요 ! 💬"
    private let contentsMessage = "내용을 입력해주세요 ! 💬"
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeSelectedDevelop(_:)),
                                               name: Notification.Name("selectedDevelop"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeSelectedDesign(_:)),
                                               name: Notification.Name("selectedDesign"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changePeopleCount(_:)),
                                               name: Notification.Name("peopleCount"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeProjectTime(_:)),
                                               name: Notification.Name("time"),
                                               object: nil)
    }
    
    private func configureUI() {
        setNavigationBar()
        addKeyboardNotification()
        
        view.addSubview(scrollView)
        view.addSubview(contentsViewPhotoToolbar)
        addTopBorder(with: .DarkGray5 , andWidth: 1, viewName: contentsViewPhotoToolbar)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(contentsViewPhotoToolbar.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentsViewPhotoToolbar.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.width.height.equalToSuperview()
        }
        
        contentView.addSubview(categoriesView)
        let categoriesViewTap = UITapGestureRecognizer(target: self, action: #selector(didTapCategoriesBarButton))
        categoriesView.addGestureRecognizer(categoriesViewTap)
        categoriesView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(resultSeletedCategoriesLabel)
        resultSeletedCategoriesLabel.snp.makeConstraints { make in
            make.top.equalTo(categoriesView.snp.bottom)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        contentView.addSubview(grayDivider1)
        grayDivider1.snp.makeConstraints { make in
            make.top.equalTo(resultSeletedCategoriesLabel.snp.bottom).offset(16)
            make.height.equalTo(1)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        contentView.addSubview(projectConditionsView)
        let projectConditionsViewTap = UITapGestureRecognizer(target: self, action: #selector(didTapProjectConditionsBarButton))
        projectConditionsView.addGestureRecognizer(projectConditionsViewTap)
        projectConditionsView.snp.makeConstraints { make in
            make.top.equalTo(grayDivider1.snp.bottom)
            make.height.equalTo(55)
            make.leading.trailing.equalToSuperview()
        }
        
        //인원 선택 결과
        contentView.addSubview(resultPersonnelStackView)
        resultPersonnelStackView.snp.makeConstraints { make in
            make.top.equalTo(projectConditionsView.snp.bottom)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-219)
        }
        resultPersonnelStackView.addArrangedSubview(personnelTitle)
        resultPersonnelStackView.addArrangedSubview(personnelLabel)
        
        //예상기간 선택 결과
        contentView.addSubview(resultEstimatedDurationStackView)
        resultEstimatedDurationStackView.snp.makeConstraints { make in
            make.top.equalTo(resultPersonnelStackView.snp.bottom)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-219)
        }
        resultEstimatedDurationStackView.addArrangedSubview(estimatedDurationTitle)
        resultEstimatedDurationStackView.addArrangedSubview(estimatedDurationLabel)
        
        contentView.addSubview(grayDivider2)
        grayDivider2.snp.makeConstraints { make in
            make.top.equalTo(resultEstimatedDurationStackView.snp.bottom).offset(19.77)
            make.height.equalTo(1)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        contentView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(grayDivider2).offset(20)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        contentView.addSubview(grayDivider3)
        grayDivider3.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.height.equalTo(1)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        contentView.addSubview(contentsTextView)
        contentsTextView.snp.makeConstraints { make in
            make.top.equalTo(grayDivider3.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        contentView.addSubview(toolbarPhotoButton)
        contentView.addSubview(toolbarPhotoLabel)
        let photoButtonItem = UIBarButtonItem(customView: toolbarPhotoButton)
        let photoLabelItem = UIBarButtonItem(customView: toolbarPhotoLabel)
        
        projectWriteToolbar.barTintColor = .DarkGray1
        projectWriteToolbar.items = [photoButtonItem, photoLabelItem]
        projectWriteToolbar.updateConstraintsIfNeeded()
        
        titleTextField.inputAccessoryView = projectWriteToolbar
        contentsTextView.inputAccessoryView = projectWriteToolbar
        
        contentsViewPhotoToolbar.addSubview(contentsViewPhotoButton)
        contentsViewPhotoButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(16)
        }
        
        contentsViewPhotoToolbar.addSubview(contentsViewPhotoLabel)
        contentsViewPhotoLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-19)
        }
        
        contentView.addSubview(photoCollectionView)
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        //생각해볼 에러... 포토컬렉션뷰를 툴바에 맞추면 생각할게 많아진다...
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentsTextView.snp.bottom).offset(30)
            make.height.equalTo(80)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
    }
    
    private func setNavigationBar() {
        view.backgroundColor = .DarkGray1
        navigationController?.navigationBar.backgroundColor = .DarkGray2
        title = "게시글 작성"
        //        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        //back button 이름 제거
        navigationController?.navigationBar.topItem?.title = ""
        tabDisappear()
        
        let backButtonImage = UIImage(systemName: "chevron.down")
        let leftItem = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = leftItem
        
        let rightItem =
        UIBarButtonItem(title:"등록", style: .plain, target: self, action: #selector(didTapRegisterButton))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat, viewName view: UIView) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: borderWidth)
        view.addSubview(border)
    }
    
    private func showSelectedJob() {
        let developTexts = develops.map { "개발(\($0))" }
        let designTexts = designs.map { "디자인(\($0))" }
        let developText = developTexts.joined(separator: ", ")
        let designText = designTexts.joined(separator: ", ")
        if designText == "" {
            resultSeletedCategoriesLabel.text = developText
        } else {
            resultSeletedCategoriesLabel.text = "\(developText), \(designText)"
        }
    }
}

// MARK: - Action methods
extension ProjectWriteViewController {
    
    @objc func back() {
        didSendEventClosure?(.registerProject(viewController: self))
    }
    
    @objc func changeSelectedDevelop(_ notification: Notification) {
        if let selectedDevelop = notification.object as? [String] {
            develops = selectedDevelop
            showSelectedJob()
        }
    }
    
    @objc func changeSelectedDesign(_ notification: Notification) {
        if let selectedDesign = notification.object as? [String] {
            designs = selectedDesign
            showSelectedJob()
        }
    }
    
    @objc func changePeopleCount(_ notification: Notification) {
        if let count = notification.object as? Int {
            personnelLabel.text = "\(count)명"
            peopleCount = count
        }
    }
    
    @objc func changeProjectTime(_ notifiaction: Notification) {
        if let time = notifiaction.object as? Int {
            estimatedDurationLabel.text = "\(time)주"
            duration = time
        }
    }
    
    @objc func didTapCategoriesBarButton() {
        let bottomSheetVC = BottomSheetViewController(contentViewController: CategoriesViewController())
        bottomSheetVC.defaultHeight = UIScreen.main.bounds.size.height * 0.346
        bottomSheetVC.defalutHeightDragFixd = false
        //카테고리바 누르면 카테고리 결과바 나오게 설정
        self.isHiddenResultCategoriesLabel = false
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetVC, animated: false, completion: nil)
    }
    
    @objc func didTapProjectConditionsBarButton() {
        NotificationCenter.default.post(name: NSNotification.Name("forChangeCoditions"), object: nil)
        
        let bottomSheetVC = BottomSheetViewController(contentViewController: ProjectConditionsViewController())
        bottomSheetVC.defaultHeight = UIScreen.main.bounds.size.height * 0.275
        bottomSheetVC.defalutHeightDragFixd = false
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetVC, animated: false, completion: nil)
    }
    
    // MARK: - 등록버튼
    @objc private func didTapRegisterButton() {
        view.endEditing(true)
        if develops.isEmpty && designs.isEmpty {
            showToastMessage(text: selectWorksMessage)
            return
        } else if titleTextField.text == "" {
            showToastMessage(text: titleMessage)
            return
        } else if contentsTextView.text == "내용을 입력해 주세요. (최대 1,200자)" {
            showToastMessage(text: contentsMessage)
            return
        }
        saveProject()
        didSendEventClosure?(.registerProject(viewController: self))
    }
    
    @objc private func didTapPhotoButton() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker,animated: true, completion: nil)
    }
    
    //키보드 보일 때
    @objc private func keyboardWillShow(_ notification: Notification) {
        //키보드프레임값 가져오기
        guard let userInfo = notification.userInfo,
              var keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        var contentInset = contentsTextView.contentInset
        contentInset.bottom = keyboardFrame.size.height - photoCollectionView.frame.height + 5
        scrollView.contentInset = contentInset
        scrollView.verticalScrollIndicatorInsets = contentInset
    }
    //키보드 숨겨질 때
    @objc private func keyboardWillHide(_ notification: Notification) {
        
    }
}

// MARK: - API
extension ProjectWriteViewController {
    
    func saveProject() {
        guard let title = titleTextField.text else { return }
        guard let contents = contentsTextView.text else { return }
        let userID = FirebaseUser.getUserID()
        var works = develops
        works.append(contentsOf: designs)
        
        let project = Project(projectId: UUID().uuidString,
                              title: title,
                              content: contents,
                              isRecruit: true,
                              writerId: userID,
                              writeDate: Date().date(),
                              imageUrl: "",
                              wantedWorks: works,
                              endDate: "\(duration)",
                              maxPeople: peopleCount,
                              favoriteCount: 0)
        
        FirebaseProject.saveProjectData(project)
    }
}

// MARK: - TextField 대리 관리자
extension ProjectWriteViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 30
        
        let currentString: NSString = textField.text! as NSString
        
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= 30
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - TextView 대리 관리자
extension ProjectWriteViewController: UITextViewDelegate {
    
    func setPlaceHolder() {
        contentsTextView.text = contentsTextViewPlaceHolder
        contentsTextView.textColor =  UIColor.systemGray4
    }
    
    //텍스트뷰 높이 자동 조절
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if estimatedSize.height <= 180 {
                
            } else {
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
    
    //편집이 시작될 때(포커스 얻는 경우)
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == contentsTextViewPlaceHolder {
            textView.text = nil
            textView.textColor = .White
        }
    }
    
    //편집이 종료될 때(포커스 잃는 경우)
    func textViewDidEndEditing(_ textView: UITextView) {
        //문자열의 앞뒤 공백과 줄바꿈을 제거
        //공백 또는 줄바꿈을 입력할 경우에도 placeholder 적용
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = contentsTextViewPlaceHolder
            textView.textColor = .DarkGray4
        }
    }
}

// MARK: -  PHPickerViewController 대리 관리자
extension ProjectWriteViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        //PHPicker 닫기
        picker.dismiss(animated: true, completion: nil)
        
        //선택한 사진 배열에 저장
        itemProviders = results.map(\.itemProvider)
        for item in itemProviders {
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { image, error in
                    if let error = error {
                        print("이미지 로드 에러 \(error.localizedDescription)")
                        return
                    }
                    DispatchQueue.main.async { [self] in
                        guard let image = image as? UIImage else { return }
                        imageArray.append(image)
                        self.photoCollectionView.reloadData()
                    }
                }
            }
        }
    }
}

// MARK: - 사진 컬렉션뷰 관련
extension ProjectWriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as? PhotoCell else {
            fatalError()
        }
        
        cell.imageView.image = imageArray[indexPath.row]
        return cell
    }
}

extension ProjectWriteViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}
