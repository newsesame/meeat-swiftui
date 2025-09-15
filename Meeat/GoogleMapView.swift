import SwiftUI
import GoogleMaps

struct GoogleMapMarker: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
    let color: UIColor
    let isRestaurant: Bool
}

struct GoogleMapView: UIViewRepresentable {
    var center: CLLocationCoordinate2D
    var markers: [GoogleMapMarker]
    var onRestaurantMarkerTapped: (() -> Void)?
    var onMapTapped: ((CLLocationCoordinate2D) -> Void)? = nil

    static func configureGoogleMaps() {
        // Load Google Maps API Key from Config file
        GMSServices.provideAPIKey(Config.googleMapsAPIKey)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withTarget: center, zoom: 16)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.delegate = context.coordinator
        mapView.isMyLocationEnabled = true
        updateMarkers(mapView)
        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        mapView.clear()
        let camera = GMSCameraPosition.camera(withTarget: center, zoom: 16)
        mapView.camera = camera
        updateMarkers(mapView)
    }

    private func updateMarkers(_ mapView: GMSMapView) {
        for markerData in markers {
            let marker = GMSMarker(position: markerData.coordinate)
            marker.title = markerData.title
            marker.icon = GMSMarker.markerImage(with: markerData.color)
            marker.userData = markerData.isRestaurant ? "restaurant" : nil
            marker.map = mapView
        }
    }

    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapView
        init(_ parent: GoogleMapView) {
            self.parent = parent
        }
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            if let type = marker.userData as? String, type == "restaurant" {
                parent.onRestaurantMarkerTapped?()
                return true
            }
            return false
        }
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            parent.onMapTapped?(coordinate)
        }
    }
} 