//
//  AirQualityDataModel.swift
//  WeatherApp
//
//  Created by Akila Gamage on 2024-12-21.
//

import Foundation

// MARK: - AirQualityData
struct AirQualityDataModel: Codable {
    let coord: Coord
    let list: [AirQualityEntry]
}
// MARK: - Coord
struct Coord: Codable {
    let lon: Double
    let lat: Double
}


// MARK: - AirQualityEntry
struct AirQualityEntry: Codable {
    let dt: Int
    let main: AirQualityMain
    let components: AirQualityComponents
}

// MARK: - AirQualityMain
struct AirQualityMain: Codable {
    let aqi: Int
}

// MARK: - AirQualityComponents
struct AirQualityComponents: Codable {
    let co: Double
    let no: Double
    let no2: Double
    let o3: Double
    let so2: Double
    let pm2_5: Double
    let pm10: Double
    let nh3: Double

    enum CodingKeys: String, CodingKey {
        case co, no, no2, o3, so2
        case pm2_5 = "pm2_5"
        case pm10, nh3
    }
}
