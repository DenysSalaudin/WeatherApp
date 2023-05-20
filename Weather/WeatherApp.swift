//
//  WeatherApp.swift
//  Weather
//
//  Created by Denis on 2/14/23.
//

import SwiftUI

@main
struct WeatherApp: App {
    @StateObject var locationManager = LocationManager()
    @StateObject var viewModel = ViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                CurrentPlaceWeather()
                    .environmentObject(locationManager)
            }.environmentObject(viewModel)
        }
    }
}
