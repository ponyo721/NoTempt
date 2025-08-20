//
//  HomeViewModel.swift
//  NoTempt
//
//  Created by byeongho park on 8/20/25.
//

import SwiftUI
import Foundation

class HomeViewModel: ObservableObject {
    @Published var challenges: [Challenge] = []
    
    func fetchChallenges() {
        // 실제 API 엔드포인트 URL로 변경해야 함
        guard let url = URL(string: "\(serverAddress)\(challengesSubPath)") else { return }

        // APIService를 통해 챌린지 목록을 가져옴
        APIService.shared.request(url: url, method: "GET") { (result: Result<[Challenge], APIService.APIError>) in
            switch result {
            case .success(let fetchedChallenges):
                self.challenges = fetchedChallenges
                print("챌린지 목록 로드 성공")
            case .failure(let error):
                print("챌린지 목록 로드 실패: \(error)")
                // 실패 시 더미 데이터 로드 (개발용)
                self.challenges = [
                    Challenge(id: "c1", name: "매일 푸시업 100회", description: "5일간 푸시업 100회씩 도전", startDate: Date(), endDate: Date().addingTimeInterval(5*24*3600), progress: 0.6, participants: []),
                    Challenge(id: "c2", name: "하루 한 챕터 독서", description: "매일 책 한 챕터씩 읽기", startDate: Date(), endDate: Date().addingTimeInterval(30*24*3600), progress: 0.2, participants: [])
                ]
            }
        }
    }
}
