//
//  SignUpViewModel.swift
//  NoTempt
//
//  Created by byeongho park on 8/20/25.
//

import SwiftUI
import Foundation

class SignUpViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var nickname = ""
    @Published var birthday = Date()
    @Published var gender = ""
    @Published var phoneNumber = ""
    
    @Published var isSigningUp = false
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    // 이메일 정규식 패턴
    private let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    func signUp() {
        guard !isSigningUp else { return }
        
        // 1. 모든 필드가 비어있지 않은지 검사
        if email.isEmpty || password.isEmpty || nickname.isEmpty || phoneNumber.isEmpty {
            setAlert(title: "알림", message: "모든 정보를 입력해주세요.")
            return
        }
        
        // 2. 이메일 형식 유효성 검사
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: email) {
            setAlert(title: "입력 오류", message: "유효한 이메일 주소를 입력해주세요.")
            return
        }
        
        // 3. 비밀번호 길이 검사 (예: 8자 이상)
        if password.count < 8 {
            setAlert(title: "입력 오류", message: "비밀번호는 8자 이상이어야 합니다.")
            return
        }
        
        // 4. 핸드폰 번호 형식 검사 (숫자만 입력되었는지)
        if !phoneNumber.allSatisfy({ $0.isNumber }) {
            setAlert(title: "입력 오류", message: "핸드폰 번호는 숫자만 입력해주세요.")
            return
        }

        isSigningUp = true
        
        // --- 서버 요청 로직 (이하 동일) ---
        let requestBody: [String: Any] = [
            "email": email,
            "password": password,
            "nickname": nickname,
            "birthday": ISO8601DateFormatter().string(from: birthday),
            "gender": gender,
            "phoneNumber": phoneNumber
        ]
        
        guard let url = URL(string: "https://api.yourchallengeapp.com/signup") else {
            setAlert(title: "오류", message: "잘못된 URL입니다.")
            isSigningUp = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            setAlert(title: "오류", message: "데이터 변환 오류.")
            isSigningUp = false
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isSigningUp = false
                
                if let httpResponse = response as? HTTPURLResponse {
                    if (200...299).contains(httpResponse.statusCode) {
                        self.setAlert(title: "성공", message: "회원가입이 완료되었습니다!")
                    } else if httpResponse.statusCode == 409 {
                        self.setAlert(title: "실패", message: "이미 존재하는 이메일입니다.")
                    } else {
                        self.setAlert(title: "실패", message: "회원가입에 실패했습니다. 다시 시도해주세요. (\(httpResponse.statusCode))")
                    }
                } else if let error = error {
                    self.setAlert(title: "오류", message: "네트워크 오류: \(error.localizedDescription)")
                } else {
                    self.setAlert(title: "오류", message: "알 수 없는 오류가 발생했습니다.")
                }
            }
        }.resume()
    }
    
    // alert 상태를 설정하는 헬퍼 함수
    private func setAlert(title: String, message: String) {
        self.alertTitle = title
        self.alertMessage = message
        self.showAlert = true
    }
}
