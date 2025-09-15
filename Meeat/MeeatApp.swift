//
//  MeeatApp.swift
//  Meeat
//
//  Created by Pak Lam Chau on 11/7/2025.
//

import SwiftUI
import GoogleMaps

@main
struct MeeatApp: App {
    init() {
        // Load Google Maps API Key from Config file
        GMSServices.provideAPIKey(Config.googleMapsAPIKey)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
