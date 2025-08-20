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

    // 이니셜라이저에서 토큰 유효성을 즉시 검사
    init() {
        checkTokenValidity()
    }
    
    // API 통신을 통해 로그인 처리
    func login(email: String, password: String) {
        // 실제로는 APIService를 통해 로그인 API 호출
        // URLSession.shared.dataTask(with: loginRequest) { ... }
        
        // 성공했다고 가정하고 토큰과 유저 정보 저장
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let dummyToken = "dummy-jwt-token" // 서버에서 받은 토큰
            JWTManager.saveToken(dummyToken)
            self.isLoggedIn = true
            self.user = User(id: "user123", email: email, name: "테스터", profileImageUrl: nil)
            print("로그인 성공 및 토큰 저장 완료")
        }
    }
    
    // 저장된 토큰 유효성 검사 (앱 시작 시 호출)
    func checkTokenValidity() {
#if DEBUG
        JWTManager.deleteToken()
#endif
        if let token = JWTManager.getToken() {
            // 실제로는 API 호출을 통해 토큰 유효성을 검증
            // APIService.shared.request(...)
            print("저장된 토큰 발견, 유효성 검사 시작...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // 검사 성공했다고 가정
                self.isLoggedIn = true
                self.user = User(id: "user123", email: "test@example.com", name: "테스터", profileImageUrl: nil)
                print("토큰 유효, 자동 로그인")
            }
        } else {
            self.isLoggedIn = false
            print("토큰 없음, 로그인 화면으로 이동")
        }
    }
    
    // 로그아웃 로직
    func logout() {
        self.isLoggedIn = false
        self.user = nil
        JWTManager.deleteToken()
        print("로그아웃 완료 및 토큰 삭제")
    }
}
