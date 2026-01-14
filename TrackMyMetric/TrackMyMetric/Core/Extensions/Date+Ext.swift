//
//  Date+Ext.swift
//  TrackMyMetric
//
//  Created by Nikunj Modi on 04/01/26.
//

import Foundation

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}
