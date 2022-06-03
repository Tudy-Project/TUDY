//
//  ProjectWriteViewController.swift
//  TUDY
//
//  Created by jamescode on 2022/05/27.
//

import UIKit
import SnapKit

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class ProjectWriteViewController: UIViewController {
    
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let categoriesView = RelatedJobCategoriesView.init(frame: .zero, title: "관련 직무 카테고리 📌")
    private let projectConditionsView = RelatedJobCategoriesView.init(frame: .zero, title: "프로젝트 조건 💡")
    
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
    
    private let photoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "photo"), for: .normal)
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
