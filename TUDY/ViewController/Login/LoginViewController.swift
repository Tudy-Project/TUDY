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
    
    private var kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("카카오톡으로 로그인", for: .normal)
        return button
    }()
    
    private let appleLoginButton = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
    private var currentNonce: String?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helper Functions
    
    private func configureUI() {
        
        view.backgroundColor = .darkGray
        
        view.addSubview(kakaoLoginButton)
        kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonTapped(_:)), for: .touchUpInside)
        kakaoLoginButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
        
        view.addSubview(appleLoginButton)
        appleLoginButton.addTarget(self, action: #selector(appleLoginButtonTapped(_:)), for: .touchUpInside)
        appleLoginButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(kakaoLoginButton.snp.bottom).offset(20)
        }
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
                // User is signed in to Firebase with Apple.
                // ...
                ///Main 화면으로 보내기
                //                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                //                let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
                //                mainViewController.modalPresentationStyle = .fullScreen
                //                self.navigationController?.show(mainViewController, sender: nil)
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
                    } else {
                        print("DEBUG: 파이어베이스 사용자 생성")
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
