//
//  File.swift
//  VKMessenger
//
//  Created by Егор on 20.01.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import Foundation

class DateConvertion {
    class func convert (date timeInterval: Int64) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(timeInterval))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = TimeZone.current
        let localDate = dateFormatter.string(from: date as Date)
        return localDate
    }
}
