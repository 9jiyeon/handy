//
//  TodoManager.swift
//  handy
//
//  Created by jiyeon on 2021/09/02.
//

import Foundation

class TodoManager {
    static let shared = TodoManager()
    
    // Date 객체, TodoList 객체의 딕셔너리 배열
    var todoLists: [Date: TodoList] = [: ]
}
