//
//  DataExtension.swift
//  QBCloud
//
//  Created by gaoshanyu on 8/25/16.
//  Copyright © 2016 raniys. All rights reserved.
//

import Foundation

public extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
}

public extension Int {
    
    public var kb : Float { return Float(self) / 1_024 }
    public var mb : Float { return Float(self) / 1_024 / 1_024 }
    public var gb : Float { return Float(self) / 1_024 / 1_024 / 1_024 }
    
}


public extension Double {
    
    public var F: Double { return self } // 华氏温度
    public var C: Double { return (((self - 32.0) * 5.0) / 9.0) } // 摄氏温度
    public var K: Double { return (((self - 32.0) / 1.8) + 273.15) } // 开氏温度
    
}

public extension String {
    
    /// Trim white space and Newline character for string
    public var trim : String { return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
    
    /// Regex match
    ///
    /// - parameter strRegex: the regex in string
    func matches(_ regex: String) -> Bool {
        
        let regex = try! NSRegularExpression(pattern: regex, options: .dotMatchesLineSeparators)
        
        return regex.numberOfMatches(in: self, options: .reportCompletion, range: NSMakeRange(0, self.characters.count-1)) > 0 ? true : false
        
    }
    
    /// Catch a string
    ///
    /// - parameter str: catch string start at
    /// - parameter include: whether to include the start string
    func subFrom(_ str: String, include: Bool) -> String {
        
        if str == "" {
            return self
        }
        
        let range = self.range(of: str)!
        
        return include ? self.substring(from: range.lowerBound) : self.substring(from: range.upperBound)
    }
    
    /// Catch a string
    ///
    /// - parameter str: catch string end at
    /// - parameter include: whether to include the end string
    func subTo(_ str: String, include: Bool) -> String {
        
        if str == "" {
            return self
        }
        
        let range = self.range(of: str)!
        
        return include ? self.substring(to: range.upperBound) : self.substring(to: range.lowerBound)
    }
}

public extension Date {
   
    func year() -> Int {
        return (Calendar.current as NSCalendar).component(.year, from: self)
    }
    
    func month() -> Int {
        return (Calendar.current as NSCalendar).component(.month, from: self)
    }
    
    func day() -> Int {
        return (Calendar.current as NSCalendar).component(.day, from: self)
    }
    
    func hour() -> Int {
        return (Calendar.current as NSCalendar).component(.hour, from: self)
    }
    
    func minute() -> Int {
        return (Calendar.current as NSCalendar).component(.minute, from: self)
    }
    
    func second() -> Int {
        return (Calendar.current as NSCalendar).component(.second, from: self)
    }
    
    /// 1: Sunday ... 7: Saturday
    func weekday() -> Int {
        return (Calendar.current as NSCalendar).component(.weekday, from: self)
    }
    
    /// Format date to string: yyyy-MM-dd
    func stringDate() -> String {
        
        var strDate = self.description
        
        var dateFormatter: DateFormatter?
        
        if dateFormatter == nil {
            
            dateFormatter = DateFormatter()
            dateFormatter?.dateFormat = "yyyy-MM-dd"
            dateFormatter?.locale = Locale.current
            
        }
        
        strDate = dateFormatter!.string(from: self)
        
        return strDate
    }
    
    /// Format date to string: HH:mm
    func stringMinute() -> String {
        
        var stringMinute = self.description
        
        var dateFormatter: DateFormatter?
        
        if dateFormatter == nil {
            
            dateFormatter = DateFormatter()
            dateFormatter?.dateFormat = "HH:mm"
            dateFormatter?.locale = Locale.current
            
        }
        
        stringMinute = dateFormatter!.string(from: self)
        
        return stringMinute
    }
    
    /// Format date to string: yyyy-MM-dd HH:mm
    func stringMinuteDate() -> String {
        
        var strDate = self.description
        
        var dateFormatter: DateFormatter?
        
        if dateFormatter == nil {
            
            dateFormatter = DateFormatter()
            dateFormatter?.dateFormat = "yyyy-MM-dd HH:mm"
            dateFormatter?.locale = Locale.current
            
        }
        
        strDate = dateFormatter!.string(from: self)
        
        return strDate
    }
    
    /// Format date to string: yyyy-MM-dd HH:mm:ss
    func stringSecondDate() -> String {
        
        var strDate = self.description
        
        var dateFormatter: DateFormatter?
        
        if dateFormatter == nil {
            
            dateFormatter = DateFormatter()
            dateFormatter?.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter?.locale = Locale.current
            
        }
        
        strDate = dateFormatter!.string(from: self)
        
        return strDate
    }
    
    /// Format date to string: yyyy-MM-dd HHmmss
    func nameSecondDate() -> String {
        
        var strDate = self.description
        
        var dateFormatter: DateFormatter?
        
        if dateFormatter == nil {
            
            dateFormatter = DateFormatter()
            dateFormatter?.dateFormat = "yyyy-MM-dd HHmmss"
            dateFormatter?.locale = Locale.current
            
        }
        
        strDate = dateFormatter!.string(from: self)
        
        return strDate
    }
    
    /// Format date to string as format
    func stringDateByStringFormat(_ format: String) -> String {
        
        var strDate = self.description
        
        var dateFormatter: DateFormatter?
        
        if dateFormatter == nil {
            
            dateFormatter = DateFormatter()
            dateFormatter?.dateFormat = format
            dateFormatter?.locale = Locale.current
            
        }
        
        strDate = dateFormatter!.string(from: self)
        
        return strDate
    }
}
