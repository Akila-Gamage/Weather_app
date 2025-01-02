//
//  SavedLocationView.swift
//  WeatherApp
//
//  Created by Akila Gamage on 2024-12-04.
//

import SwiftUI
import _SwiftData_SwiftUI
import SwipeActions
import MapKit

struct SavedLocationView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var onSearchComplete: Bool = false
    @Environment(\.modelContext) private var modelContext
    @Query var locationData: [LocationDataModel]
    @Environment(\.dismiss) var dismiss
    @State private var sort: Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text("Weather")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Image(systemName: "location.magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(width: 25, height: 25, alignment: .center)
                        ZStack(alignment: .leading) {
                            if viewModel.searchedLocation.isEmpty {
                                Text("Search for a city or airport")
                                    .foregroundColor(.gray)
                            }
                            TextField("", text: $viewModel.searchedLocation)
                                .foregroundColor(.white)
                        }

                            
                        Button("Search") {
                            Task {
                                await viewModel.fetchCoordinatesForAddress()
                                await viewModel.fetchWeatherData()
                                await viewModel.fetchAqiData()
                                if(!viewModel.isError){
                                    onSearchComplete = true
                                    viewModel.isPresentedAsSheets = true
                                }
                            }
                        }.frame(maxWidth: 60, alignment: .center)
                    }
                    .padding(5)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color("searchBg"))
                    .cornerRadius(8)
                    List{
                        if let location = viewModel.currentLocation,
                           let currentWeatherData = viewModel.findMatchingWeatherData(for: location) {
                            WeatherCard(location: "", weatherData: currentWeatherData, currentLocation: true)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                        }
                        else{
                            Text("No weather data for current location")
                                .foregroundColor(.white)
                                .padding()
                                .listRowBackground(Color.clear)
                        }
                        ForEach(locationData, id: \.id) { location in
                            if let weatherData = viewModel.findMatchingWeatherData(for: location) {
                                SwipeView {
                                    WeatherCard(location: location.name, weatherData: weatherData, currentLocation: false)
                                } trailingActions: { _ in
                                    SwipeAction(systemImage: "trash", backgroundColor: .red) {
                                        removeFromFavorite(location)
                                    }
                                    .foregroundColor(.white)
                                }
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                            } else {
                                Text("No weather data for \(location.name)")
                                    .foregroundColor(.white)
                                    .padding()
                                    .listRowBackground(Color.clear)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear.edgesIgnoringSafeArea(.all))
                }
                .padding()
                .sheet(isPresented: $onSearchComplete) {
                    WeatherView()
                }
                .onAppear {
                    viewModel.searchedLocation = ""
                }
                .alert(                     // alert to show no results
                    "No Results",
                    isPresented: $viewModel.isError
                ) {
                    HStack{
                        Button("Ok"){
                            dismiss()
                        }
                    }
                }
                message: {
                   Text("No results found for \"\(viewModel.searchedLocation)\"")
               }
            }
            .background(.black)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Section {
                            Picker(selection: $viewModel.isMetric, label: Text("")) {
                                Label("Celcius", systemImage: "degreesign.celsius")
                                    .tag(true)
                                Label("Fahrenheit", systemImage: "degreesign.fahrenheit")
                                    .tag(false)
                            }
                        }

                    }
                    label: {
                        Label("", systemImage: "ellipsis.circle")
                    }
                    .preferredColorScheme(.dark)
                    .tint(.white)
                }
            }
        }
        .onAppear {
            viewModel.onWeatherCardTap = false
            viewModel.isCurrentLocation = false
            Task {
                await viewModel.checkLocationAuthorization()
                guard let location = viewModel.currentLocation else { return }
                await viewModel.fetchWeatherDataFromLocation(location: location)
            }
            for location in locationData {
                Task {
                    await viewModel.fetchWeatherDataFromLocation(location: location)
                }
            }
        }
        .onChange(of: viewModel.isMetric) {
            viewModel.weatherDataList = []
            Task {
                guard let location = viewModel.currentLocation else { return }
                await viewModel.fetchWeatherDataFromLocation(location: location)
            }
            for location in locationData {
                Task {
                    await viewModel.fetchWeatherDataFromLocation(location: location)
                }
            }
        }
        .onChange(of: locationData) {
            Task {
                guard let location = viewModel.latestLocation else { return }
                await viewModel.fetchWeatherDataFromLocation(location: location)

            }
        }
        
    }
    
    func removeFromFavorite(_ location: LocationDataModel) {
        var locations = locationData
        if let index = locationData.firstIndex(where: { $0.id == location.id }) {
            locations.remove(at: index)
        }
        modelContext.delete(location)
        try? modelContext.save()
    }

}


#Preview {
    @Previewable @StateObject var viewModel: ViewModel = ViewModel()
    SavedLocationView()
        .environmentObject(viewModel)
}

struct WeatherCard: View {
    @EnvironmentObject var viewModel: ViewModel
    let location: String
    let weatherData: WeatherDataModel?
    let currentLocation : Bool
    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                if(currentLocation){
                    HStack {
                        Text("Current Location")
                            .foregroundStyle(.white)
                            .font(.system(size: 15, weight: .bold))
                        Image(systemName: "location")
                            .frame(width: 6, height: 6)
                            .foregroundStyle(Color.white)
                            .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 0))
                    }
                }
                else {
                    Text(location.capitalized)
                        .foregroundStyle(.white)
                        .font(.system(size: 20, weight: .bold))
                }
                Text(DateFormatterUtils.formattedDate(from: weatherData?.current.dt ?? 0, format: "hh:mm"))
                    .foregroundStyle(Color.white.opacity(0.8))
                    .font(.system(size: 16, weight: .bold))
                Spacer()
                Spacer()
                Spacer()
                Text("\(weatherData?.current.weather.first?.main.rawValue ?? "")")
                    .foregroundStyle(Color.white.opacity(0.8))
                    .font(.system(size: 16, weight: .bold))
            }
            VStack(alignment: .trailing) {
                Text("\(weatherData?.current.temp ?? 0.0, specifier: "%.0f")°")
                    .foregroundStyle(.white)
                    .font(.system(size: 45, weight: .light))
                Spacer()
                Spacer()
                Spacer()
                HStack {
                    Text("H:\(weatherData?.daily.first?.temp.max ?? 0, specifier: "%.0f")°")
                        .foregroundStyle(Color.white)
                    Text("L:\(weatherData?.daily.first?.temp.min ?? 0, specifier: "%.0f")°")
                        .foregroundStyle(Color.white)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(WeatherUtils.gradient(for: weatherData?.current.weather.first?.main.rawValue ?? "Clear"))
        .cornerRadius(20)
        .onTapGesture {
            if (currentLocation) {
                viewModel.isCurrentLocation = true
            }
            else {
                viewModel.searchedLocation = location
            }
            viewModel.weatherData = weatherData
            viewModel.cordinates = CLLocationCoordinate2D(latitude: weatherData?.lat ?? 0, longitude: weatherData?.lon ?? 0)
            withAnimation(.spring(response: 1.0, dampingFraction: 0.7, blendDuration: 0.7)) {
                viewModel.onWeatherCardTap = true
                viewModel.selectedTab = "weather"
            }

        }
    }
}



