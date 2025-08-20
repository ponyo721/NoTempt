//
//  LoginView.swift
//  NoTempt
//
//  Created by byeongho park on 8/19/25.
//

import SwiftUI

import SwiftUI

struct LoginView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationView { // NavigationStack 또는 NavigationView로 감싸야 합니다.
            VStack(spacing: 20) {
                Text("로그인 / 회원가입").font(.largeTitle)
                
                TextField("이메일", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                
                SecureField("비밀번호", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("로그인") {
                    authViewModel.login(email: email, password: password)
                }
                .buttonStyle(.borderedProminent)
                
                // 소셜 로그인 버튼
                Button(action: { /* Apple 로그인 로직 */ }) {
                    HStack {
                        Image(systemName: "apple.logo")
                        Text("Apple 로그인")
                    }
                }
                .buttonStyle(.bordered)
                
                // 회원가입 페이지로 이동하는 내비게이션 링크 추가
                NavigationLink("회원가입") {
                    // SignUpView()로 이동
                    SignUpView()
                }
                .padding(.top, 20)
            }
            .padding()
            .fullScreenCover(isPresented: $authViewModel.isLoggedIn) {
                HomeView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
#Preview {
    LoginView()
}
