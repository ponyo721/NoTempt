//
//  ChallengeDetailView.swift
//  NoTempt
//
//  Created by byeongho park on 8/20/25.
//

import SwiftUI

struct ChallengeDetailView: View {
    @StateObject private var webSocketService = WebSocketService()
    var challenge: Challenge
    @State private var messageText = ""
    
    var body: some View {
        VStack {
            Text(challenge.name).font(.largeTitle)
            
            // 챌린지 진행 상황 및 랭킹 UI
            
            // 실시간 채팅 영역
            List(webSocketService.messages) { message in
                Text(message.content)
            }
            
            HStack {
                TextField("메시지 입력...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("보내기") {
                    webSocketService.sendMessage(messageText, for: challenge.id)
                    messageText = ""
                }
            }
            .padding()
        }
        .navigationTitle("챌린지 상세")
        .onAppear {
            webSocketService.connect(to: challenge.id)
        }
        .onDisappear {
            webSocketService.disconnect()
        }
    }
}

#Preview {
//    ChallengeDetailView()
}
