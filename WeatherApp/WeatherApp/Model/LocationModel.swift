//
//  LocationModel.swift
//  WeatherApp
//
//  Created by Akila Gamage on 2024-12-18.
//

import Foundation
import SwiftData
import _MapKit_SwiftUI

// MARK: - WeatherData
@Model class LocationDataModel: Identifiable {
    var id = UUID()
    var name: String
    var lat: Double
    var lon: Double
    
    init(name: String, lat: Double, lon: Double) {
        self.name = name
        self.lat = lat
        self.lon = lon
    }
}

