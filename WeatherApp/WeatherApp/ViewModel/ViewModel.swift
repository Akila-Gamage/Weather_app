//
//  ViewModel.swift
//  WeatherApp
//
//  Created by Akila Gamage on 2024-12-19.
//

import Foundation
import CoreLocation
import SwiftUICore

class ViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var selectedTab: String = "weather"
    @Published var isPresentedAsSheets: Bool = false
    @Published var onWeatherCardTap: Bool = false
    @Published var cordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @Published var weatherData : WeatherDataModel?
    @Published var airQualityData: AirQualityDataModel?
    @Published var weatherDataList: [WeatherDataModel] = []
    @Published var latestLocation: LocationDataModel?
    @Published var currentLocation: LocationDataModel?
    @Published var isError: Bool = false
    @Published var isCurrentLocation: Bool = true
    @Published var isMetric: Bool = true
    @Published var searchedLocation: String = ""

    let geocoder = CLGeocoder()
    let locationManager = CLLocationManager()
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    
    func fetchCoordinatesForAddress() async {
        await withCheckedContinuation { continuation in
            geocoder.geocodeAddressString(searchedLocation) { placemarks, error in
                if let error = error {
                    self.isError = true
                    print("Error: \(error.localizedDescription)")
                    continuation.resume()
                } else if let coordinates = placemarks?.first?.location?.coordinate {
                    self.cordinates = coordinates
                    print("Latitude: \(coordinates.latitude), Longitude: \(coordinates.longitude)")
                    continuation.resume()
                } else {
                    print("No coordinates found.")
                    continuation.resume()
                }
            }
        }
    }
    
    func fetchWeatherData() async {
        let unitsParameter = isMetric ? "&units=metric" : "&units=imperial"
        let url = URL(string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(cordinates.latitude)&lon=\(cordinates.longitude)&appid=c66f630c5833baf90030fbb2d82ead00\(unitsParameter)")
        
        guard let unwrapperUrl = url else {
            print("Invalid URL")
            return
        }
        
        do{
            let (data, response) = try await URLSession.shared.data(from: unwrapperUrl)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            switch httpResponse.statusCode {
            case 200...300:
                // Decode the data
                let decodedData = try JSONDecoder().decode(WeatherDataModel.self, from: data)
                
                // Ensure UI updates happen on the main thread
                DispatchQueue.main.async {
                    self.weatherData = decodedData
//                    if let weatherData = self.weatherData {
//                    print(decodedData)
//                    } else {
//                        print("Weather data is nil.")
//                    }
                }
                //                isLoading = false
            case 400:
                print("Server is not responding")
            case 500:
                print("Server is under maintenance")
            default:
                print("Something went wrong")
            }
            
        } catch {
            print("something went wrong \(error.localizedDescription)")
        }
    }
    
    func fetchWeatherDataFromLocation(location: LocationDataModel) async {
        let unitsParameter = isMetric ? "&units=metric" : "&units=imperial"
        let url = URL(string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(location.lat)&lon=\(location.lon)&appid=c66f630c5833baf90030fbb2d82ead00\(unitsParameter)")
        
        guard let unwrapperUrl = url else {
            print("Invalid URL")
            return
        }
        
        do{
            let (data, response) = try await URLSession.shared.data(from: unwrapperUrl)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            switch httpResponse.statusCode {
            case 200...300:
                // Decode the data
                let decodedData = try JSONDecoder().decode(WeatherDataModel.self, from: data)
                
                // Ensure UI updates happen on the main thread
                DispatchQueue.main.async {
                    self.weatherDataList.append(decodedData)
//                    print(self.weatherDataList.first?.current.dt)
//                    if let weatherData = self.weatherData {
//                        print(weatherData)
//                    } else {
//                        print("Weather data is nil.")
//                    }
                }
                //                isLoading = false
            case 400:
                print("Server is not responding")
            case 500:
                print("Server is under maintenance")
            default:
                print("Something went wrong")
            }
            
        } catch {
            print("something went wrong \(error.localizedDescription)")
        }
    }
    
    func fetchAqiData() async {
        let url = URL(string: "http://api.openweathermap.org/data/2.5/air_pollution?lat=\(cordinates.latitude)&lon=\(cordinates.longitude)&appid=2a289e7b2a5da9778059e602a8863702")
        
        guard let unwrapperUrl = url else {
            print("Invalid URL")
            return
        }
        
        do{
            let (data, response) = try await URLSession.shared.data(from: unwrapperUrl)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            switch httpResponse.statusCode {
            case 200...300:
                // Decode the data
                let decodedData = try JSONDecoder().decode(AirQualityDataModel.self, from: data)
                
                DispatchQueue.main.async {
                    self.airQualityData = decodedData
                    if let airQualityData = self.airQualityData {
                        print(airQualityData)
                    } else {
                        print("Weather data is nil.")
                    }
                }
                //                isLoading = false
            case 400:
                print("Server is not responding")
            case 500:
                print("Server is under maintenance")
            default:
                print("Something went wrong")
            }
            
        } catch {
            print("something went wrong \(error.localizedDescription)")
        }
    }
    
    func findMatchingWeatherData(for location: LocationDataModel) -> WeatherDataModel? {
        let locationLattitude = (location.lat * 10000).rounded() / 10000
        let locationLongitude = (location.lon * 10000).rounded() / 10000
        return weatherDataList.first(where: { $0.lat == locationLattitude && $0.lon == locationLongitude })
    }

    func checkLocationAuthorization() async {
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        switch locationManager.authorizationStatus {
        case .notDetermined://The user choose allow or denny your app to get the location yet
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted://The user cannot change this app’s status, possibly due to active restrictions such as parental controls being in place.
            print("Location restricted")
            
        case .denied://The user dennied your app to get location or disabled the services location or the phone is in airplane mode
            print("Location denied")
            
        case .authorizedAlways://This authorization allows you to use all location services and receive location events whether or not your app is in use.
            print("Location authorizedAlways")
            
        case .authorizedWhenInUse://This authorization allows you to use all location         // Location access is allowed only when the app is in use
            print("Location authorized when in use")
            if let location = locationManager.location?.coordinate {
                DispatchQueue.main.async {
                    self.lastKnownLocation = location
                    self.cordinates = location
                    self.currentLocation = LocationDataModel(
                        name: "current location",
                        lat: location.latitude,
                        lon: location.longitude
                    )
                }
            }
            
        @unknown default:
            print("Location service disabled")
        
        }
    }
    
    private func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) async {
        await checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])  {
        lastKnownLocation = locations.first?.coordinate
    }
    
    func convertToMapAnnotation(location: LocationDataModel) -> Place {
        return Place(
            name: location.name,
            coordinate: CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)
        )
    }

}
