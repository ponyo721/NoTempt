//
//  LoginView.swift
//  NoTempt
//
//  Created by byeongho park on 8/19/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
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
            
            // ... Google 로그인 버튼 등
        }
        .padding()
        .fullScreenCover(isPresented: $authViewModel.isLoggedIn) {
            HomeView()
        }
    }
}

#Preview {
    LoginView()
}
