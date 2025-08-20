//
//  Message.swift
//  NoTempt
//
//  Created by byeongho park on 8/20/25.
//

import Foundation
// 채팅 메시지 데이터 모델
struct Message: Identifiable, Codable {
    var id: UUID = UUID()
    let userId: String
    let userName: String
    let content: String
    let timestamp: Date
}
