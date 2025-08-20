//
//  Challenge.swift
//  NoTempt
//
//  Created by byeongho park on 8/20/25.
//

import Foundation
// 챌린지 데이터 모델
struct Challenge: Identifiable, Codable {
    let id: String
    let name: String
    let description: String?
    let startDate: Date?
    let endDate: Date?
    let progress: Double // 진행률 (0.0 ~ 1.0)
    let participants: [User]? // 참여자 목록
}
