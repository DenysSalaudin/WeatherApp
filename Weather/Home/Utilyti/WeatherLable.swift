//
//  WeatherLable.swift
//  Weather
//
//  Created by Denis on 2/14/23.
//

import SwiftUI
import CoreLocationUI

struct WeatherLable: View {
    @State private var isLocationView = false
    @State private var isFindTown = false
    let forecast: Forecast
    let city: [LocationElement]

    var body: some View {
         VStack {
             Text(city.first?.name ?? "__")
         .font(.system(size: 30,design: .rounded))
         .bold()
         .foregroundColor(Color.white)
             Text("\(forecast.current?.temp?.asCurrencyWith2Decimals() ?? "__")º")
         .font(.system(size: 60))
         .font(.headline)
         .foregroundColor(Color.white)
         .offset(x:8)
             Text(forecast.current?.weather?.first?.main ?? "")
         .font(.headline)
         .foregroundColor(Color.white)
             Text("H:\(forecast.daily?.first?.temp?.max?.asCurrencyWith2Decimals() ?? "__")º L:\(forecast.daily?.first?.temp?.min?.asCurrencyWith2Decimals() ?? "__")º")
                 .offset(x:3)
         .foregroundColor(Color.white)
         .font(.subheadline)
         .bold()
         }
              
         }
              
    }

