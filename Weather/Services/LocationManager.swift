//
//  LocationManager.swift
//  Weather
//
//  Created by Denis on 3/19/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject,ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    @Published var userLatitude: Double?
    @Published var userLongitude: Double?
    @Published var city: String?
    @Published var isLoading = false
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
}
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.userLatitude = location.coordinate.latitude
            self.userLongitude = location.coordinate.longitude
            self.isLoading = true
            let geoCoder = CLGeocoder()
                    geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
                        self.isLoading = false
                        if let error = error {
                            print("Reverse geocoding failed with error: \(error.localizedDescription)")
                            return
                        }
                        
                        guard let placemark = placemarks?.first else { return }
                        
                        if let city = placemark.locality {
                            self.city = city
                        } else if let adminArea = placemark.administrativeArea {
                            self.city = adminArea
                        } else {
                            self.city = "Unknown"
                        }
                    }
        }
        
    }
}





