import SwiftUI

struct MatchCandidateView: View {
    @Binding var candidates: [Candidate]
    @Binding var currentCandidateIndex: Int
    @Binding var refreshCount: Int
    @Binding var lastRefreshDate: Date
    var onSendMatch: (Candidate) -> Void
    var onSkip: () -> Void
    var onProfileTapped: (() -> Void)? = nil
    var onRefresh: (() -> Void)? = nil
    
    private var candidate: Candidate {
        candidates[currentCandidateIndex]
    }
    
    var body: some View {
        let cardWidth: CGFloat = UIScreen.main.bounds.width - 48
        let cardHeight: CGFloat = 580
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                ZStack(alignment: .bottom) {
                    // Profile photo or default image
                    if let uiImage = UIImage(named: candidate.imageName) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: cardWidth, height: cardHeight)
                            .clipped()
                    } else {
                        ZStack {
                            Color(.systemGray5)
                            Image(systemName: "person.crop.square.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .foregroundColor(.gray)
                        }
                        .frame(width: cardWidth, height: cardHeight)
                    }
                    // Overlay block
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .center, spacing: 8) {
                            Text("\(candidate.name), \(candidate.age)")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(10)
                            if !candidate.mbtiType.isEmpty {
                                Text(candidate.mbtiType)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                            }
                        }
                        if !candidate.jobTitle.isEmpty {
                            Text(candidate.jobTitle)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 2)
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(8)
                        }
                        if !candidate.quote.isEmpty {
                            HStack(alignment: .top, spacing: 6) {
                                Image(systemName: "quote.opening")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                Text("\"" + candidate.quote + "\"")
                                    .font(.body)
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(12)
                        }
                        if !candidate.interests.isEmpty {
                            HStack(spacing: 6) {
                                ForEach(candidate.interests, id: \.self) { interest in
                                    Text(interest)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.white.opacity(0.2))
                                        .cornerRadius(8)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        if !candidate.foodPreferences.isEmpty {
                            HStack(spacing: 6) {
                                ForEach(candidate.foodPreferences, id: \.self) { food in
                                    Text(food)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.yellow.opacity(0.7))
                                        .cornerRadius(8)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]), startPoint: .bottom, endPoint: .top)
                            .cornerRadius(24)
                    )
                }
                .frame(width: cardWidth, height: cardHeight)
                .cornerRadius(24)
                .shadow(radius: 8)
                .padding(.top, 8)
                // Refresh button in the top right corner of the card
                Button(action: { onRefresh?() }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.black.opacity(0.25))
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .padding([.top, .trailing], 24)
            }
            Spacer(minLength: 32)
            HStack(spacing: 16) {
                Button(action: onSkip) {
                    HStack {
                        Image(systemName: "xmark")
                        Text("Skip")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundColor(.black)
                    .cornerRadius(12)
                }
                Button(action: { onSendMatch(candidate) }) {
                    HStack {
                        Image(systemName: "heart.fill")
                        Text("Send Match")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pink)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
            Spacer(minLength: 0)
        }
    }
}

#Preview {
    MatchCandidateView(
        candidates: .constant([
            Candidate(
                name: "Alex Chan", 
                age: 28, 
                jobTitle: "Software Engineer",
                mbtiType: "INTJ",
                quote: "Code is poetry, food is melody.",
                interests: ["Movies", "Food", "Fitness"], 
                foodPreferences: ["Japanese", "Italian", "BBQ"],
                imageName: "person1"
            ),
            Candidate(
                name: "Carmen Lee", 
                age: 26, 
                jobTitle: "UX Designer",
                mbtiType: "ENFP",
                quote: "Design is not just about aesthetics, but about experience.",
                interests: ["Reading", "Travel", "Coffee"], 
                foodPreferences: ["Cafe", "French", "Desserts"],
                imageName: "person2"
            )
        ]),
        currentCandidateIndex: .constant(0),
        refreshCount: .constant(0),
        lastRefreshDate: .constant(Date()),
        onSendMatch: { _ in },
        onSkip: {},
        onProfileTapped: nil,
        onRefresh: nil
    )
} 
