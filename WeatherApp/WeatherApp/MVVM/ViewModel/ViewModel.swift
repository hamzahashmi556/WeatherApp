//
//  ViewModel.swift
//  AppisKeyAssignment
//
//  Created by Hamza Hashmi on 14/10/2023.
//

import Foundation
import CoreLocation

class ViewModel: NSObject, ObservableObject {
    
    @Published var dictionary: [String : Int] = [:]
    
    @Published var lat = 0.0
    @Published var long = 0.0
    
    @Published var showLocationPermission = false
    
    @Published var showLoader = false
    
    @Published var showError = false
    @Published var errorMsg = ""
    @Published var model: Model? = nil
    
    
    private let locationManager = CLLocationManager()
    
    let apiKey = "c487629e00a887cbc69e6f38bc21e642"
    
    override init() {
        super.init()
        self.setupLocationManager()
//        self.fetchWeather()
    }
    
    func setupLocationManager() {
        switch locationManager.authorizationStatus {
            
        case .notDetermined, .denied, .restricted:
            self.showLocationPermission = true
            
        case .authorizedAlways, .authorizedWhenInUse:
            self.showLocationPermission = false
            
        default:
            break
        }
        
        locationManager.delegate = self
    }
    
    func askPermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func fetchWeather() {
        
        self.showLoader = true
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?&lat=\(lat)&lon=\(long)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                
                self.showLoader = false
                
                if let error = error {
                    self.showError(error: error)
                }
                else if let data = data {
                    do {
                        let model = try JSONDecoder().decode(Model.self, from: data)
                        self.model = model
                    }
                    catch {
                        self.showError(error: error)
                    }
                }
            }
        }.resume()
        

//        let urlString = "https://api.openweathermap.org/data/3.0/onecall?lat=\(self.lat)&lon=\(self.long)&exclude={part}&appid=\(apiKey)"
    }
    
    func addElement(input: String) {
        
        self.dictionary = [:]
        
        let wordList = input
            .lowercased()
            .replacingOccurrences(of: "[^a-z ]", with: "", options: .regularExpression)
            .split(separator: " ")
        
        for word in wordList {
            
            let input = String(word)
            
            if self.dictionary[input] != nil {
                self.dictionary[input]? += 1
            }
            else {
                self.dictionary[input] = 1
            }
        }
    }
    
    @MainActor 
    func showError(error: Error) {
        self.showError = true
        self.errorMsg = error.localizedDescription
    }
}
extension ViewModel: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let location = manager.location else {
            return
        }
        
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            self.showLocationPermission = false
            
        default:
            self.showLocationPermission = true
        }
        
        self.lat = location.coordinate.latitude
        self.long = location.coordinate.longitude
        self.fetchWeather()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }

        self.lat = location.coordinate.latitude
        self.long = location.coordinate.longitude
        self.fetchWeather()
    }
}
