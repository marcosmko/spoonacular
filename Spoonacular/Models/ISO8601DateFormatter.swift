//
//  ISO8601DateFormatter.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import Foundation

/// ISO8601 Date Formatter with micro seconds precision
class ISO8601DateFormatter: DateFormatter {
    
    private let microsecondsPrefix = "."
    
    override init() {
        super.init()
        self.locale = Locale(identifier: "en_US_POSIX")
        self.timeZone = TimeZone(secondsFromGMT: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func string(from date: Date) -> String {
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let components = calendar.dateComponents(Set([Calendar.Component.nanosecond]), from: date)
        
        let nanosecondsInMicrosecond = Double(1000)
        let microseconds = lrint(Double(components.nanosecond!) / nanosecondsInMicrosecond)
        
        // Subtract nanoseconds from date to ensure string(from: Date) doesn't attempt faulty rounding.
        let updatedDate = calendar.date(byAdding: .nanosecond, value: -(components.nanosecond!), to: date)!
        let dateTimeString = super.string(from: updatedDate)
        
        let string = String(format: "%@.%06ldZ",
                            dateTimeString,
                            microseconds)
        
        return string
    }
    
    override func date(from string: String) -> Date? {
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        guard let microsecondsPrefixRange = string.range(of: self.microsecondsPrefix) else {
            return super.date(from: string)
        }
        let microsecondsWithTimeZoneString = String(string.suffix(from: microsecondsPrefixRange.upperBound))
        
        let nonDigitsCharacterSet = CharacterSet.decimalDigits.inverted
        guard let timeZoneRangePrefixRange = microsecondsWithTimeZoneString.rangeOfCharacter(from: nonDigitsCharacterSet) else { return nil }
        
        let microsecondsString = String(microsecondsWithTimeZoneString.prefix(upTo: timeZoneRangePrefixRange.lowerBound))
        guard let microsecondsCount = Double(microsecondsString) else { return nil }
        
        let dateStringExludingMicroseconds = string
            .replacingOccurrences(of: "\(microsecondsPrefix)\(microsecondsString)", with: "")
        
        guard let date = super.date(from: dateStringExludingMicroseconds) else { return nil }
        let microsecondsInSecond = Double(1000000)
        let dateWithMicroseconds = date + microsecondsCount / microsecondsInSecond
        
        return dateWithMicroseconds
    }
}
