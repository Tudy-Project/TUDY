//
//  ViewController.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/05/18.
//

import AuthenticationServices
import CryptoKit
import UIKit

import FirebaseAuth
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import SnapKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    enum Event {
        case close
        case showSignUp
    }
    var didSendEventClosure: ((Event) -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel().label(text: "", font: .title, color: UIColor.White)
        let attributedString = NSMutableAttributedString(string: "우리,\n여기,\n바로,\n협업,")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
        label.numberOfLines = 0
        return label
    }()
    
    private let logoLabel = UILabel().label(text: "TUDY.", font: .title, color: .white)
    
    private let kakaoLoginButton = UIButton().imageButton(imageName: "kakaoLoginButton")
    private let appleLoginButton = UIButton().imageButton(imageName: "appleLoginButton")
//    private let appleLoginButton = ASAuthorizationAppleIDButton(type: .continue, style: .white)
    
    private let browseWithoutLoginButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "로그인없이 둘러보기",
                              attributes: [NSAttributedString.Key.font : UIFont.caption11,
                                           NSAttributedString.Key.foregroundColor: UIColor.white,
                                           NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    private var currentNonce: String?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        //kakaoLogout()
    }
}

extension LoginViewController {
    
    // MARK: - Methods
    private func configureUI() {
        
        view.backgroundColor = .DarkGray1
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(120)
            make.leading.equalTo(view.snp.leading).offset(53)
        }
        
        view.addSubview(logoLabel)
        logoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading).offset(55)
        }
        
        view.addSubview(appleLoginButton)
        appleLoginButton.addTarget(self, action: #selector(appleLoginButtonTapped(_:)), for: .touchUpInside)
        appleLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-84)
            make.width.equalTo(300)
            make.height.equalTo(44)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        view.addSubview(kakaoLoginButton)
        kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonTapped(_:)), for: .touchUpInside)
        kakaoLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(appleLoginButton.snp.top).offset(-15)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        view.addSubview(browseWithoutLoginButton)
        browseWithoutLoginButton.addTarget(self, action: #selector(closeLogin), for: .touchUpInside)
        browseWithoutLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-40)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    @objc private func closeLogin() {
        didSendEventClosure?(.close)
    }
}

// MARK: - Apple Login

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @objc private func appleLoginButtonTapped(_ sender: UIButton) {
            
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print ("Error Apple sign in: %@", error)
                    return
                }
                // 첫번째 로그인
                if let _ = authResult?.user.displayName {
                    self.didSendEventClosure?(.showSignUp)
                } else {
                    self.didSendEventClosure?(.close)
                }
            }
        }
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

// MARK: - Kakao Login

extension LoginViewController {
    
    @objc private func kakaoLoginButtonTapped(_ sender: UIButton) {
        
        if AuthApi.hasToken() {
            UserApi.shared.accessTokenInfo { accessTokenInfo, error in
                if let error = error {
                    print("DEBUG: 카카오톡 토큰 가져오기 에러 \(error.localizedDescription)")
                    self.kakaoLogin()
                } else {
                    // 토큰 유효성 체크 성공 (필요 시 토큰 갱신됨)
                    // 밖에서 저렇게 자동로그인 체크하면 여기까지 올 일이 있을까..
                    self.didSendEventClosure?(.showSignUp)
                }
            }
        } else {
            // 토큰이 없는 상태 로그인 필요
            kakaoLogin()
        }
    }
    
    private func kakaoLogin() {
        
        if UserApi.isKakaoTalkLoginAvailable() {
            kakaoLoginInApp()
        } else {
            kakaoLoginInWeb()
        }
    }
    
    private func kakaoLoginInApp() {
        
        UserApi.shared.loginWithKakaoTalk { oauthToken, error in
            if let error = error {
                print("DEBUG: 카카오톡 로그인 에러 \(error.localizedDescription)")
            } else {
                print("DEBUG: 카카오톡 로그인 Success")
                if let token = oauthToken {
                    print("DEBUG: 카카오톡 토큰 \(token)")
                    self.loginInFirebase()
                }
            }
        }
    }
    
    private func kakaoLoginInWeb() {
        
        UserApi.shared.loginWithKakaoAccount { oauthToken, error in
            if let error = error {
                print("DEBUG: 카카오톡 로그인 에러 \(error.localizedDescription)")
            } else {
                print("DEBUG: 카카오톡 로그인 Success")
                if let token = oauthToken {
                    print("DEBUG: 카카오톡 토큰 \(token)")
                    self.loginInFirebase()
                }
            }
        }
    }
    
    private func loginInFirebase() {
        
        UserApi.shared.me() { user, error in
            if let error = error {
                print("DEBUG: 카카오톡 사용자 정보가져오기 에러 \(error.localizedDescription)")
            } else {
                print("DEBUG: 카카오톡 사용자 정보가져오기 success.")
                Auth.auth().createUser(withEmail: (user?.kakaoAccount?.email)!,
                                       password: "\(String(describing: user?.id))") { result, error in
                    if let error = error {
                        print("DEBUG: 파이어베이스 사용자 생성 실패 \(error.localizedDescription)")
                        Auth.auth().signIn(withEmail: (user?.kakaoAccount?.email)!,
                                           password: "\(String(describing: user?.id))")
                        self.didSendEventClosure?(.close)
                    } else {
                        print("DEBUG: 파이어베이스 사용자 생성")
                        self.didSendEventClosure?(.showSignUp)
                        
                    }
                }
            }
        }
    }

    // MARK: 임시 Functions
    
    // 토큰 정보 보기
    private func kakaoAccessTokenInfo() {
        
        UserApi.shared.accessTokenInfo { accessTokenInfo, error in
            if let error = error {
                print("DEBUG: 카카오톡 토큰 정보 확인 에러 \(error.localizedDescription)")
            }
            else {
                print("DEBUG: 카카오톡 토큰 정보 확인 success")

                //do something
                _ = accessTokenInfo
            }
        }
    }
    
    // 로그아웃
    private func kakaoLogout() {
        
        UserApi.shared.logout { error in
            if let error = error {
                print("DEBUG: 카카오톡 로그아웃 에러 \(error.localizedDescription)")
            }
            else {
                print("DEBUG: 카카오톡 로그아웃 success.")
            }
        }
    }
    
    // 연결끊기
    private func kakaoDisconnect() {
        
        UserApi.shared.unlink { error in
            if let error = error {
                    print("DEBUG: 카카오톡 연결끊기 에러 \(error.localizedDescription)")
            } else {
                print("DEBUG: 카카오톡 연결끊기 success")
            }
        }
    }
    
    // 현재 로그인한 사용자의 정보 가져오기
    private func kakaoUserInfo() {
        
        UserApi.shared.me() { user, error in
            if let error = error {
                print("DEBUG: 카카오톡 사용자 정보가져오기 에러 \(error.localizedDescription)")
            }
            else {
                print("DEBUG: 카카오톡 사용자 정보가져오기 success.")
            }
        }
    }
}
