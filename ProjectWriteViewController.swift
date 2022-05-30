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
    
    // MARK: - Cell Data
    var tableViewData = [cellData]()
    
    // MARK: - Properties
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목을 입력해 주세요. (최대 30자)"
        textField.font = UIFont.body16
        textField.delegate = self
        return textField
    }()
    
    private let grayBlock = UIView().grayBlock()
    private let grayBlockBottom = UIView().grayBlock()
    
    private let grayDivider = UIView().grayBlock()
    
    let contentsTextViewPlaceHolder = "내용을 입력해 주세요. (최대 1,200자)"
    private lazy var contentsTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .green
        textView.isScrollEnabled = false
        textView.text = contentsTextViewPlaceHolder
        textView.font = UIFont.body16
        textView.textColor = .systemGray4
        textView.delegate = self
        return textView
    }()
    
    private var tableView = UITableView()
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
//        tableViewData = [
//            cellData(opened: false, title: "관련 직무 카테고리", sectionData: ["Cell1"]),
//            cellData(opened: false, title: "회의 조건 (선택)", sectionData: ["Cell1"]),
//        ]
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(ProjectWriteTableViewCell.self, forCellReuseIdentifier: "TableViewCell")
//        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth*0.5, height: screenHeight))
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        title = "게시글 작성"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.sub20
        ]
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = ""
        tabBarController?.tabBar.isHidden = true
        
        let rightItem =
        UIBarButtonItem(title:"등록", style: .plain, target: self, action: #selector(didTapRegisterButton))
        self.navigationItem.rightBarButtonItem = rightItem
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(grayBlock)
        containerView.addSubview(titleTextField)
        containerView.addSubview(grayDivider)
        containerView.addSubview(contentsTextView)
        containerView.addSubview(grayBlockBottom)
        containerView.addSubview(tableView)
    
        let safeArea = view.safeAreaLayoutGuide
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeArea.snp.top)
            make.bottom.equalTo(safeArea.snp.bottom)
            make.leading.equalTo(safeArea.snp.leading)
            make.trailing.equalTo(safeArea.snp.trailing)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            make.leading.equalTo(scrollView)
            make.trailing.equalTo(scrollView)
            //width 설정으로 세로방향 스크롤, 컨테이너 폭을 스크롤뷰와 맞춤
            make.width.equalTo(scrollView)
        }
        //height설정 안하면 텍스트필드가 작동이 안되었음
        //컨테이너뷰와 스크롤뷰의 높이는 같지만 우선순위는 required가 아니도록 설정
        let heightAnchor = containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightAnchor.priority = .defaultHigh
        heightAnchor.isActive = true
        
        grayBlock.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(grayBlock.snp.bottom).offset(16)
            make.leading.equalTo(grayBlock.snp.leading).offset(16)
            make.trailing.equalTo(grayBlock.snp.trailing).offset(-16)
        }
        
        grayDivider.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(16)
            make.height.equalTo(2)
            make.leading.equalTo(titleTextField)
            make.trailing.equalTo(titleTextField)
        }
        
        contentsTextView.snp.makeConstraints { make in
            make.top.equalTo(grayDivider.snp.bottom).offset(16)
            make.leading.equalTo(titleTextField)
            make.trailing.equalTo(titleTextField)
        }
        
        grayBlockBottom.snp.makeConstraints { make in
            make.top.equalTo(contentsTextView.snp.bottom).offset(16)
            make.height.equalTo(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(grayBlockBottom.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
               }
        
        tableViewData = [
            cellData(opened: false, title: "관련 직무 카테고리", sectionData: ["Cell1"]),
            cellData(opened: false, title: "회의 조건 (선택)", sectionData: ["Cell1"]),
        ]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProjectWriteTableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth*0.5, height: screenHeight))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

// MARK: - action method
extension ProjectWriteViewController {
    @objc private func didTapRegisterButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        var contentInset = contentsTextView.contentInset
        //contentsTextView의 컨텐츠인셋바텀을 키보드 높이 만큼 지정.
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        //키보드가 내려갈 때 컨텐츠인셋을 원상태로 돌려준다.
        contentsTextView.contentInset = UIEdgeInsets.zero
        contentsTextView.scrollIndicatorInsets = contentsTextView.contentInset
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
}

// MARK: - TextView 대리 관리자
extension ProjectWriteViewController: UITextViewDelegate {
    
    func setPlaceHolder() {
        contentsTextView.text = contentsTextViewPlaceHolder
        contentsTextView.textColor =  UIColor.systemGray4
    }
    
    //편집이 시작될 때(포커스 얻는 경우)
    func textViewDidBeginEditing(_ textView: UITextView) {
        contentsTextView.text = nil
        contentsTextView.textColor = .black
    }
    
    //편집이 종료될 때(포커스 잃는 경우)
    func textViewDidEndEditing(_ textView: UITextView) {
        //문자열의 앞뒤 공백과 줄바꿈을 제거
        //공백 또는 줄바꿈을 입력할 경우에도 placeholder 적용
        if contentsTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            contentsTextView.text = contentsTextViewPlaceHolder
            contentsTextView.textColor = .systemGray4
        }
    }
}

// MARK: - UITableViewDelegate
extension ProjectWriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}

// MARK: - UITableViewDataSource
extension ProjectWriteViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          if tableViewData[section].opened == true {
              // tableView Section이 열려있으면 Section Cell 하나에 sectionData 개수만큼 추가해줘야 함
              return tableViewData[section].sectionData.count + 1
          } else {
              // tableView Section이 닫혀있을 경우에는 Section Cell 하나만 보여주면 됨
              return 1
          }
      }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           // section 부분 코드
           if indexPath.row == 0 {
               guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
                       as? ProjectWriteTableViewCell else { return UITableViewCell() }
               cell.configureUI()
               cell.tableLabel.text = tableViewData[indexPath.section].title
               return cell
               
           // sectionData 부분 코드
           } else {
               guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
                       as? ProjectWriteTableViewCell else { return UITableViewCell() }
               cell.configureUI()
               cell.tableLabel.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
               return cell
           }
           
       }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
           // 셀 선택 시 회색에서 다시 변하게 해주는 것
           tableView.deselectRow(at: indexPath, animated: true)
           
           // section 부분 선택하면 열리게 설정
           if indexPath.row == 0 {
               // section이 열려있다면 다시 닫힐 수 있게 해주는 코드
               tableViewData[indexPath.section].opened = !tableViewData[indexPath.section].opened
               
               // 모든 데이터를 새로고침하는 것이 아닌 해당하는 섹션 부분만 새로고침
               tableView.reloadSections([indexPath.section], with: .none)
           
           // sectionData 부분을 선택하면 아무 작동하지 않게 설정
           } else {
               print("이건 sectionData 선택한 거야")
           }
           
           print([indexPath.section], [indexPath.row])

           
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
