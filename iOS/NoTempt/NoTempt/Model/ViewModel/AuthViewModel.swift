//
//  AuthViewModel.swift
//  NoTempt
//
//  Created by byeongho park on 8/20/25.
//

import SwiftUI
import Foundation

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var user: User?
    
    @Published var loginError: String? // 로그인 실패 시 오류 메시지
    
    private let apiService = APIService.shared

    init() {
        checkTokenValidity()
    }
    
    // 이메일과 비밀번호로 로그인 요청
    func login(email: String, password: String) {
        // 클라이언트 측 유효성 검사
        if email.isEmpty || password.isEmpty {
            self.loginError = "이메일과 비밀번호를 입력해주세요."
            return
        }
        
        let loginRequest = LoginRequest(email: email, password: password)
        
        apiService.login(request: loginRequest) { result in
            switch result {
            case .success(let response):
                // 서버로부터 받은 JWT 토큰 저장
                JWTManager.saveToken(response.token)
                self.isLoggedIn = true
                self.user = User(id: "user123", email: email, name: "테스터", profileImageUrl: nil)
                print("로그인 성공! JWT 토큰 저장 완료")
            case .failure(let error):
                // 로그인 실패 시 오류 메시지 설정
                switch error {
                case .invalidCredentials:
                    self.loginError = "이메일 또는 비밀번호가 올바르지 않습니다."
                default:
                    self.loginError = "로그인에 실패했습니다. 다시 시도해주세요."
                }
                print("로그인 실패: \(error)")
                self.isLoggedIn = false
            }
        }
    }
    
    // 저장된 토큰 유효성 검사 (앱 시작 시 호출)
    func checkTokenValidity() {
#if DEBUG
        JWTManager.deleteToken()
#endif
        if let token = JWTManager.getToken() {
            // 실제로는 API 호출을 통해 토큰 유효성 검증
            // APIService.shared.validateToken(...)
            print("저장된 토큰 발견, 유효성 검사 시작...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isLoggedIn = true
                self.user = User(id: "user123", email: "test@example.com", name: "테스터", profileImageUrl: nil)
                print("토큰 유효, 자동 로그인")
            }
        } else {
            self.isLoggedIn = false
            print("토큰 없음, 로그인 화면으로 이동")
        }
    }
    
    func logout() {
        self.isLoggedIn = false
        self.user = nil
        JWTManager.deleteToken()
        print("로그아웃 완료 및 토큰 삭제")
    }
}

// 로그인 요청에 사용될 데이터 모델
struct LoginRequest: Codable {
    let email: String
    let password: String
}

// 로그인 응답에 사용될 데이터 모델
struct LoginResponse: Codable {
    let token: String
}
