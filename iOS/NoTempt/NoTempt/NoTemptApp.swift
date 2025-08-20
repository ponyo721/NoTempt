//
//  NoTemptApp.swift
//  NoTempt
//
//  Created by byeongho park on 8/19/25.
//

import SwiftUI

@main
struct NoTemptApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isLoggedIn {
                // 토큰이 유효하면 홈 화면으로 이동
                HomeView()
                    .environmentObject(authViewModel) // 환경 객체로 전달
            } else {
                // 토큰이 없거나 유효하지 않으면 로그인 화면으로 이동
                LoginView()
                    .environmentObject(authViewModel) // 환경 객체로 전달
            }
        }
    }
}
