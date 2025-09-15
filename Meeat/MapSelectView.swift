import SwiftUI
import GoogleMaps
import CoreLocation

struct MapSelectView: View {
    @State private var selectedCoordinate: CLLocationCoordinate2D? = nil
    @StateObject private var locationManager = LocationManager()
    @State private var mapReady = false

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                GeometryReader { geo in
                    if geo.size.width > 0 && geo.size.height > 0 {
                        GoogleMapSelector(
                            initialLocation: locationManager.lastLocation,
                            onCameraIdle: { coord in
                                selectedCoordinate = coord
                            },
                            mapReady: $mapReady
                        )
                        .frame(width: geo.size.width, height: geo.size.height)
                    }
                }
                .frame(height: 350)
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
                .frame(height: 350)
                .allowsHitTesting(false)
            }
            .onAppear {
                locationManager.requestLocation()
            }
            .padding(.bottom, 16)

            if let coord = selectedCoordinate {
                Text("Selected coordinates: \(String(format: "%.6f", coord.latitude)), \(String(format: "%.6f", coord.longitude))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 8)
            } else {
                Text("Getting location...")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)
            }

            Button(action: {
                if let coord = selectedCoordinate {
                    print("Confirmed location: \(coord.latitude), \(coord.longitude)")
                    // Here you can change to save or return coordinates
                }
            }) {
                Text("Confirm Location")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedCoordinate != nil ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(selectedCoordinate == nil)
            .padding(.horizontal)
            .padding(.top, 8)
            Spacer()
        }
        .navigationTitle("Select Location")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - GoogleMapSelector
struct GoogleMapSelector: UIViewRepresentable {
    var initialLocation: CLLocationCoordinate2D?
    var onCameraIdle: (CLLocationCoordinate2D) -> Void
    @Binding var mapReady: Bool
    var onMyLocationTapped: (() -> CLLocationCoordinate2D?)? = nil

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(
            withTarget: initialLocation ?? CLLocationCoordinate2D(latitude: 25.0330, longitude: 121.5654),
            zoom: 16
        )
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.delegate = context.coordinator
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        if !mapReady, let loc = initialLocation {
            let camera = GMSCameraPosition.camera(withTarget: loc, zoom: 16)
            mapView.animate(to: camera)
            DispatchQueue.main.async {
                mapReady = true
            }
        }
    }

    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapSelector
        init(_ parent: GoogleMapSelector) {
            self.parent = parent
        }
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            parent.onCameraIdle(position.target)
        }
        func mapView(_ mapView: GMSMapView, didTapMyLocationButtonFor mapView2: GMSMapView) -> Bool {
            if let getLocation = parent.onMyLocationTapped, let userLoc = getLocation() {
                let camera = GMSCameraPosition.camera(withTarget: userLoc, zoom: mapView.camera.zoom)
                mapView.animate(to: camera)
                // Make onCameraIdle also be triggered
                parent.onCameraIdle(userLoc)
                return true
            }
            return false
        }
    }
}

// MARK: - LocationManager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var lastLocation: CLLocationCoordinate2D? = nil
    override init() {
        super.init()
        manager.delegate = self
    }
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            DispatchQueue.main.async {
                self.lastLocation = loc.coordinate
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location failed: \(error.localizedDescription)")
    }
} 