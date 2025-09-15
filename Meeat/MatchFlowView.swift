import SwiftUI
import MapKit

enum MatchFlowStep {
    case locationSelection
    case timeSelection
    case matching
    case meetUpWait
}

struct MatchFlowView: View {
    @State private var currentStep: MatchFlowStep = .locationSelection
    
    // 地圖選擇
    @State private var selectedLocation: LocationPin? = nil
    
    // 時間選擇
    @State private var startTime = Date()
    @State private var endTime = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    
    // 候選人資料（假資料）
    @State private var candidates: [Candidate] = [
        Candidate(
            name: "Alex Chan", 
            age: 28, 
            jobTitle: "軟體工程師",
            mbtiType: "INTJ",
            quote: "程式碼如詩，美食如歌。",
            interests: ["電影", "美食", "健身"], 
            foodPreferences: ["日式", "義大利", "燒烤"],
            imageName: "person1"
        ),
        Candidate(
            name: "Carmen Lee", 
            age: 26, 
            jobTitle: "UX 設計師",
            mbtiType: "ENFP",
            quote: "設計不只是美觀，更是體驗。",
            interests: ["閱讀", "旅行", "咖啡"], 
            foodPreferences: ["咖啡廳", "法式", "甜點"],
            imageName: "person2"
        ),
        Candidate(
            name: "Brian Wong", 
            age: 30, 
            jobTitle: "攝影師",
            mbtiType: "ISFP",
            quote: "透過鏡頭看世界，用美食記錄生活。",
            interests: ["音樂", "攝影", "遠足"], 
            foodPreferences: ["中式", "火鍋", "海鮮"],
            imageName: "person3"
        ),
        Candidate(
            name: "Sarah Chen", 
            age: 27, 
            jobTitle: "瑜伽老師",
            mbtiType: "INFJ",
            quote: "一頓好飯，勝過百句聊天。",
            interests: ["瑜伽", "烹飪", "藝術"], 
            foodPreferences: ["素食", "健康", "日式"],
            imageName: "person4"
        )
    ]
    @State private var currentCandidateIndex: Int = 0
    
    // 刷新次數
    @State private var refreshCount: Int = 0
    @State private var lastRefreshDate: Date = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                // 步驟指示器
                StepIndicator(currentStep: currentStep)
                    .padding()
                
                // 內容區域
                Group {
                    switch currentStep {
                    case .locationSelection:
                        MapSearchView(
                            selectedLocation: $selectedLocation,
                            onSetTime: {
                                currentStep = .timeSelection
                            }
                        )
                        
                    case .timeSelection:
                        TimeSelectorView(
                            startTime: $startTime,
                            endTime: $endTime,
                            onStartMatching: {
                                currentStep = .matching
                            }
                        )
                        
                    case .matching:
                        MatchCandidateView(
                            candidates: $candidates,
                            currentCandidateIndex: $currentCandidateIndex,
                            refreshCount: $refreshCount,
                            lastRefreshDate: $lastRefreshDate,
                            onSendMatch: { candidate in
                                // 處理發送配對請求
                                print("發送配對請求給: \(candidate.name)")
                                // 配對成功後進入見面等待階段
                                currentStep = .meetUpWait
                            },
                            onSkip: {
                                // 跳到下一位候選人
                                if candidates.count > 1 {
                                    currentCandidateIndex = (currentCandidateIndex + 1) % candidates.count
                                }
                            }
                        )
                        
                    case .meetUpWait:
                        MeetUpWaitView()
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Meeat 配對流程")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if currentStep != .locationSelection && currentStep != .meetUpWait {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("返回") {
                            switch currentStep {
                            case .timeSelection:
                                currentStep = .locationSelection
                            case .matching:
                                currentStep = .timeSelection
                            case .meetUpWait:
                                currentStep = .matching
                            default:
                                break
                            }
                        }
                    }
                }
            }
        }
    }
}

struct StepIndicator: View {
    let currentStep: MatchFlowStep
    
    private var steps: [(String, Bool)] {
        [
            ("選擇地點", currentStep != .locationSelection),
            ("設定時間", currentStep == .matching || currentStep == .meetUpWait),
            ("開始配對", currentStep == .matching || currentStep == .meetUpWait),
            ("見面等待", currentStep == .meetUpWait)
        ]
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                HStack(spacing: 8) {
                    Circle()
                        .fill(step.1 ? Color.blue : Color.gray)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Text("\(index + 1)")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        )
                    
                    Text(step.0)
                        .font(.caption)
                        .foregroundColor(step.1 ? .blue : .gray)
                    
                    if index < steps.count - 1 {
                        Rectangle()
                            .fill(step.1 ? Color.blue : Color.gray.opacity(0.3))
                            .frame(height: 2)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}

#Preview {
    MatchFlowView()
} 