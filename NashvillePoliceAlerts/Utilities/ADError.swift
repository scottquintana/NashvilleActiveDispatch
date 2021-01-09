//
//  ADError.swift
//  NashvilleActiveDispatch
//
//  Created by Scott Quintana on 1/7/21.
//

import Foundation

enum ADError: String, Error {
    case invalidURL = "The URL you're trying to connect to is invalid."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received was invalid. Please try again."
    case invalidLocation = "Unable to get your location. Check your location authorization settings and try again."
}
