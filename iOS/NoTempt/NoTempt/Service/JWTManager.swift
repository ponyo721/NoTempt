//
//  JWTManager.swift
//  NoTempt
//
//  Created by byeongho park on 8/20/25.
//

import Foundation
import Security

// KeyChainHelper 라이브러리를 사용하거나 직접 구현해야 합니다.
// 아래는 개념적인 코드입니다. 실제로는 외부 라이브러리(예: KeychainSwift)를 사용하는 것이 더 안전하고 간편합니다.
class JWTManager {
    static let tokenKey = "jwtToken"

    // 토큰 저장
    static func saveToken(_ token: String) {
        let data = Data(token.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        SecItemDelete(query as CFDictionary) // 기존 토큰 삭제 후 저장
        SecItemAdd(query as CFDictionary, nil)
    }

    // 토큰 불러오기
    static func getToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess, let data = item as? Data else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }

    // 토큰 삭제
    static func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey
        ]
        SecItemDelete(query as CFDictionary)
    }
}
