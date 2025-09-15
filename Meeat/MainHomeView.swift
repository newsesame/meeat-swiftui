import SwiftUI

struct MainHomeView: View {
    @State private var showProfile = false
    @State private var candidates: [Candidate] = [
        Candidate(
            name: "Happy Chau", age: 22, jobTitle: "Software Engineer", mbtiType: "INTJ", quote: "Just want to eat burgers with you.", interests: ["Movies", "Food", "Fitness"], foodPreferences: ["Japanese", "Italian", "BBQ"], imageName: "Person1"
        ),
        Candidate(
            name: "Carmen Lee", age: 26, jobTitle: "UX Designer", mbtiType: "ENFP", quote: "Design is not just about aesthetics, but about experience.", interests: ["Reading", "Travel", "Coffee"], foodPreferences: ["Cafe", "French", "Desserts"], imageName: "Person2"
        ),
        Candidate(
            name: "Brian Wong", age: 30, jobTitle: "Photographer", mbtiType: "ISFP", quote: "See the world through the lens, record life with food.", interests: ["Music", "Photography", "Hiking"], foodPreferences: ["Chinese", "Hot Pot", "Seafood"], imageName: "Person3"
        ),
        Candidate(
            name: "Sarah Chen", age: 27, jobTitle: "Yoga Instructor", mbtiType: "INFJ", quote: "A good meal is better than a hundred conversations.", interests: ["Yoga", "Cooking", "Art"], foodPreferences: ["Vegetarian", "Healthy", "Japanese"], imageName: "Person4"
        )
    ]
    @State private var currentCandidateIndex: Int = 0
    @State private var refreshCount: Int = 0
    @State private var lastRefreshDate: Date = Date()
    @State private var showMeetUpWait = false
    @State private var inviteSent = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                MatchCandidateView(
                    candidates: $candidates,
                    currentCandidateIndex: $currentCandidateIndex,
                    refreshCount: $refreshCount,
                    lastRefreshDate: $lastRefreshDate,
                    onSendMatch: { candidate in
                        inviteSent = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showMeetUpWait = true
                        }
                    },
                    onSkip: {
                        if candidates.count > 1 {
                            currentCandidateIndex = (currentCandidateIndex + 1) % candidates.count
                        }
                    },
                    onProfileTapped: {
                        showProfile = true
                    },
                    onRefresh: {
                        refreshCount += 1
                        lastRefreshDate = Date()
                        currentCandidateIndex = (currentCandidateIndex + 1) % candidates.count
                    }
                )
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("350")
                            .font(.headline)
                            .foregroundColor(.orange)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Button(action: {}) {
                        Text("Meeat Matching Home")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showProfile = true }) {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundColor(.gray)
                    }
                }
            }
            .sheet(isPresented: $showProfile) {
                ProfileTab()
            }
            .fullScreenCover(isPresented: $showMeetUpWait) {
                MeetUpWaitView()
            }
        }
    }
}

// Dummy Ranking List
struct RankingSheetView: View {
    let dummyRanking = [
        (name: "Alex Chan", streak: 7),
        (name: "Carmen Lee", streak: 5),
        (name: "Brian Wong", streak: 3),
        (name: "Sarah Chen", streak: 2)
    ]
    var body: some View {
        NavigationView {
            List {
                ForEach(dummyRanking, id: \.name) { item in
                    HStack {
                        Image(systemName: "flame.fill").foregroundColor(.orange)
                        Text(item.name)
                        Spacer()
                        Text("🔥 \(item.streak)")
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                }
            }
            .navigationTitle("Interaction Ranking")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Dummy Invite List
struct InviteListSheetView: View {
    let dummyInvites = [
        (name: "Alex Chan", status: "Waiting for acceptance"),
        (name: "Carmen Lee", status: "Accepted"),
        (name: "Brian Wong", status: "Expired")
    ]
    var body: some View {
        NavigationView {
            List {
                ForEach(dummyInvites, id: \.name) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text(item.status)
                            .foregroundColor(item.status == "Accepted" ? .green : (item.status == "Waiting for acceptance" ? .orange : .gray))
                    }
                }
            }
            .navigationTitle("Invitation List")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
} 

// Personal Settings Page
struct ProfileTab: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
                .padding(.top, 40)
            Text("Personal Settings Page")
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
        }
        .navigationTitle("Personal Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
} 
