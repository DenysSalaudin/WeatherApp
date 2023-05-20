//
//  Errors.swift
//  Weather
//
//  Created by Denis on 2/14/23.
//

import Foundation

enum WeatherError: Error {
    case missingData
    case networkError
    case unexpectedError(error: Error)
    case unownedUrl
   
}

extension WeatherError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .missingData:
            return NSLocalizedString("Found and will discard a weather missing a valid code, magnitude, place, or time.", comment: "")
        case .networkError:
            return NSLocalizedString("Error fetching weather data over the network.", comment: "")
        case .unexpectedError(let error):
            return NSLocalizedString("Received unexpected error. \(error.localizedDescription)", comment: "")
        case .unownedUrl:
            return NSLocalizedString("Cannot find url",comment: "")
        }
    }
}
