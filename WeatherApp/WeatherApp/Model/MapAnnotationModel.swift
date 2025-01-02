//
//  MapAnnotationModel.swift
//  WeatherApp
//
//  Created by Akila Gamage on 2024-12-23.
//

import Foundation
import MapKit

// MARK: - PlaceData
struct MapAnnotationModel: Identifiable {
  let id = UUID()
  var name: String
  var coordinate: CLLocationCoordinate2D
}
