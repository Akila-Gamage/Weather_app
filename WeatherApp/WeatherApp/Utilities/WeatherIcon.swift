//
//  WeatherIcon.swift
//  WeatherApp
//
//  Created by Akila Gamage on 2024-12-20.
//

import Foundation

struct WeatherIconUtils {
    static func sfSymbol(for weatherIcon: String) -> (icon: String, isMulticolor: Bool) {
        switch weatherIcon {
        case "01d": return ("sun.max.fill", true)          // Clear sky (day, multicolor)
        case "01n": return ("moon.stars.fill", true)       // Clear sky (night, multicolor)
        case "02d": return ("cloud.sun.fill", true)        // Few clouds (day, multicolor)
        case "02n": return ("cloud.moon.fill", true)       // Few clouds (night, multicolor)
        case "03d", "03n": return ("cloud.fill", false)    // Scattered clouds (monochrome)
        case "04d", "04n": return ("smoke.fill", false)    // Broken clouds (monochrome)
        case "09d", "09n": return ("cloud.drizzle.fill", true) // Shower rain (monochrome)
        case "10d": return ("cloud.sun.rain.fill", true)   // Rain (day, multicolor)
        case "10n": return ("cloud.moon.rain.fill", true)  // Rain (night, multicolor)
        case "11d": return ("cloud.sun.bolt.fill", false) // Thunderstorm (monochrome)
        case "11n": return ("cloud.moon.bolt.fill", false) // Thunderstorm (monochrome)
        case "13d", "13n": return ("snowflake", false)     // Snow (monochrome)
        case "50d", "50n": return ("cloud.fog.fill", false) // Mist (monochrome)
        default: return ("questionmark.circle.fill", false) // Default fallback (monochrome)
        }
    }
}
