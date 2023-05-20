//
//  CurrentPlaceWeather.swift
//  Weather
//
//  Created by Denis on 3/26/23.
//

import SwiftUI
import Foundation
import CoreLocationUI
import CoreLocation
import MapKit
import Combine

struct CurrentPlaceWeather: View {
    @State private var isLoading = false
    @State private var error: WeatherError?
    @State private var hasError = false
    @State private var isLocationView = false
    @State private var isFindTownView = false
    @State private var isRotate = false
    @State private var isHourly = false
    @State private var isChangeDay = false
    @State private var isTownWeather = false
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var locationManager : LocationManager
    @State var text = ""
    @FocusState var focus : Bool
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(viewModel.currentHourly.prefix(1),id:\.dt) { data in
                    if Int(data.temp ?? 0.0) >= 68  {
                        LinearGradient(gradient: Gradient(colors: [.orange,.yellow]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            .overlay {
                                    Color.black.opacity(focus ? 0.4:0)
                        }
                    }
                    if Int(data.temp ?? 0.0) <= 67 {
                        LinearGradient(gradient: Gradient(colors: [.blue,.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            .overlay {
                                Color.black.opacity(focus ? 0.4:0)
                        }
                    }
                    
                    if Int(data.temp ?? 0.0) >= 80 {
                        LinearGradient(gradient: Gradient(colors: [.red,.yellow]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            .overlay {
                                Color.black.opacity(focus ? 0.4:0)
                        }
                    }
                }
                .onTapGesture {
                    withAnimation {
                        focus = false
                    }
                    viewModel.cityName = ""
                }
                if hasError == false {
                    ForEach(viewModel.currentForecast,id: \.daily?.first?.dt) { forecast in
                        VStack {
                            VStack {
                                HStack {
                                    VStack {
                                        HStack {
                                            HStack {
                                                Image(systemName: "magnifyingglass")
                                                    .foregroundColor(.white)
                                                TextField("Search you city", text: $viewModel.cityName)
                                                    .focused($focus)
                                                    .autocapitalization(.words)
                                                    .onChange(of:viewModel.cityName) { _ in
                                                        Task {
                                                            await fetchLocation()
                                                        }
                                                    }
                                                }
                                            .padding(10)
                                            .background(Color.gray.opacity(0.7))
                                            .cornerRadius(35)
                                            .padding()
                                            if !focus {
                                                Button(action:{
                                                    viewModel.latCurrent = locationManager.userLatitude ?? 0.0
                                                    viewModel.lonCurrent = locationManager.userLongitude ?? 0.0
                                                    Task { await fetchWeather()
                                                }
                                                    withAnimation(.spring()){
                                                        isRotate.toggle()
                                                    }
                                                    if isRotate == true {
                                                        isRotate = false
                                                    }
                                                    print("Refresh")
                                                }){
                                                    Image(systemName:"arrow.triangle.2.circlepath")
                                                        .rotationEffect(Angle(degrees: isRotate ? 360 : 0))
                                                        .frame(width: 25,height: 25)
                                                        .padding(.trailing)
                                                }
                                            } else {
                                                Button(action:{focus = false; viewModel.cityName = ""}) {
                                                    Image(systemName:"xmark")
                                                        .frame(width: 25,height: 25)
                                                        .padding(.trailing)
                                                        .bold()
                                                }
                                            }
                                        }
                                        .offset(y:-30)
                                        .overlay {
                                                CurrentWeatheLable(forecast: forecast, city: locationManager.city)
                                                    .blur(radius: focus ? 2:0,opaque:false)
                                                    .frame(width: geometry.size.width - 40)
                                                                      .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                                                      .padding(.bottom,210)
                                        }
                                        if viewModel.cityName.count >= 2 {
                                            if !viewModel.city.isEmpty {
                                                
                                                GeometryReader { geometry2 in
                                                    VStack(alignment: .leading) {
                                                        ForEach(viewModel.city,id:\.name) { result in
                                                            NavigationLink(destination: HomeWeatherView()) {
                                                                HStack {
                                                                    VStack(alignment:.leading) {
                                                                        Text(result.name ?? "")
                                                                            .font(.headline)
                                                                        Text("\(result.country ?? ""), \(result.state ?? "")")
                                                                            .font(.caption)
                                                                    }
                                                                    Spacer()
                                                                    VStack {
                                                                        Text("Lat:\(result.lat ?? 0.0) ")
                                                                        Text("Lon:\(result.lon ?? 0.0) ")
                                                                    }.font(.caption)
                                                                }
                                                            } .simultaneousGesture(TapGesture().onEnded {
                                                                viewModel.lat = result.lat ?? 0.0
                                                                viewModel.lon = result.lon ?? 0.0
                                                            })
                                                            .padding()
                                                        }
                                                    }
                                                    .background(Color.gray.opacity(0.4))
                                                    .cornerRadius(15)
                                                    .padding(.trailing,48)
                                                    .padding()
                                                    .offset(y:-65)
                                                    .animation(.easeInOut(duration: 0.3), value: focus)
                                                }
                                            } else {
                                                  Text("No found result by ''\(viewModel.cityName)''")
                                                    .font(.headline)
                                                    .padding(.trailing,48)
                                                    .offset(y:-35)
                                              }
                                        }
                                    }
                                }
                                    .padding(.horizontal,6)
                                    .padding(.top, geometry.safeAreaInsets.top)
                                    .foregroundColor(.white)
                                
                                    Spacer()
                                    Spacer()
                                    
                                    ScrollView(.horizontal,showsIndicators: false) {
                                        HStack {
                                            CurrentWeatherView(forecast: forecast)
                                            ForEach(forecast.daily?.dropFirst() ?? [],id: \.dt) { daily in
                                                WeatherView(daily: daily)
                                            }
                                        }
                                        .blur(radius: focus ? 2:0,opaque:false)
                                        .background(Color.gray.opacity(0.5))
                                        .cornerRadius(16)
                                        .padding()
                                        .padding(.bottom,10)
                                        .onTapGesture {
                                            isHourly.toggle()
                                        }
                                    }
                                }
                            }
                            .sheet(isPresented: $isHourly) {
                                ZStack {
                                    ForEach(viewModel.currentHourly.prefix(1),id:\.dt) { data in
                                        if Int(data.temp ?? 0.0) >= 68  {
                                            LinearGradient(gradient: Gradient(colors: [.orange,.yellow]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                        }
                                        if Int(data.temp ?? 0.0) <= 67 {
                                            LinearGradient(gradient: Gradient(colors: [.blue,.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                        }
                                        if Int(data.temp ?? 0.0) >= 80 {
                                            LinearGradient(gradient: Gradient(colors: [.red,.yellow]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                        }
                                    }
                                    VStack {
                                        HStack {
                                            Text(isChangeDay ? /*"Back to first 24 hour*/  "first 24 hour" : "Next 24 hour")
                                            Spacer()
                                            Image(systemName:"chevron.right")
                                                .foregroundColor(.white)
                                            .rotationEffect(Angle(degrees: isChangeDay ? 180 : 0))}
                                        .padding(.horizontal)
                                        .padding()
                                        .background(Color.gray.opacity(0.5))
                                        .cornerRadius(12)
                                        .padding(.horizontal)
                                        .padding(.top)
                                        .shadow(radius: 1)
                                        .onTapGesture {
                                            withAnimation(.spring()) {
                                                isChangeDay.toggle()
                                            }
                                        }
                                        if !isChangeDay {
                                            ScrollView {
                                                VStack {
                                                    ForEach(viewModel.currentHourly.dropLast(24),id: \.dt) { hourly in
                                                        HourlyView(hourly: hourly)
                                                    }
                                                }
                                                .padding(.top)
                                                .background(Color.gray.opacity(0.4))
                                                .cornerRadius(15)
                                                .padding()
                                                .shadow(radius: 3)
                                              
                                            }.transition(.move(edge: .leading))
                                        }
                                        if isChangeDay  {
                                            ScrollView {
                                                VStack {
                                                    ForEach(viewModel.currentHourly.dropFirst(24),id: \.dt) { hourly in
                                                        HourlyView(hourly: hourly)
                                                    }
                                                }
                                                .padding(.top)
                                                .background(Color.gray.opacity(0.4))
                                                .cornerRadius(15)
                                                .padding()
                                                .shadow(radius: 3)
                                            }.transition(.move(edge: .trailing))
                                        }
                                    }
                                }.ignoresSafeArea()
                            }
                            .padding(.top)
                        }
                    } else {
                        ProgressView()
                            .scaleEffect(2.5)
                        }
                if hasError == true {
                    ZStack{
                        LinearGradient(gradient: Gradient(colors: [.blue,.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        VStack {
                            Text("Something went wrong")
                                .font(.headline)
                            Button(action:{ Task {
                                await fetchWeather()
                            }
                                print("Refresh")
                                withAnimation(.spring()){
                                    isRotate.toggle()
                                }
                                if isRotate == true {
                                    isRotate = false
                                }
                            }){
                                HStack {
                                    Text("Try again")
                                    Image(systemName:"arrow.triangle.2.circlepath")
                                        .rotationEffect(Angle(degrees: isRotate ? 360 : 0))
                                        .frame(width: 35,height: 35)
                            }.foregroundColor(.white)}
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .task {
                viewModel.latCurrent = locationManager.userLatitude ?? 0.0
                viewModel.lonCurrent = locationManager.userLongitude ?? 0.0
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                    Task {
                        await fetchWeather()
                    }
                }
            }
        }.ignoresSafeArea(.keyboard)
    }
}
 
extension CurrentPlaceWeather {
   func fetchWeather() async {
       isLoading = true
        do {
            try await viewModel.fetchWeatherCurrent()
        } catch {
            self.error = error as? WeatherError ?? .unexpectedError(error: error)
            self.hasError = true
        }
        isLoading = false
    }

    func fetchLocation() async {
         isLoading = true
         do {
                 try await viewModel.fetchLocation()
         } catch {
             self.error = error as? WeatherError ?? .unexpectedError(error: error)
             self.hasError = true
         }
         isLoading = false
     }
}


