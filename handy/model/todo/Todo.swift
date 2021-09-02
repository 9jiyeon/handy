//
//  Todo.swift
//  handy
//
//  Created by jiyeon on 2021/09/02.
//

import Foundation

class Todo {
    var identifier = UUID()
    var isCompleted: Bool
    var group: ToDoGroup
    var task: String
    
    init(isCompleted: Bool = false, group: ToDoGroup, task: String) {
        self.isCompleted = isCompleted
        self.group = group
        self.task = task
    }
}
