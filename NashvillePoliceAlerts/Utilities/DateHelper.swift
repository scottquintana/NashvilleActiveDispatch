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


    static func convertStringToDateString(_ string: String) -> String {
        let date = incomingDateString.date(from: string) ?? Date()

        return shortDay.string(from: date)
    }


    static func convertStringToTimeString(_ string: String) -> String {
        let time = incomingDateString.date(from: string)!
        return timeDateFormatter.string(from: time)
    }

}

//import Foundation
//
//class DateHelper {
//    static var shortDay: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEE"
//        formatter.calendar = Calendar(identifier: .iso8601)
//        return formatter
//    }()
//
//    static func convertToShortDay(_ date: Date) -> String {
//        return shortDay.string(from: date)
//    }
//
//    static var longDay: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEEE, MMM d"
//        formatter.calendar = Calendar(identifier: .iso8601)
//        return formatter
//    }()
//
//    static func convertToLongDay(_ date: Date) -> String {
//        return longDay.string(from: date)
//    }
//
//    static var timeDateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "h:mm a"
//        return formatter
//    }()
//
//    static func convertToTimeFormat(_ date: Date) -> String {
//        return timeDateFormatter.string(from: date)
//    }
//}
