//
//  ColorPalette.swift
//  WorkoutTimer
//
//  Created by Mykhaylo Levchuk on 15/08/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import UIKit

enum ColorPalette {
    case primary
    case secondary
    case subprimary
    case subsecondary
    
    var color: UIColor {
        switch self {
        case .primary: return UIColor(hexString: "#0E3746")
        case .secondary: return UIColor(hexString: "#E7EEFB")
        case .subprimary: return UIColor(hexString: "F4F2EC")
        case .subsecondary: return UIColor(hexString: "#F7444E")
        }
    }
}


