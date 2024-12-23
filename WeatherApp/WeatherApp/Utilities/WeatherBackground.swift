//
//  WeatherBackground.swift
//  WeatherApp
//
//  Created by Akila Gamage on 2024-12-21.
//

import Foundation
import SwiftUI

struct WeatherBackgroundUtils {
    static func gradient(for weather: String) -> LinearGradient {
        switch weather {
        case "Clear":
            return LinearGradient(
                colors: [
                    Color(red: 0.23, green: 0.33, blue: 0.52),
                    Color(red: 0.70, green: 0.53, blue: 0.58)
                ],
                startPoint: .top, endPoint: .bottom
            )
        case "Clouds":
            return LinearGradient(
                colors: [
                    Color(red: 0.45, green: 0.55, blue: 0.55),
                    Color(red: 0.80, green: 0.80, blue: 0.80)
                ],
                startPoint: .top, endPoint: .bottom
            )
        case "Rain", "Drizzle", "Thunderstorm":
            return LinearGradient(
                colors: [
                    Color(red: 0.23, green: 0.33, blue: 0.52),
                    Color(red: 0.50, green: 0.50, blue: 0.50)
                ],
                startPoint: .top, endPoint: .bottom
            )
        case "Snow":
            return LinearGradient(
                colors: [
                    Color(red: 0.94, green: 0.94, blue: 0.94),
                    Color(red: 0.70, green: 0.80, blue: 0.90)
                ],
                startPoint: .top, endPoint: .bottom
            )
        case "Mist", "Fog", "Haze":
            return LinearGradient(
                colors: [
                    Color(red: 0.80, green: 0.80, blue: 0.80),
                    Color(red: 0.60, green: 0.60, blue: 0.60)
                ],
                startPoint: .top, endPoint: .bottom
            )
        case "Smoke", "Dust", "Sand", "Ash":
            return LinearGradient(
                colors: [
                    Color(red: 0.53, green: 0.44, blue: 0.28),
                    Color(red: 0.70, green: 0.60, blue: 0.50)
                ],
                startPoint: .top, endPoint: .bottom
            )
        case "Squall", "Tornado":
            return LinearGradient(
                colors: [
                    Color(red: 0.20, green: 0.20, blue: 0.20),
                    Color(red: 0.10, green: 0.10, blue: 0.10)
                ],
                startPoint: .top, endPoint: .bottom
            )
        default:
            return LinearGradient(
                colors: [
                    Color(red: 0.23, green: 0.33, blue: 0.52),
                    Color(red: 0.70, green: 0.53, blue: 0.58)  
                ],
                startPoint: .top, endPoint: .bottom
            )
        }
    }
}
