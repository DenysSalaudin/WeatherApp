//
//  HomeWeatherView.swift
//  Weather
//
//  Created by Denis on 2/14/23.
//


import SwiftUI
import Foundation
import CoreLocationUI
import CoreLocation

struct HomeWeatherView: View {
    @State private var isLoading = false
    @State private var error: WeatherError?
    @State private var hasError = false
    @State private var isLocationView = false
    @State private var isFindTownView = false
    @State private var isRotate = false
    @State private var isHourly = false
    @State private var isChangeDay = false
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    ForEach(viewModel.hourly.prefix(1),id:\.dt) { data in
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
                        if hasError == false {
                            ForEach(viewModel.forecast,id: \.daily?.first?.dt) { forecast in
                                VStack {
                                    HStack {
                                        Image(systemName: "chevron.left")
                                            .scaleEffect(1.5)
                                            .onTapGesture {
                                                presentationMode.wrappedValue.dismiss()
                                            }
                                            .padding(.leading)
                                        
                                        Spacer()
                                        Button(action:{ Task {
                                            await fetchWeather()
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
                                    }
                                    .padding(.horizontal,6)
                                    .padding(.top, geometry.safeAreaInsets.top)
                                    .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    WeatherLable(forecast: forecast, city: viewModel.city)
                                    
                                    Spacer()
                                    
                                    ScrollView(.horizontal,showsIndicators: false) {
                                        HStack {
                                            CurrentWeatherView(forecast: forecast)
                                            ForEach(forecast.daily?.dropFirst() ?? [],id: \.dt) { daily in
                                                WeatherView(daily: daily)
                                            }
                                        }
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
                                    ForEach(viewModel.hourly.prefix(1),id:\.dt) { data in
                                        
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
                                            Text(isChangeDay ? "first 24 hour" : "Next 24 hour")
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
                                                    ForEach(viewModel.hourly.dropLast(24),id: \.dt) { hourly in
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
                                                    ForEach(viewModel.hourly.dropFirst(24),id: \.dt) { hourly in
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
                    await fetchWeather()
                }
                .onDisappear {
                    viewModel.cityName = ""
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}

extension HomeWeatherView {
   func fetchWeather() async {
       isLoading = true
        do {
            try await viewModel.fetchWeather()
        } catch {
            self.error = error as? WeatherError ?? .unexpectedError(error: error)
            self.hasError = true
            
        }
        isLoading = false
    }
}
