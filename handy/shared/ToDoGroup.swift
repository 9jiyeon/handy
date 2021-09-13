//
//  TodoGroup.swift
//  handy
//
//  Created by jiyeon on 2021/09/02.
//

import Foundation
import UIKit

/* To Do - 할 일의 그룹을 설정할 때 사용 */
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
