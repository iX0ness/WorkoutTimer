//
//  UIScreen+Dimension.swift
//  WorkoutTimer
//
//  Created by Mykhaylo Levchuk on 18/08/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import UIKit

extension UIScreen {
    static func valueForHeight(
        x568: CGFloat,
        x667: CGFloat? = nil,
        x736: CGFloat? = nil,
        x812: CGFloat? = nil,
        x896: CGFloat? = nil) -> CGFloat {
        let height = UIScreen.main.bounds.height
        switch height {
        case 896...:
            if let value = x896 { return value }
            fallthrough
        case 812...:
            if let value = x812 { return value }
            fallthrough
        case 736...:
            if let value = x736 { return value }
            fallthrough
        case 667...:
            if let value = x667 { return value }
            fallthrough
        case 568...:
            return x568
        default:
            fatalError("Height not supported: \(height)")
        }
    }
}
