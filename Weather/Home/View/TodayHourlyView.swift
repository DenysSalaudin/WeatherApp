//
//  TodayHourlyView.swift
//  Weather
//
//  Created by Denis on 3/18/23.
//

import SwiftUI

struct HourlyView: View {
    let hourly : Current
    var body: some View {
        VStack {
                VStack(spacing: 4) {
                    HStack {
                        Text("\(dateFormaterHours(date:hourly.dt)):\(dateFormaterMinutes(date:hourly.dt)) \(dateFormaterAmPm(date:hourly.dt))")
                            .font(.headline)
                        Image(systemName: customIcon(name: hourly.weather?.first?.main ?? ""))
                            .renderingMode(.original)
                            .font(.headline)
                        Text(hourly.weather?.first?.main ?? "")
                            .font(.headline)
                        
                        Text("Temp: \(hourly.temp?.asCurrencyWith2Decimals() ?? "__")º")
                            .font(.headline)
                    }
                    .scaleEffect(1.2)
                    HStack {
                        Text("Humidity: \(hourly.humidity ?? 0)%")
                            .font(.headline)
                            .frame(width:125)
                        
                        Text("Presure: \(hourly.pressure ?? 0)")
                            .font(.headline)
                            .frame(width:125)
                    }
                    .scaleEffect(1.1)
                    HStack {
                        Text("Feels Like: \(hourly.feelsLike?.asCurrencyWith2Decimals() ?? "__")º")
                            .font(.headline)
                            .frame(width:120)
                        Text("Wind: \(hourly.windSpeed?.asCurrencyWith2Decimals() ?? "__") mhp")
                            .font(.headline)
                            .frame(width:120)
                    }
                    .scaleEffect(1.1)
                    HStack {
                        Text(hourly.weather?.first?.main ?? "")
                        Image(systemName: customIcon(name: hourly.weather?.first?.main ?? ""))
                            .renderingMode(.original)
                    }.font(.headline)
                        .scaleEffect(1)
                    RoundedRectangle(cornerRadius: 1)
                        .frame(height:1)
                        .padding()
            }
        }
    }
}
