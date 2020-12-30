//
//  DateHelper.swift
//  NashvillePoliceAlerts
//
//  Created by Scott Quintana on 12/30/20.
//
import Foundation

class DateHelper {
    
    static var incomingDateString: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    static var shortDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        formatter.calendar = Calendar(identifier: .iso8601)
        return formatter
    }()
    
    
    static var timeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    
    static func convertStringToDateString(_ string: String) -> String {
        let date = incomingDateString.date(from: string)!
        return shortDay.string(from: date)
    }
    

    
    static func convertStringToTimeString(_ string: String) -> String {
        let time = incomingDateString.date(from: string)!
        return timeDateFormatter.string(from: time)
    }
    
}
