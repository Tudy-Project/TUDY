//
//  ViewController.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/05/18.
//

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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension LoginViewController {
    
    // MARK: - Helper Functions
    
    private func configureUI() {
        
        view.backgroundColor = .darkGray
        
        view.addSubview(kakaoLoginButton)
        kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonTapped(_:)), for: .touchUpInside)
        kakaoLoginButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
    }
    
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
    

    // MARK: - 임시 Functions
    
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
