//
//  ProjectWriteViewController.swift
//  TUDY
//
//  Created by jamescode on 2022/05/27.
//

import UIKit
import SnapKit
import PhotosUI

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class ProjectWriteViewController: UIViewController {
    
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let categoriesView = RelatedJobCategoriesView.init(title: "관련 직무 카테고리 📌")
    private let projectConditionsView = RelatedJobCategoriesView.init(title: "프로젝트 조건 💡")
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
    
    let titleTextFieldPlaceHolder = "제목을 입력해 주세요. (최대 30자)"
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.body16
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: titleTextFieldPlaceHolder, attributes:   [NSAttributedString.Key.foregroundColor: UIColor.DarkGray4])
        textField.delegate = self
        return textField
    }()
    
    private let grayDivider1 = UIView().grayBlock()
    private let grayDivider2 = UIView().grayBlock()
    private let grayDivider3 = UIView().grayBlock()
    
    let contentsTextViewPlaceHolder = "내용을 입력해 주세요. (최대 1,200자)"
    private lazy var contentsTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .DarkGray1
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.text = contentsTextViewPlaceHolder
        textView.font = UIFont.body16
        textView.textColor = .DarkGray4
        textView.delegate = self
        return textView
    }()
    
    private lazy var photoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "photo"), for: .normal)
        button.addTarget(self, action: #selector(didTapPhotoButton), for: .touchUpInside)
        return button
    }()
    
    private let photoLabel = UILabel().label(text: "대표 사진 1장", font: .caption12, color: .LightGray5)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //Edit 영역 아닌 곳 클릭시 키보드 내리기
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
    //        self.view.endEditing(true)
    //    }
    
    private func configureUI() {
        setNavigationBar()
        addKeyboardNotification()
        
        view .addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.width.height.equalToSuperview()
        }
        
        contentView.addSubview(categoriesView)
        categoriesView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(58)
            make.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(grayDivider1)
        grayDivider1.snp.makeConstraints { make in
            make.top.equalTo(categoriesView.snp.bottom)
            make.height.equalTo(1)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        contentView.addSubview(projectConditionsView)
        projectConditionsView.snp.makeConstraints { make in
            make.top.equalTo(grayDivider1.snp.bottom)
            make.height.equalTo(58)
            make.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(grayDivider2)
        grayDivider2.snp.makeConstraints { make in
            make.top.equalTo(projectConditionsView.snp.bottom)
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
        
        contentView.addSubview(photoButton)
        photoButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            make.leading.equalTo(view).offset(20)
        }
        
        contentView.addSubview(photoLabel)
        photoLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-27)
            make.trailing.equalTo(view).offset(-15)
        }
        
        contentView.addSubview(photoCollectionView)
        photoCollectionView.dataSource = self
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
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.sub20
        ]
        navigationController?.navigationBar.tintColor = .PointBlue
        navigationController?.navigationBar.topItem?.title = ""
        tabBarController?.tabBar.isHidden = true
        
        let rightItem =
        UIBarButtonItem(title:"등록", style: .plain, target: self, action: #selector(didTapRegisterButton))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - Action method
extension ProjectWriteViewController {
    @objc private func didTapRegisterButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapPhotoButton() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 3
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker,animated: true, completion: nil)
    }
    
    //키보드 보일 때
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height,
            right: 0.0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
        
        self.photoButton.frame.origin.y -= keyboardFrame.size.height
        self.photoLabel.frame.origin.y -= keyboardFrame.size.height
    }
    //키보드 숨겨질 때
    @objc private func keyboardWillHide(_ notification: Notification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
}

// MARK: - TextField 대리 관리자
extension ProjectWriteViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 30
        
        let currentString: NSString = textField.text! as NSString
        
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        print(currentString, newString, newString.length, maxLength)
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
    
    //편집이 시작될 때(포커스 얻는 경우)
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == contentsTextViewPlaceHolder {
            textView.text = nil
            textView.textColor = .white
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
        return CGSize(width: photoCollectionView.frame.width, height: photoCollectionView.frame.height)
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct ProjectVCPreview: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        Group {
            ProjectWriteViewController().toPreview().previewDevice(PreviewDevice(rawValue: "iPhone XS"))
                .previewDisplayName("iPhone XS")
            ProjectWriteViewController().toPreview().previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max")).previewDisplayName("iPhone 12 Pro Max")
        }
    }
}
#endif
