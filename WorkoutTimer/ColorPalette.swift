//
//  ColorPalette.swift
//  WorkoutTimer
//
//  Created by Mykhaylo Levchuk on 15/08/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import UIKit

enum ColorPalette {
    /// Blue shade
    case primary
    /// Azure shade
    case secondary
    /// White shade
    case subprimary
    /// Red shade
    case subsecondary
    /// Coldwhite shade
    case header
    
    var color: UIColor {
        switch self {
        case .primary: return UIColor(hexString: "#0E3746")
        case .secondary: return UIColor(hexString: "#00D1C9")
        case .subprimary: return UIColor(hexString: "F4F2EC")
        case .subsecondary: return UIColor(hexString: "#FB5D61")
        case .header: return UIColor(hexString: "#F1F1F3")
        }
    }
}


