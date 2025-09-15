import SwiftUI
import GoogleMaps
import CoreLocation

struct MapSearchView: View {
    @Binding var selectedLocation: LocationPin?
    let onSetTime: () -> Void
    @StateObject private var locationManager = LocationManager()
    @State private var mapReady = false
    @State private var mapCenter: CLLocationCoordinate2D? = nil

    // Added map height calculation
    private var mapHeight: CGFloat {
        min(400, UIScreen.main.bounds.height * 0.45)
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Select Dining Location")
                .font(.headline)
                .padding(.top)
            ZStack {
                GeometryReader { geo in
                    if geo.size.width > 0 && geo.size.height > 0 {
                        GoogleMapSelector(
                            initialLocation: locationManager.lastLocation,
                            onCameraIdle: { coord in
                                mapCenter = coord
                                selectedLocation = LocationPin(coordinate: coord)
                            },
                            mapReady: $mapReady,
                            onMyLocationTapped: {
                                locationManager.lastLocation
                            }
                        )
                        .frame(width: geo.size.width, height: geo.size.height)
                    }
                }
                .frame(height: mapHeight)
                // Fixed icon, centered and does not affect map interaction
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: "mappin.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.red)
                            .shadow(radius: 4)
                            .allowsHitTesting(false)
                        Spacer()
                    }
                    Spacer()
                }
                .frame(height: mapHeight)
                .allowsHitTesting(false)
            }
            .onAppear {
                locationManager.requestLocation()
            }
            if let selected = selectedLocation {
                VStack(spacing: 8) {
                    Text("Selected Location")
                        .font(.subheadline)
                        .foregroundColor(.green)
                    Text("\(String(format: "%.4f", selected.coordinate.latitude)), \(String(format: "%.4f", selected.coordinate.longitude))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("Please drag the map to select location")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: {
                onSetTime()
            }) {
                HStack {
                    Image(systemName: "clock")
                    Text("Set Time")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(selectedLocation != nil ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(selectedLocation == nil)
        }
        .padding()
    }
}

// GoogleMapSelector please reuse the version in MapSelectView.swift and add onMyLocationTapped support 