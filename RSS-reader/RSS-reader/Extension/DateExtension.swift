//
//  NSDateExtension.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 18.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import Foundation


private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.timeZone = TimeZone.current

    return dateFormatter
}()

private let dateFormatsWithComma = ["EEE, d MMM yyyy HH:mm:ss zzz",
                                    "EEE, d MMM yyyy HH:mm zzz",
                                    "EEE, d MMM yyyy HH:mm:ss",
                                    "EEE, d MMM yyyy HH:mm"]

private let dateFormatsWithoutComma = ["d MMM yyyy HH:mm:ss zzz",
                                       "d MMM yyyy HH:mm zzz",
                                       "d MMM yyyy HH:mm:ss",
                                       "d MMM yyyy HH:mm"]

private var lastUsedDateFormatString: String?

extension Date {
    static func dateFromRFC822String(RFC822String: String) -> Date? {
        let RFC822String = RFC822String.uppercased()

        if lastUsedDateFormatString != nil {
            if let date = dateFormatter.date(from: RFC822String) {
                return date
            }
        }

        if RFC822String.contains(",") {
            for dateFormat in dateFormatsWithComma {
                dateFormatter.dateFormat = dateFormat
                if let date = dateFormatter.date(from: RFC822String) {
                    lastUsedDateFormatString = dateFormat
                    return date
                }
            }
        } else {
            for dateFormat in dateFormatsWithoutComma {
                dateFormatter.dateFormat = dateFormat
                if let date = dateFormatter.date(from: RFC822String) {
                    lastUsedDateFormatString = dateFormat
                    return date
                }
            }
        }
        return nil
    }
    
    func toString( dateFormat format  : String ) -> String
    {
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
