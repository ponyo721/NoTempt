//
//  WebSocketService.swift
//  NoTempt
//
//  Created by byeongho park on 8/20/25.
//

import SwiftUI
import Foundation

class WebSocketService: ObservableObject {
    @Published var messages: [Message] = []
    
    private var webSocketTask: URLSessionWebSocketTask?
    
    // 웹소켓 연결
    func connect(to challengeId: String) {
        // 백엔드 웹소켓 URL로 변경해야 합니다.
        // 예를 들어, ws://localhost:8080/chat/<challengeId>
        guard let url = URL(string: "wss://echo.websocket.events") else { return }
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        
        webSocketTask?.resume()
        
        receiveMessage()
        print("WebSocket 연결 시도: \(challengeId)")
    }
    
    // 연결 종료
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        print("WebSocket 연결 종료")
    }
    
    // 메시지 수신
    private func receiveMessage() {
        webSocketTask?.receive { result in
            switch result {
            case .failure(let error):
                print("수신 오류: \(error)")
                return
            case .success(let message):
                switch message {
                case .string(let text):
                    print("수신 메시지: \(text)")
                    // 메시지를 JSON으로 변환하여 messages 배열에 추가
                    let dummyMessage = Message(userId: "dummy", userName: "친구", content: text, timestamp: Date())
                    DispatchQueue.main.async {
                        self.messages.append(dummyMessage)
                    }
                case .data(let data):
                    print("수신 데이터: \(data)")
                @unknown default:
                    break
                }
            }
            // 재귀적으로 다음 메시지 수신을 계속 기다림
            self.receiveMessage()
        }
    }
    
    // 메시지 전송
    func sendMessage(_ text: String, for challengeId: String) {
        let message = URLSessionWebSocketTask.Message.string(text)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("전송 오류: \(error)")
            } else {
                print("메시지 전송 성공: \(text)")
            }
        }
    }
}
