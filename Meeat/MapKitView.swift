import SwiftUI
import MapKit

struct MapKitView: View {
    let center: CLLocationCoordinate2D
    let markers: [MapKitMarker]
    let onMapTapped: ((CLLocationCoordinate2D) -> Void)?
    
    init(center: CLLocationCoordinate2D, markers: [MapKitMarker] = [], onMapTapped: ((CLLocationCoordinate2D) -> Void)? = nil) {
        self.center = center
        self.markers = markers
        self.onMapTapped = onMapTapped
    }
    
    var body: some View {
        Map(position: .constant(MapCameraPosition.region(MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )))) {
            ForEach(markers) { marker in
                Marker(marker.title, coordinate: marker.coordinate)
                    .tint(marker.color)
            }
        }
        .onTapGesture { location in
            // Simplified tap handling
            onMapTapped?(center)
        }
    }
}

struct MapKitMarker: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
    let color: Color
    
    init(coordinate: CLLocationCoordinate2D, title: String, color: Color = .red) {
        self.coordinate = coordinate
        self.title = title
        self.color = color
    }
}

// Extension to support color conversion
extension Color {
    var mapKitColor: UIColor {
        switch self {
        case .red: return .systemRed
        case .blue: return .systemBlue
        case .green: return .systemGreen
        case .orange: return .systemOrange
        case .pink: return .systemPink
        default: return .systemRed
        }
    }
} 