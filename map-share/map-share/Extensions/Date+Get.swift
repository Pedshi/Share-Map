//
//  Date+Get.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-29.
//

import Foundation

extension Date {
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    static var weekDayList : [String] {
        ["sun","mon","tue","wed","thu","fri","sat"]
    }
}
