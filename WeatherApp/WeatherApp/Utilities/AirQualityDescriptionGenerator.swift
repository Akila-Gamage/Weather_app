//
//  AirQualityDescriptionGenerator.swift
//  WeatherApp
//
//  Created by Akila Gamage on 2024-12-21.
//

import Foundation

struct AirQualityUtils {
    static func getAQIDescription(for index: Int) -> String {
        switch index {
        case 1:
            return "Good: satisfactory air quality with little or no risk."
        case 2:
            return "Fair: acceptable air quality, but sensitive groups should be cautious."
        case 3:
            return "Moderate: sensitive groups may experience health effects."
        case 4:
            return "Poor: everyone may experience health effects."
        case 5:
            return "Poor: health warnings of emergency conditions."
        default:
            return "Invalid Index: Please provide an Air Quality Index between 1 and 5."
        }
    }
    
    static func getAQITitle(for index: Int) -> String {
        switch index {
        case 1:
            return "Good"
        case 2:
            return "Fair"
        case 3:
            return "Moderate"
        case 4:
            return "Poor"
        case 5:
            return "Poor"
        default:
            return "Invalid Index"
        }
    }
}
