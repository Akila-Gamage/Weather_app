//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Akila Gamage on 2024-12-04.
//

import SwiftUI
import _SwiftData_SwiftUI

struct WeatherView: View {
    @State var tickCount: Int = 40
    @State var tickCount2: Int = 72
    @EnvironmentObject var viewModel: ViewModel
    @State var onClickAqi : Bool = false
    @Environment(\.modelContext) private var modelContext
    @Query var locationData: [LocationDataModel]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack{
                VStack{
                    ScrollView(showsIndicators: false) {
                        //Current weather details
                        VStack{
                            if(viewModel.isCurrentLocation == true ){
                                HStack {
                                    Text("Current Location")
                                        .font(.system(size: 20))
                                        .shadow(radius: 2, x: 0, y: 2)
                                        .foregroundStyle(Color.white)
                                    Image(systemName: "location")
                                        .frame(width: 8, height: 8)
                                        .foregroundStyle(Color.white)
                                        .shadow(radius: 2, x: 0, y: 2)
                                        .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 0))
                                }
                            }
                            else {
                                Text(viewModel.searchedLocation)
                                    .font(.system(size: 30))
                                    .shadow(radius: 2, x: 0, y: 2)
                                    .foregroundStyle(Color.white)
                            }
                            Text("\(viewModel.weatherData?.current.temp ?? 0, specifier: "%.0f")°")
                                .font(.system(size: 90, weight: .thin))
                                .shadow(radius: 2, x: 0, y: 2)
                                .foregroundStyle(Color.white)
                            Text("\( viewModel.weatherData?.current.weather.first?.weatherDescription.rawValue.capitalized ?? "")")
                                .font(.system(size: 20))
                                .foregroundStyle(Color.lightBlue)
                                .shadow(radius: 2, x: 0, y: 2)
                            HStack(alignment: .center) {
                                    Text("H:\(viewModel.weatherData?.daily.first?.temp.max ?? 0, specifier: "%.0f")°")
                                        .foregroundStyle(Color.white)
                                        .shadow(radius: 2, x: 0, y: 2)
                                    Text("L:\(viewModel.weatherData?.daily.first?.temp.min ?? 0, specifier: "%.0f")°")
                                        .foregroundStyle(Color.white)
                                        .shadow(radius: 2, x: 0, y: 2)
                            }
                        }
                        .padding(EdgeInsets(top: 70, leading: 0, bottom: 50, trailing: 0))
                        
                        //hourly forcast card
                        VStack {
                            HStack {
                                Image(systemName: "clock")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                                    .foregroundStyle(Color.secondary)
                                Text("HOURLY FORCAST")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(Color.secondary)
                            }
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Divider()
                                .background(Color.secondary)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack{
                                    if let hourlyData = viewModel.weatherData?.hourly {
                                        ForEach(hourlyData) { hourly in
                                            SingleHourlyView(hourlyData: hourly)
                                        }
                                    } else {
                                        Text("No data available")
                                            .foregroundStyle(.white)
                                    }
                                }
                                
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                        
                        //8-day forcast card
                        VStack{
                            HStack {
                                Image(systemName: "calendar")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                                    .foregroundStyle(Color.secondary)
                                Text("8-Day FORCAST")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(Color.secondary)
                            }
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Divider()
                                .background(Color.secondary)
                            VStack (alignment: .leading){
                                if let dailyData = viewModel.weatherData?.daily {
                                    let highestTemp = dailyData.compactMap { $0.temp.max }.max() ?? 0.0
                                    let lowestTemp = dailyData.compactMap { $0.temp.min }.min() ?? 0.0
                                    ForEach(dailyData) { daily in
                                        SingleDailyView(dailyData: daily, highestTemp: highestTemp, lowestTemp: lowestTemp)
                                    }
                                } else {
                                    Text("No data available")
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                        
                        // Air pollution card
                        VStack {
                            let aqi = viewModel.airQualityData?.list.first?.main.aqi ?? 0
                            let description = AirQualityUtils.getAQIDescription(for: aqi)
                            let title = AirQualityUtils.getAQITitle(for: aqi)
                            HStack {
                                Image(systemName: "aqi.low")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                                    .foregroundStyle(Color.secondary)
                                Text("AIR POLLUTION")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(Color.secondary)
                            }
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(aqi)")
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 32, weight: .medium))
                            Text("\(title)")
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 22, weight: .medium))
                            ProgressView(value: 0)
                                .frame(maxWidth: .infinity, maxHeight: 4)
                                .progressViewStyle(AqiRangeProgressView(range: 1...5.0, customValue: aqi))
                            Text("Air quality index is \(aqi). which is \(description)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                                
                        }
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                        .onTapGesture {
                            onClickAqi.toggle()
                        }
                        
                        HStack{
                            //humidity card
                            VStack{
                                HStack {
                                    Image(systemName: "humidity.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 15, height: 15)
                                        .foregroundStyle(Color.secondary)
                                    Text("HUMIDITY")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundStyle(Color.secondary)
                                }
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                VStack{
                                    Text("\(viewModel.weatherData?.current.humidity ?? 0)%")
                                        .font(.system(size: 30, weight: .medium))
                                        .foregroundStyle(Color.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
                                    Text("The dew point is \(viewModel.weatherData?.current.dewPoint ?? 0.0, specifier: "%.0f")°C right now.")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundStyle(Color.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                }
                            }
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20))
                            .frame(minWidth: 0, maxWidth: 180)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(15)
                            
                            //pressure card
                            VStack{
                                HStack {
                                    Image(systemName: "gauge.with.dots.needle.bottom.50percent")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 15, height: 15)
                                        .foregroundStyle(Color.secondary)
                                    Text("PRESSURE")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundStyle(Color.secondary)
                                }
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                ZStack {
                                    ForEach(0..<tickCount, id: \.self) { i in
                                        let angle = Double(i) / Double(tickCount) * 270.0
                                        VStack {
                                            Rectangle()
                                                .fill(Color.secondary)
                                                .frame(width: 2, height: 10)
                                                .offset(y: -50) // Adjust distance from the center
                                                .rotationEffect(.degrees(angle))
                                        }
                                        .rotationEffect(.degrees(-130))
                                        .padding()
                                    }
                                    VStack {
                                        Image(systemName: "arrow.up")
                                            .foregroundStyle(Color.white)
                                        Text("\(viewModel.weatherData?.current.pressure ?? 0)")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundStyle(Color.white)
                                        Text("hPa")
                                            .foregroundStyle(Color.white)
                                            .font(.system(size: 14))
                                    }
                                    
                                }
                                .padding(EdgeInsets(top: 35, leading: 0, bottom: 33, trailing: 0))
                            }
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20))
                            .frame(minWidth: 0, maxWidth: 180)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(15)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        // Wind speed card
                        VStack {
                            HStack {
                                Image(systemName: "wind")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                                    .foregroundStyle(Color.secondary)
                                Text("WIND")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(Color.secondary)
                            }
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            HStack{
                                VStack{
                                    HStack{
                                        Text("Wind")
                                            .foregroundStyle(Color.white)
                                            .font(.system(size: 14, weight: .medium))
                                        Spacer()
                                        Text("\(viewModel.weatherData?.current.windSpeed ?? 0.0, specifier: "%.0f") \(viewModel.isMetric ? "m/s" : "mph")")
                                            .foregroundStyle(Color.secondary)
                                            .font(.system(size: 14, weight: .medium))
                                    }
                                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                                    Divider().background(Color.secondary)
                                    HStack{
                                        Text("Gusts")
                                            .foregroundStyle(Color.white)
                                            .font(.system(size: 14, weight: .medium))
                                        Spacer()
                                        Text("\(viewModel.weatherData?.current.windGust ?? 0.0, specifier: "%.0f") \(viewModel.isMetric ? "m/s" : "mph")")
                                            .foregroundStyle(Color.secondary)
                                            .font(.system(size: 14, weight: .medium))
                                    }
                                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                                    Divider().background(Color.secondary)
                                    HStack{
                                        Text("Direction")
                                            .foregroundStyle(Color.white)
                                            .font(.system(size: 14, weight: .medium))
                                        Spacer()
                                        Text("\(viewModel.weatherData?.current.windDeg ?? 0) deg")
                                            .foregroundStyle(Color.secondary)
                                            .font(.system(size: 14, weight: .medium))
                                    }
                                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                                    Divider().background(Color.secondary)
                                    
                                }
                                ZStack {
                                    VStack {
                                        Text("\(viewModel.weatherData?.current.windSpeed ?? 0.0, specifier: "%.0f")")
                                            .font(.system(size: 25, weight: .bold))
                                            .foregroundStyle(Color.white)
                                        Text("\(viewModel.isMetric ? "m/s" : "mph")")
                                            .foregroundStyle(Color.white)
                                            .font(.system(size: 18))
                                    }
                                    
                                    // Compass Ticks
                                    ForEach(0..<tickCount2, id: \.self) { i in
                                        let angle = Double(i) / Double(tickCount2) * 360.0
                                        
                                        // Skip ticks aligned with cardinal directions (N, E, S, W)
                                        if angle.truncatingRemainder(dividingBy: 90) != 0 {
                                            VStack {
                                                Rectangle()
                                                    .fill(i % (tickCount2 / 12) == 0 ? Color.white : Color.secondary) // Major ticks every 30°
                                                    .frame(
                                                        width: 1,
                                                        height: 10
                                                    )
                                                    .offset(y: -60)
                                            }
                                            .rotationEffect(.degrees(angle))
                                        }
                                    }
                                    
                                    VStack {
                                        Text("N")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                            .offset(y: -11)
                                        Spacer()
                                    }
                                    
                                    VStack {
                                        Spacer()
                                        Text("S")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                            .offset(y: 11)
                                    }
                                    
                                    HStack {
                                        Text("W")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                            .offset(x: -8)
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Spacer()
                                        Text("E")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                            .offset(x: 6)
                                    }
                                }
                                .frame(width: 120, height: 120)
                                .padding(EdgeInsets(top: 5, leading: 20, bottom: 15, trailing: 5))
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                        
                        
                    }
                    Spacer()
                }
            }
            .padding()
            .background(
                WeatherUtils.gradient(for: viewModel.weatherData?.current.weather.first?.main.rawValue ?? "Clear")
            )
            .toolbar {
                if viewModel.isPresentedAsSheets == true && viewModel.onWeatherCardTap == false {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            viewModel.isPresentedAsSheets = false
                            dismiss()
                        }
                        .foregroundStyle(Color.white)
                    }
                    if(!locationData.contains(where: { $0.name == viewModel.searchedLocation})){
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Add") {
                                addToFavorite()
                                viewModel.isPresentedAsSheets = false
                                dismiss()
                            }
                            .foregroundStyle(Color.white)
                        }
                    }
                }
            }
            .sheet(isPresented: $onClickAqi) {
                AirPolutionView()
            }
            .onAppear {
                if viewModel.isPresentedAsSheets == false && viewModel.onWeatherCardTap == false && viewModel.isCurrentLocation == true {
                    Task {
                        await viewModel.checkLocationAuthorization()
                        await viewModel.fetchWeatherData()
                        await viewModel.fetchAqiData()
                    }
                }
                else{
                    Task {
                        await viewModel.fetchAqiData()
                    }
                }

            }
        }
    }
    
    // add to favourites function
    func addToFavorite() {
        modelContext.insert(LocationDataModel(
                name: viewModel.searchedLocation,
                lat: viewModel.cordinates.latitude,
                lon: viewModel.cordinates.longitude
            )
        )
        viewModel.latestLocation = LocationDataModel(
            name: viewModel.searchedLocation,
            lat: viewModel.cordinates.latitude,
            lon: viewModel.cordinates.longitude
        )
    }

}

