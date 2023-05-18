//
//  CurrentWeatherView.swift
//  Weather
//
//  Created by Denis on 3/1/23.
//
import SwiftUI
import Foundation
struct CurrentWeatherView: View {
    @State private var iconColor: Color = .white
    let forecast: Forecast
    var body: some View {
            ZStack {
                        VStack(spacing:8) {
                            Text("Today")
                                .font(.headline)
                            Image(systemName: customIcon(name: forecast.current?.weather?.first?.main ?? ""))
                                .renderingMode(.original)
                                .font(.system(size:30,design: .rounded))
                                .foregroundColor(iconColor)
                                .frame(height:35)
                            RoundedRectangle(cornerRadius: 2)
                                .frame(height: 1)
                            Text("H:\(forecast.daily?.first?.temp?.max?.asCurrencyWith2Decimals() ?? "__") L:\(forecast.daily?.first?.temp?.min?.asCurrencyWith2Decimals() ?? "__")")
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                                .font(.subheadline)
                                .bold()
                        }
                        .frame(width: 97)
                        .foregroundColor(.white)
                        .padding()
        
                
            }.frame(height: 170)
    }
}

