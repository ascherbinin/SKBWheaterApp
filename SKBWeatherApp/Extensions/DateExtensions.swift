//
//  DateExtensions.swift
//  SKBWeatherApp
//
//  Created by Андрей Щербинин on 15.06.17.
//  Copyright © 2017 AS. All rights reserved.
//

import Foundation

extension DateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat =  dateFormat

    }
}

extension NSDate {
    struct Formatter {
        static let custom = DateFormatter(dateFormat: "dd/M/yyyy, H:mm")
    }
    
    var customFormatted: String {
        Formatter.custom.timeZone = TimeZone(abbreviation: "local")
        return Formatter.custom.string(from: self as Date)
    }
}