//#Preview {
//    WeatherView()
//}

// Single component of hourly view
struct SingleHourlyView: View {
    let hourlyData: Hourly
    var body: some View {
        VStack{
            Text(DateFormatterUtils.formattedDate(from: Int(TimeInterval(hourlyData.dt)), format: "HH"))
                .foregroundStyle(.white)
                .font(.system(size: 14, weight: .semibold))
            
            let weatherInfo = WeatherUtils.sfSymbol(for: hourlyData.weather.first?.icon ?? "")
            Image(systemName: weatherInfo.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .symbolRenderingMode(weatherInfo.isMulticolor ? .multicolor : .monochrome)
                .foregroundStyle(weatherInfo.isMulticolor ? Color.primary : Color.white)
            Text("\(hourlyData.temp, specifier: "%.0f")°")
                .foregroundStyle(Color.white)
                .font(.system(size: 15, weight: .semibold))
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
    }
}

// Single component of dailyveiw
struct SingleDailyView: View {
    let dailyData: Daily
    let highestTemp: Double
    let lowestTemp: Double
    
    var body: some View {
        HStack{
            Text(DateFormatterUtils.formattedDate(from: Int(TimeInterval(dailyData.dt)), format: "EEEE"))
                .foregroundStyle(Color.white)
                .frame(maxWidth: 100, alignment: .leading)
            Spacer()
            let weatherInfo = WeatherUtils.sfSymbol(for: dailyData.weather.first?.icon ?? "")
            Image(systemName: weatherInfo.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .symbolRenderingMode(weatherInfo.isMulticolor ? .multicolor : .monochrome)
                .foregroundStyle(weatherInfo.isMulticolor ? Color.primary : Color.white)
            Spacer()
            Text("\(dailyData.temp.min, specifier: "%.0F")°")
                .foregroundStyle(Color.secondary)
                .frame(maxWidth: 30, alignment: .center)
            ProgressView()
                .frame(maxWidth: 100, maxHeight: 4)
                .progressViewStyle(TempRangeProgressView(range: lowestTemp...highestTemp, minTemp: dailyData.temp.min, maxTemp: dailyData.temp.max))
                .padding(EdgeInsets(top: 0, leading: 1, bottom: 0, trailing: 1))
            Text("\(dailyData.temp.max, specifier: "%.0F")°")
                .foregroundStyle(Color.white)
                .frame(maxWidth: 30, alignment: .trailing)
        }
        Divider().background(Color.secondary)
    }
}
