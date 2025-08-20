//
//  HomeView.swift
//  NoTempt
//
//  Created by byeongho park on 8/19/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("어떤 챌린지 시작할까?").font(.title)
                
                // 챌린지 목록
                List(homeViewModel.challenges) { challenge in
                    NavigationLink(destination: ChallengeDetailView(challenge: challenge)) {
                        VStack(alignment: .leading) {
                            Text(challenge.name).font(.headline)
                            ProgressView(value: challenge.progress)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("홈")
            .onAppear {
                homeViewModel.fetchChallenges()
            }
        }
    }
}
#Preview {
    HomeView()
}
