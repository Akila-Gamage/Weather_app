//
//  AirPolutionView.swift
//  WeatherApp
//
//  Created by Akila Gamage on 2024-12-21.
//

import SwiftUI

struct AirPolutionView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            ZStack {
                VStack{
                    ScrollView(showsIndicators: false) {
                        let aqi = viewModel.airQualityData?.list.first?.main.aqi ?? 0
                        let description = AirQualityUtils.getAQIDescription(for: aqi)
                        let title = AirQualityUtils.getAQITitle(for: aqi)
                        Text("Low")
                            .foregroundStyle(.white)
                            .font(.system(size: 20, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Scale: United Kingdom (DAQI)")
                            .foregroundStyle(.gray)
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        VStack {
                            Text("Air quality index is \(aqi). which is \(description)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            ProgressView(value: 0)
                                .frame(maxWidth: .infinity, maxHeight: 4)
                                .progressViewStyle(AqiRangeProgressView(range: 1...5.0, customValue: aqi))
                        }
                        .padding(20)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        Text("Pollutant Details")
                            .foregroundStyle(.white)
                            .font(.system(size: 20, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(EdgeInsets(top: 15, leading: 0, bottom: 10, trailing: 0))
                        VStack (alignment: .leading){
                            if let aqiData = viewModel.airQualityData?.list.first?.components {
                                PolutantDetailRow(components: aqiData)
                            } else {
                                Text("No data available")
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding(20)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        Text("Air Quality data provided by OpenWeatherMap")
                            .foregroundStyle(.gray)
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 0))
                    }
                    Spacer()
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "aqi.low")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(Color.white)
                        
                        Text("Air Pollution")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "xmark.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.gray)
                    .onTapGesture {
                        dismiss()
                    }
                }
            }
            .padding()
            .background(.black)
        }
    }
}

struct PolutantDetailRow: View {
    let components: AirQualityComponents
    
