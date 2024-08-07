//
//  DateHelper.swift
//  Active Dispatch
//
//  Created by Scott Quintana on 12/30/20.
//
import Foundation

class DateHelper {
    static var incomingDateString: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "CST")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
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
    
    
    static func convertInt64ToDate(_ timestamp: Int64) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000)
    }
    
    
    static func convertInt64ToDateString(_ timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000)
        return incomingDateString.string(from: date)
    }
    
    static func convertInt64ToShortDayString(_ timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000)
        return shortDay.string(from: date)
    }
    
    static func convertInt64ToTimeString(_ timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000)
        return timeDateFormatter.string(from: date)
    }
    
    static func convertStringToDateString(_ string: String) -> String {
        let date = incomingDateString.date(from: string) ?? Date()
        return shortDay.string(from: date)
    }
    
    static func convertStringToTimeString(_ string: String) -> String {
        let time = incomingDateString.date(from: string)!
        return timeDateFormatter.string(from: time)
    }
}

extension TimeInterval {
    func format(using units: NSCalendar.Unit) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        
        return formatter.string(from: self)
    }
}


/*
 static var incomingDateString: DateFormatter = {
 let formatter = DateFormatter()
 formatter.locale = Locale(identifier: "en_US_POSIX")
 formatter.timeZone = TimeZone(abbreviation: "CST")
 formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
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
 
 
 static func convertInt64ToDateString(_ int64: Int64) -> String {
 let date = incomingDateString.date(from: string) ?? Date()
 
 return shortDay.string(from: date)
 }
 
 
 static func convertIntToTimeString(_ int: Int64) -> String {
 let time = incomingDateString.date(from: string)!
 return timeDateFormatter.string(from: time)
 }
 */
