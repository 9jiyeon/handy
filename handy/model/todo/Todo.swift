//
//  Todo.swift
//  handy
//
//  Created by jiyeon on 2021/09/02.
//

import Foundation

class Todo {
    var identifier = UUID() // Todo 객체의 고유 ID
    var isCompleted: Bool   // 완료 상태
    var group: ToDoGroup    // 그룹
    var task: String        // 할 일
    
    init(isCompleted: Bool = false, group: ToDoGroup, task: String) {
        self.isCompleted = isCompleted
        self.group = group
        self.task = task
    }
}
