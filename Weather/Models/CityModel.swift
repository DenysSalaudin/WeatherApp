// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let location = try? JSONDecoder().decode(Location.self, from: jsonData)

import Foundation

// MARK: - LocationElement
struct LocationElement: Codable {
    let name: String?
    let lat, lon: Double?
    let country, state: String?
}
struct Location: Codable {
    let locations: [LocationElement]?
}
