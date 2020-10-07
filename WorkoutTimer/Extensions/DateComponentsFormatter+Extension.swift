//
//  DateComponentsFormatter+Extension.swift
//  WorkoutTimer
//
//  Created by Mykhaylo Levchuk on 07/10/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import Foundation

extension DateComponentsFormatter {
    static var shortStyle: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }
    
    static var fullStyle: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }
    
}
