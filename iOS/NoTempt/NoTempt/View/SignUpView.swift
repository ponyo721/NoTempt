//
//  SignUpView.swift
//  NoTempt
//
//  Created by byeongho park on 8/20/25.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var signUpViewModel = SignUpViewModel()
    
    var body: some View {
        Form {
            Section(header: Text("기본 정보")) {
                TextField("이메일", text: $signUpViewModel.email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                SecureField("비밀번호", text: $signUpViewModel.password)
                TextField("닉네임", text: $signUpViewModel.nickname)
                
                // 생년월일
                DatePicker("생년월일", selection: $signUpViewModel.birthday, displayedComponents: .date)
                
                // 성별
                Picker("성별", selection: $signUpViewModel.gender) {
                    Text("선택 안 함").tag("")
                    Text("남성").tag("male")
                    Text("여성").tag("female")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                TextField("핸드폰 번호", text: $signUpViewModel.phoneNumber)
                    .keyboardType(.phonePad)
            }
            
            Button("회원가입") {
                signUpViewModel.signUp()
            }
            .disabled(signUpViewModel.isSigningUp) // 회원가입 중일 때 버튼 비활성화
        }
        .navigationTitle("회원가입")
        .alert(isPresented: $signUpViewModel.showAlert) {
            Alert(title: Text(signUpViewModel.alertTitle), message: Text(signUpViewModel.alertMessage), dismissButton: .default(Text("확인")))
        }
    }
}

#Preview {
    SignUpView()
}