    var body: some View {
        HStack{
            Text("CO")
                .foregroundStyle(.gray)
                .font(.system(size: 14))
                .frame(width: 40, alignment: .leading)
            Spacer()
            Text("Carbon Monoxide")
                .foregroundStyle(.white)
                .font(.system(size: 14))
                .frame(width: 180, alignment: .leading)
                .bold()
            Spacer()
            HStack {
                Text("\(components.co, specifier: "%.0f") μg/m")
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
                + Text("3")
                    .font(.system(size: 8))
                    .baselineOffset(-6)
                    .foregroundStyle(.gray)
            }.frame(width: 80, alignment: .trailing)
        }
        Divider().background(Color.gray)
        HStack{
            HStack {
                Text("NO")
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
                + Text("2")
                    .font(.system(size: 8))
                    .baselineOffset(-6)
                    .foregroundStyle(.gray)
            }
            .frame(width: 40, alignment: .leading)
            Spacer()
            Text("Nitrogen Dioxide")
                .foregroundStyle(.white)
                .font(.system(size: 14))
                .frame(width: 180, alignment: .leading)
                .bold()
            Spacer()
            HStack {
                Text("\(components.no2, specifier: "%.0f") μg/m")
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
                + Text("3")
                    .font(.system(size: 8))
                    .baselineOffset(-6)
                    .foregroundStyle(.gray)
            }.frame(width: 77, alignment: .trailing)
        }
        Divider().background(Color.gray)
        HStack{
            HStack {
                Text("NO")
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
                + Text("x")
                    .font(.system(size: 10))
                    .baselineOffset(-6)
                    .foregroundStyle(.gray)
            }
            .frame(width: 40, alignment: .leading)
            Spacer()
            Text("Nitrogen Oxides")
                .foregroundStyle(.white)
                .font(.system(size: 14))
                .frame(width: 180, alignment: .leading)
                .bold()
            Spacer()
            HStack {
                Text("\(components.no, specifier: "%.0f") μg/m")
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
                + Text("3")
                    .font(.system(size: 8))
                    .baselineOffset(-6)
                    .foregroundStyle(.gray)
            }.frame(width: 77, alignment: .trailing)
        }
        Divider().background(Color.gray)
        HStack{
            HStack {
                Text("O")
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
                + Text("3")
                    .font(.system(size: 8))
                    .baselineOffset(-6)
                    .foregroundStyle(.gray)
            }
            .frame(width: 40, alignment: .leading)
            Spacer()
            Text("Ozone")
                .foregroundStyle(.white)
                .font(.system(size: 14))
                .frame(width: 180, alignment: .leading)
                .bold()
            Spacer()
            HStack {
                Text("\(components.o3, specifier: "%.0f") μg/m")
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
                + Text("3")
                    .font(.system(size: 8))
                    .baselineOffset(-6)
                    .foregroundStyle(.gray)
            }
            .frame(width: 77, alignment: .trailing)
        }
        Divider().background(Color.gray)
        HStack{
            HStack {
                Text("PM")
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
                + Text("10")
                    .font(.system(size: 8))
                    .baselineOffset(-6)
                    .foregroundStyle(.gray)
            }
            .frame(width: 40, alignment: .leading)
            Spacer()
            Text("Particulates Under 10µm")
                .foregroundStyle(.white)
                .font(.system(size: 14))
                .frame(width: 180, alignment: .leading)
                .bold()
            Spacer()
            HStack {
                Text("\(components.pm10, specifier: "%.0f") μg/m")
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
                + Text("3")
                    .font(.system(size: 8))
                    .baselineOffset(-6)
                    .foregroundStyle(.gray)
            }
            .frame(width: 77, alignment: .trailing)
        }
        Divider().background(Color.gray)
        HStack{
            HStack {
                Text("PM")
                    .foregroundStyle(.gray)
                + Text("2.5")
                    .font(.system(size: 10))
                    .baselineOffset(-6)
                    .foregroundStyle(.gray)
            }
            .frame(width: 40, alignment: .leading)
            Spacer()
            Text("Particulates Under 2.5µm")
                .foregroundStyle(.white)
                .frame(width: 180, alignment: .leading)
                .font(.system(size: 14))
                .bold()
            Spacer()
            HStack {
                Text("\(components.pm2_5, specifier: "%.0f") μg/m")
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
                + Text("3")
                    .font(.system(size: 8))
                    .baselineOffset(-6)
                    .foregroundStyle(.gray)
            }
            .frame(width: 77, alignment: .trailing)
        }
        Divider().background(Color.gray)
        HStack{
            HStack {
                Text("SO")
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
                + Text("2")
                    .font(.system(size: 8))
                    .baselineOffset(-6)
                    .foregroundStyle(.gray)
            }
            .frame(width: 40, alignment: .leading)
            Spacer()
            Text("Sulphur Dioxide")
                .foregroundStyle(.white)
                .font(.system(size: 14))
                .frame(width: 180, alignment: .leading)
                .font(.none)
                .bold()
            Spacer()
            HStack {
                Text("\(components.so2, specifier: "%.0f") μg/m")
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
                + Text("3")
                    .font(.system(size: 8))
                    .baselineOffset(-6)
                    .foregroundStyle(.gray)
            }
            .frame(width: 77, alignment: .trailing)
        }
        Divider().background(Color.gray)
        HStack{
            HStack {
                Text("NH")
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
                + Text("3")
                    .font(.system(size: 8))
                    .baselineOffset(-6)
                    .foregroundStyle(.gray)
            }
            .frame(width: 40, alignment: .leading)
            Spacer()
            Text("Ammonia")
                .foregroundStyle(.white)
                .font(.system(size: 14))
                .frame(width: 180, alignment: .leading)
                .font(.none)
                .bold()
            Spacer()
            HStack {
                Text("\(components.nh3, specifier: "%.0f") μg/m")
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
                + Text("3")
                    .font(.system(size: 8))
                    .baselineOffset(-6)
                    .foregroundStyle(.gray)
            }
            .frame(width: 77, alignment: .trailing)
        }
    }
}

#Preview {
    @Previewable @StateObject var viewModel: ViewModel = ViewModel()
    AirPolutionView()
        .environmentObject(viewModel)
}
