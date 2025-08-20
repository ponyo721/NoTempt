//
//  CreateChallengeView.swift
//  NoTempt
//
//  Created by byeongho park on 8/20/25.
//

import SwiftUI

struct CreateChallengeView: View {
    @State private var challengeName = ""
    @State private var category = "운동"
    
    var body: some View {
        Form {
            Section(header: Text("챌린지 생성")) {
                TextField("챌린지 제목", text: $challengeName)
                Picker("카테고리", selection: $category) {
                    Text("운동").tag("운동")
                    Text("공부").tag("공부")
                    Text("취미").tag("취미")
                }
            }
            
            Section(header: Text("친구 초대")) {
                // 친구 목록을 불러와 선택하는 UI
                Button("친구 초대") {
                    // 초대 로직
                }
            }
            
            Button("챌린지 생성") {
                // API 호출 로직
            }
        }
    }
}

#Preview {
    CreateChallengeView()
}
