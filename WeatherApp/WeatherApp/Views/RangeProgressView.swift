//
//  RangeProgressView.swift
//  WeatherApp
//
//  Created by Akila Gamage on 2024-12-21.
//

import SwiftUI

struct TempRangeProgressView: ProgressViewStyle {
    let range: ClosedRange<Double>
    let minTemp: Double
    let maxTemp: Double
    
    var foregroundColor: AnyShapeStyle {
        if maxTemp >= 15 {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [.yellow, .red],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
        } else {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [.lightBlue, .green],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        return GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.secondary)
                    .frame(width: proxy.size.width)

                Capsule()
                    .fill(foregroundColor)
                    .frame(width: proxy.size.width * normalizedDailyRangeScale)
                    .offset(x: proxy.size.width * normalizedDailyMinOffset)
            }
        }
    }

    var normalizedDailyRangeScale: CGFloat {
        let normalizedRange = range.upperBound - range.lowerBound
        guard normalizedRange > 0 else { return 0 }
        let clampedMaxTemp = max(range.lowerBound, min(maxTemp, range.upperBound))
        let clampedMinTemp = max(range.lowerBound, min(minTemp, range.upperBound))
        return CGFloat((clampedMaxTemp - clampedMinTemp) / normalizedRange)
    }

    var normalizedDailyMinOffset: CGFloat {
        let normalizedRange = range.upperBound - range.lowerBound
        guard normalizedRange > 0 else { return 0 }
        let clampedMinTemp = max(range.lowerBound, min(minTemp, range.upperBound))
        return CGFloat((clampedMinTemp - range.lowerBound) / normalizedRange)
    }
}

struct AqiRangeProgressView: ProgressViewStyle {
    let range: ClosedRange<Double>
    let customValue: Int

    func makeBody(configuration: Configuration) -> some View {
        return GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(AnyShapeStyle(
                        LinearGradient(colors: [.green, .yellow, .orange, .red, .purple],
                                       startPoint: .leading,
                                       endPoint: .trailing)
                    ))
                    .frame(width: proxy.size.width)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 10, height: 10)
                    .position(x: proxy.size.width * normalizedCustomValue, y: proxy.size.height / 2)
            }
        }
    }

    // Normalize the custom value within the range
    var normalizedCustomValue: CGFloat {
        let normalizedRange = range.upperBound - range.lowerBound
        guard normalizedRange > 0 else { return 0 }
        let clampedValue = max(range.lowerBound, min(Double(customValue), range.upperBound))
        return CGFloat((clampedValue - range.lowerBound) / normalizedRange)
    }

}

