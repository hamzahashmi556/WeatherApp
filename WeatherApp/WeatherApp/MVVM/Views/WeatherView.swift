//
//  WeatherView.swift
//  AppisKeyAssignment
//
//  Created by Hamza Hashmi on 14/10/2023.
//

import SwiftUI

struct WeatherView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        
        ZStack {
            
            ScrollView {
                
                VStack(spacing: 10) {
                    
                    if let model = viewModel.model {
                        
                        
                        ForEach(0 ..< model.weather.count, id: \.self) { index in
                            VStack {
                                
                                let iconID = model.weather[index].icon
                                
                                AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(iconID)@2x.png")) { Image in
                                    
                                    Image
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 100, height: 100)
                                
                                
                                Text(model.weather[index].description)
                            }
                            .font(.largeTitle)
                        }
                        
                        let temp = "\(Int(model.main.temp))℃"
                        Text(temp)
                            .font(.largeTitle)
                        
                        HStack {
                            let min = Int(model.main.tempMin)
                            let max = Int(model.main.tempMax)
                            Text("H:\(max)°")
                            
                            Text("L:\(min)°")
                        }
                        .font(.title3)
                    }
                    
                    Spacer()
                }
            }
            .refreshable {
                self.viewModel.fetchWeather()
            }
            
            if viewModel.showLocationPermission {
                Button(action: {
                    viewModel.askPermission()
                }, label: {
                    ButtonView(title: "Enable Permission")
                })
            }
            
            if viewModel.showError {
                Text(viewModel.errorMsg)
                    .foregroundStyle(.red)
            }
            
            if viewModel.showLoader {
                Color.black.opacity(0.1).ignoresSafeArea()
                
                ProgressView()
            }
        }
    }
}

#Preview {
    WeatherView(viewModel: ViewModel())
}
