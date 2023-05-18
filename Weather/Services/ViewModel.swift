


import Foundation
import SwiftUI
import CoreLocationUI
import CoreLocation
@MainActor
final class ViewModel: ObservableObject {
    @Published var forecast : [Forecast] = []
    @Published var hourly: [Current] = []
    @Published var city : [LocationElement] = []
    @Published var cityName: String = ""
    @Published var lat: Double = 0.0
    @Published var lon: Double = 0.0
    @Published var currentForecast : [Forecast] = []
    @Published var currentHourly: [Current] = []
    @Published var latCurrent: Double = 0.0
    @Published var lonCurrent: Double = 0.0
    @Published var cityCurrent: String = ""
    var fake: String {
        if cityName.isEmpty {
            return "IIIIIIIIIIIIII"
        } else {
            return ""
        }
    }
    // Fetch current plase weather
   func fetchWeatherCurrent() async throws {
       do {
           let feedURL = URL(string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(latCurrent)&lon=\(lonCurrent)&exclude=minutely&appid=488d74ec4b354fe05db6ae9caf4f5347&units=imperial")!
               let (data,_) = try await URLSession.shared.data(from: feedURL)
               let allData = try JSONDecoder().decode(Forecast.self, from: data)
               self.currentForecast = [allData]
               self.currentHourly = allData.hourly ?? []
       } catch {
           throw WeatherError.networkError
       }
   }
    // Fetch Search plase weather
    func fetchWeather() async throws {
        do {
            let feedURL = URL(string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely&appid=488d74ec4b354fe05db6ae9caf4f5347&units=imperial")!
            let (data,_) = try await URLSession.shared.data(from: feedURL)
            let allData = try JSONDecoder().decode(Forecast.self, from: data)
            self.forecast = [allData]
            self.hourly = allData.hourly ?? []
        } catch {
            throw WeatherError.networkError
        }
    }
    //Fetch location data
    func fetchLocation() async throws {
        guard let feedURL = URL(string: "http://api.openweathermap.org/geo/1.0/direct?q=\(fake)\(cityName)&limit=10&appid=488d74ec4b354fe05db6ae9caf4f5347") else { return }
        do {
            let (data,_) = try await URLSession.shared.data(from: feedURL)
               let allData = try JSONDecoder().decode([LocationElement].self, from: data)
            self.city = allData
        } catch {
            print("bad Data")
            throw WeatherError.networkError
        }
    }
}

func customIcon(name:String) -> String {
    if name == "Clear" {
        return "sun.max.fill"
    }
    if name == "Rain" {
       return "cloud.rain.fill"
    }
    if name == "Clouds" {
        return "smoke.fill"
    }
    if name == "Snow" {
        return "cloud.snow.fill"
    }
    if name == "Mist" {
        return "smoke.fill"
    }
    if name == "Smoke" {
        return "smoke.fill"
    }
    else { return "questionmark" }
}

func dateFormaterHours(date:Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "H"
        let days = dateFormater.string(from: date)
    return days
}

func dateFormaterMinutes(date:Date) -> String{
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "mm"
    let days = dateFormater.string(from: date)
return days
}

func dateFormaterAmPm(date:Date) -> String{
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "a"
    let days = dateFormater.string(from: date)
return days
}
