//
//  TodoList.swift
//  handy
//
//  Created by jiyeon on 2021/09/02.
//

import Foundation

class TodoList {
    var todos: [Todo] = []
    var notCompletedMark = 0
    
    func add(_ todo: Todo) {
        todos.insert(todo, at: notCompletedMark)
        notCompletedMark += 1
    }
    
    func delete(at index: Int) {
        // 미완료 항목 삭제 : mark-1
        if !todos[index].isCompleted {
            notCompletedMark -= 1
        }
        todos.remove(at: index)
    }
    
    func changeCompleted(id: UUID) {
        for (index, todo) in todos.enumerated() {
            if todo.identifier == id {
                // 임시 객체에 completed 반전하여 저장 후 기존 객체 삭제
                let tmp = Todo(isCompleted: !todo.isCompleted, group: todo.group, task: todo.task)
                todos.remove(at: index)
                
                if tmp.isCompleted {  // 미완료 -> 완료
                    todos.append(tmp)
                    notCompletedMark -= 1
                } else {            // 완료 -> 미완료
                    todos.insert(tmp, at: notCompletedMark)
                    notCompletedMark += 1
                }
            }
        }
    }
    
    func update(id: UUID, _ group: ToDoGroup, _ task: String) {
        for todo in todos {
            if todo.identifier == id {
                todo.group = group
                todo.task = task
            }
        }
    }
    
    func getTodo(id: UUID) -> Todo? {
        for todo in todos {
            if todo.identifier == id {
                return todo
            }
        }
        
        return nil
    }
    
    func getTodoIndex(id: UUID) -> Int {
        for (index, todo) in todos.enumerated() {
            if todo.identifier == id {
                return index
            }
        }
        return -1
    }
}
