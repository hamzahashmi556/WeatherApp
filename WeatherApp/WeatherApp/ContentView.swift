//
//  ContentView.swift
//  WeatherApp
//
//  Created by Hamza Hashmi on 19/02/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var dictionary: [String : Int] = [:]
        
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                
                NavigationLink {
                    UniqueCountView(viewModel: viewModel)
                } label: {
                    ButtonView(title: "Unique Words Counter")
                }
                
                NavigationLink {
                    WeatherView(viewModel: viewModel)
                } label: {
                    ButtonView(title: "Weather App")
                }
            }
            .padding()
        }
    }
}

struct ButtonView: View {
    
    let width = UIScreen.main.bounds.width

    @State var title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .frame(width: width - 40, height: 50)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(style: .init())
            }
            .foregroundStyle(.foreground)
    }
}

#Preview {
    ContentView()
}
