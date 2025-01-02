//
//  MapView.swift
//  WeatherApp
//
//  Created by Akila Gamage on 2024-12-04.
//

import SwiftUI
import MapKit
import _SwiftData_SwiftUI

struct MapView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Query var locationData: [LocationDataModel]
    @State var mapAnnotations: [MapAnnotationModel] = []
    @State var currentPlace: MapAnnotationModel?
    @State var selectedPlace: MapAnnotationModel?
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    var body: some View {
        NavigationStack {
            Map(coordinateRegion: $region,
                annotationItems: mapAnnotations
            ) { place in
                // Map annotation view
                MapAnnotation(coordinate: place.coordinate) {
                    VStack(spacing: 0) {
                        Text(place.name)
                          .font(.callout)
                          .padding(5)
                          .background(Color(.white))
                          .cornerRadius(10)
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                        
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.caption)
                            .foregroundColor(.red)
                            .offset(x: 0, y: -5)
                    }
                    .onTapGesture {
                      withAnimation(.easeInOut) {
                          Task {
                              viewModel.cordinates = place.coordinate
                              await viewModel.fetchWeatherData()
                          }
                          withAnimation(.spring(response: 1.0, dampingFraction: 0.7, blendDuration: 0.7)) {
                              if(place.name == "Current Location") {
                                  viewModel.isCurrentLocation = true
                              }
                              else {
                                  viewModel.isCurrentLocation = false
                                  viewModel.searchedLocation = place.name
                              }
                              viewModel.selectedTab = "weather"
                          }
                      }
                    }
                }
             }
            .mapStyle(.standard)
            .mapControls {
                MapCompass()
                MapScaleView()
                MapUserLocationButton()
            }
            .ignoresSafeArea(.all)
            .onAppear {
                var annotations: [MapAnnotationModel] = []
                for location in locationData {
                    let place = viewModel.convertToMapAnnotation(location: location)
                    annotations.append(place)
                }
                mapAnnotations = annotations
                if let location = viewModel.lastKnownLocation {
                    region.center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                    currentPlace = viewModel.convertToMapAnnotation(location: LocationDataModel(
                        name: "Current Location",
                        lat: location.latitude,
                        lon: location.longitude
                    ))
                }
                if let currentPlace {
                    mapAnnotations.append(currentPlace)
                }
            }
            .background(Color.clear.edgesIgnoringSafeArea(.all))
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation(.spring(response: 1.0, dampingFraction: 0.7, blendDuration: 0.7)) {
                            viewModel.selectedTab = "weather"
                        }
                    }) {
                        Text("Done")
                            .font(.headline)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.secondary)
                }
            }
        }
    }
}

#Preview {
    MapView()
}
