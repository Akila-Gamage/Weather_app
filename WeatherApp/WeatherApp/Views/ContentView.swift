//
//  ContentView.swift
//  WeatherApp
//
//  Created by Akila Gamage on 2024-12-04.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        VStack {
            if viewModel.selectedTab == "weather" {
                    TabView(selection: $viewModel.selectedTab) {
                        MapView()
                            .tabItem {
                                Label("", systemImage: "map")
                            }
                            .tag("map")
                        
                        WeatherView()
                            .tabItem {
                                Label("", systemImage: "location.fill")
                            }
                            .tag("weather")
                        
                        SavedLocationView()
                            .tabItem {
                                Label("", systemImage: "list.bullet")
                            }
                            .tag("savedLocations")
                    }

            }
            else if viewModel.selectedTab == "savedLocations" {
                withAnimation(.spring(response: 1.0, dampingFraction: 0.7, blendDuration: 0.7)) {
                    SavedLocationView()
                }
                
            }
            else if viewModel.selectedTab == "map" {
                withAnimation(.spring(response: 1.0, dampingFraction: 0.7, blendDuration: 0.7)) {
                    MapView()
                }
                
            }
            
        }
        .ignoresSafeArea(.all)
    }
}


#Preview {
    @Previewable @StateObject var viewModel: ViewModel = ViewModel()
    ContentView()
        .environmentObject(viewModel)
}
