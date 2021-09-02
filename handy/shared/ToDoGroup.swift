//
//  TodoGroup.swift
//  handy
//
//  Created by jiyeon on 2021/09/02.
//

import Foundation
import UIKit

enum ToDoGroup {
    case red, yellow, blue
    
    func toUIColor() -> UIColor {
        switch self {
        case .red:
            return .systemRed
        case .yellow:
            return .systemYellow
        case .blue:
            return .systemBlue
        }
    }
}
