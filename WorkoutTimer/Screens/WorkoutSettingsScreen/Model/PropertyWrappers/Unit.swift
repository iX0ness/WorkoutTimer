//
//  Minute.swift
//  WorkoutTimer
//
//  Created by Mykhaylo Levchuk on 21/08/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import Foundation

@propertyWrapper struct Unit<Value: Comparable> {
    var value: Value
    var range: ClosedRange<Value>
    
    init(initialValue value: Value, _ range: ClosedRange<Value>) {
        precondition(range.contains(value))
        self.value = value
        self.range = range
    }
    
    var wrappedValue: Value {
        get { value }
        set { value = min(max(range.lowerBound, newValue), range.upperBound) }
    }
}
