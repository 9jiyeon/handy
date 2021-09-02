//
//  TodoManager.swift
//  handy
//
//  Created by jiyeon on 2021/09/02.
//

import Foundation

class TodoManager {
    static let shared = TodoManager()
    
    var todoLists: [Date: TodoList] = [: ]
}
