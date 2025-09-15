import Foundation
import CoreLocation

struct LocationPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct Candidate: Identifiable {
    let id = UUID()
    let name: String
    let age: Int
    let jobTitle: String
    let mbtiType: String
    let quote: String
    let interests: [String]
    let foodPreferences: [String]
    let imageName: String
} 