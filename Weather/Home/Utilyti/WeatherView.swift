import SwiftUI
import CoreLocationUI

struct WeatherView: View {
    let daily : Daily
    var dateFormater: DateFormatter  {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "EEEE"
    return dateFormater
    }
    var day : String {
        let days = dateFormater.string(from: daily.dt)
        return days
    }
    @State private var isWeatherDetail = false
    var body: some View {
        ZStack {
            VStack(spacing:8) {
                Text(day)
                    .font(.headline)
                Image(systemName: customIcon(name: daily.weather?.first?.main ?? ""))
                    .renderingMode(.original)
                    .font(.system(size:30,design: .rounded))
                    .frame(height:35)
                RoundedRectangle(cornerRadius: 2)
                    .frame(height:1)
                    .foregroundColor(.white)
                Text("H:\(daily.temp?.max?.asCurrencyWith2Decimals() ?? "__") L:\(daily.temp?.min?.asCurrencyWith2Decimals() ?? "__")")
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                    .font(.subheadline)
                    .bold()
            }
            .foregroundColor(.white)
           .padding()
            .frame(width: 130)
        }
            .frame(height: 170)
       }
   }
         

