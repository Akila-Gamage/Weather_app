//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Akila Gamage on 2024-12-04.
//

import SwiftUI
import SwiftData

@main
struct WeatherAppApp: App {
    @StateObject var viewModel: ViewModel = ViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
        .modelContainer(for: LocationDataModel.self)
    }
}
