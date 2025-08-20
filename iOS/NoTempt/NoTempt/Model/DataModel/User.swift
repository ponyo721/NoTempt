//
//  User.swift
//  NoTempt
//
//  Created by byeongho park on 8/20/25.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let email: String
    let name: String
    // 필요에 따라 프로필 이미지 URL, 친구 목록 등 추가 가능
    let profileImageUrl: String?
}
