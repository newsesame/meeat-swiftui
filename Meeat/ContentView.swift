//
//  ContentView.swift
//  Meeat
//
//  Created by Pak Lam Chau on 11/7/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var userInRequest: Bool = false
    // Onboarding state
    @State private var selectedLocation: LocationPin? = nil
    @State private var startTime = Date()
    @State private var endTime = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    
    var body: some View {
        if !userInRequest {
            // Onboarding Flow
            OnboardingFlowView(
                selectedLocation: $selectedLocation,
                startTime: $startTime,
                endTime: $endTime,
                onComplete: {
                    userInRequest = true
                }
            )
        } else {
            MainTabView()
        }
    }
}

// Onboarding Flow
struct OnboardingFlowView: View {
    @Binding var selectedLocation: LocationPin?
    @Binding var startTime: Date
    @Binding var endTime: Date
    var onComplete: () -> Void
    @State private var step: Int = 0
    var body: some View {
        switch step {
        case 0:
            MapSearchView(selectedLocation: $selectedLocation) {
                step = 1
            }
        case 1:
            TimeSelectorView(startTime: $startTime, endTime: $endTime) {
                onComplete()
            }
        default:
            EmptyView()
        }
    }
}

#Preview {
    ContentView()
}
