import SwiftUI
import CoreLocation
import GoogleMaps

struct MeetUpWaitView: View {
    @State private var userLocation = CLLocationCoordinate2D(latitude: 25.0330, longitude: 121.5654) // Taipei city center
    @State private var matchedUserLocation = CLLocationCoordinate2D(latitude: 25.0335, longitude: 121.5659) // Slightly offset
    @State private var restaurantLocation = CLLocationCoordinate2D(latitude: 25.0332, longitude: 121.5656) // Middle position
    
    @State private var userHasArrived = false
    @State private var matchedUserHasArrived = false
    @State private var showingChat = false
    @State private var showRestaurantInfo = false

    let meetingTime = "19:30"
    let restaurantName = "Din Tai Fung Xinyi Store"
    let restaurantAddress = "No. 7, Section 5, Xinyi Road, Xinyi District, Taipei City"
    let restaurantImageURL = "https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=400&q=80"
    let restaurantRating = 4.7
    
    private var statusMessage: String {
        if userHasArrived && matchedUserHasArrived {
            return "Both parties have arrived"
        } else if userHasArrived {
            return "You have arrived"
        } else {
            return "You have not arrived yet"
        }
    }
    
    private var canUnlockChat: Bool {
        // Simulation: Chat can be unlocked when both parties arrive
        return userHasArrived && matchedUserHasArrived
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Map view
                GoogleMapView(
                    center: restaurantLocation,
                    markers: [
                        GoogleMapMarker(coordinate: userLocation, title: "Your Location", color: .systemBlue, isRestaurant: false),
                        GoogleMapMarker(coordinate: matchedUserLocation, title: "Matched User", color: .systemPink, isRestaurant: false),
                        GoogleMapMarker(coordinate: restaurantLocation, title: restaurantName, color: .systemOrange, isRestaurant: true)
                    ],
                    onRestaurantMarkerTapped: {
                        showRestaurantInfo = true
                    }
                )
                .frame(height: 300)
                .sheet(isPresented: $showRestaurantInfo) {
                    VStack(spacing: 16) {
                        AsyncImage(url: URL(string: restaurantImageURL)) { image in
                            image.resizable().aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color.gray.opacity(0.2)
                        }
                        .frame(height: 160)
                        .clipped()
                        Text(restaurantName)
                            .font(.headline)
                        Text(restaurantAddress)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            Text(String(format: "%.1f", restaurantRating))
                                .font(.subheadline)
                        }
                        Button("Close") {
                            showRestaurantInfo = false
                        }
                        .padding(.top, 8)
                    }
                    .padding()
                }
                
                // Information area
                VStack(spacing: 20) {
                    // Meeting time
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.blue)
                        Text("Dinner Time \(meetingTime)")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    
                    // Restaurant information
                    VStack(spacing: 8) {
                        Text(restaurantName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text(restaurantAddress)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Status indicator
                    HStack {
                        Image(systemName: statusIcon)
                            .foregroundColor(statusColor)
                        Text(statusMessage)
                            .font(.subheadline)
                            .foregroundColor(statusColor)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(statusColor.opacity(0.1))
                    .cornerRadius(20)
                    
                    // Arrival button (simulation)
                    if !userHasArrived {
                        Button(action: {
                            userHasArrived = true
                            // Simulate matched user also arriving
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                matchedUserHasArrived = true
                            }
                        }) {
                            HStack {
                                Image(systemName: "location.fill")
                                Text("I have arrived at the restaurant")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                    
                    // Unlock chat button
                    if canUnlockChat {
                        Button(action: {
                            showingChat = true
                        }) {
                            HStack {
                                Image(systemName: "message.fill")
                                Text("Unlock Chat")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Meeting Wait")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingChat) {
                ChatView()
            }
        }
    }
    
    private var statusIcon: String {
        if userHasArrived && matchedUserHasArrived {
            return "checkmark.circle.fill"
        } else if userHasArrived {
            return "person.fill.checkmark"
        } else {
            return "location.circle"
        }
    }
    
    private var statusColor: Color {
        if userHasArrived && matchedUserHasArrived {
            return .green
        } else if userHasArrived {
            return .blue
        } else {
            return .orange
        }
    }
}

struct ChatView: View {
    @State private var messageText = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(id: UUID(), text: "Hello! Nice to meet you 😊", isFromUser: false, timestamp: Date()),
        ChatMessage(id: UUID(), text: "Hello! Nice to meet you too 😄", isFromUser: true, timestamp: Date())
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Chat message list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages) { message in
                            HStack {
                                if message.isFromUser {
                                    Spacer()
                                }
                                
                                VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 4) {
                                    Text(message.text)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(message.isFromUser ? Color.blue : Color.gray.opacity(0.2))
                                        .foregroundColor(message.isFromUser ? .white : .primary)
                                        .cornerRadius(16)
                                    
                                    Text(message.timestamp, style: .time)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                
                                if !message.isFromUser {
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                // Input area
                HStack {
                    TextField("Enter message...", text: $messageText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                    }
                    .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
            }
            .navigationTitle("Chat")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func sendMessage() {
        let trimmedText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        let newMessage = ChatMessage(
            id: UUID(),
            text: trimmedText,
            isFromUser: true,
            timestamp: Date()
        )
        
        messages.append(newMessage)
        messageText = ""
        
        // Simulate other party's reply
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let responses = [
                "Okay!",
                "No problem 😊",
                "Understood",
                "Thanks for sharing!",
                "That's interesting"
            ]
            let randomResponse = responses.randomElement() ?? "Okay"
            
            let replyMessage = ChatMessage(
                id: UUID(),
                text: randomResponse,
                isFromUser: false,
                timestamp: Date()
            )
            messages.append(replyMessage)
        }
    }
}

struct ChatMessage: Identifiable {
    let id: UUID
    let text: String
    let isFromUser: Bool
    let timestamp: Date
}

#Preview {
    MeetUpWaitView()
} 