//
//  ToDoCell.swift
//  handy
//
//  Created by jiyeon on 2021/09/02.
//

import UIKit

protocol ToDoCellDelegate {
    func setModifyingCell(cell: ToDoCell)
    func getMode() -> ToDoMode
    func changeMode(mode: ToDoMode)
    func setGroup(cell: ToDoCell)
}

class ToDoCell: UITableViewCell {
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var modifyTextField: UITextField!
    @IBOutlet weak var taskLabel: UILabel!
    
    var delegate: ToDoCellDelegate? // delegate는 ToDoViewController에서 셀을 반환할 때 설정
    var todoList: TodoList?
    var identifier: UUID?
    var group: ToDoGroup? {
        didSet {
            completeButton.tintColor = group!.toUIColor()
        }
    }

    func bind(todo: Todo, todoList: TodoList) {
        self.todoList = todoList
        self.identifier = todo.identifier
        // complete button
        completeButton.setImage(UIImage(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle"), for: .normal)
        completeButton.tintColor = todo.group.toUIColor()
        // modify text field
        modifyTextField.isHidden = true
        modifyTextField.delegate = self
        // task label
        taskLabel.text = todo.task
        taskLabel.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(modifyTodo(_:)))
        taskLabel.addGestureRecognizer(gestureRecognizer)
    }
    
    func startModifing() {
        delegate?.setModifyingCell(cell: self)
        delegate?.changeMode(mode: .modify)
        taskLabel.isHidden = true
        modifyTextField.isHidden = false
        modifyTextField.becomeFirstResponder()
    }
    
    func endModifing() {
        modifyTextField.isHidden = true
        taskLabel.isHidden = false
    }
    
    @IBAction func completeButtonClicked(_ sender: UIButton) {
        todoList!.changeCompleted(id: identifier!)
        // UI Update
        if let upperView = self.superview as? UITableView {
            upperView.reloadData()
        }
    }
    
    @objc func modifyTodo(_ sender: UIGestureRecognizer) {
        if let todo = todoList!.getTodo(id: identifier!) {
            group = todo.group
            modifyTextField.text = todo.task
        }
        startModifing()
    }
}

extension ToDoCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        // return 키 종료가 아닐 때(다른 text field로 포커스 이동 등) 변경 사항 저장
        if reason == .committed {
            if !textField.text!.isEmpty {
                todoList!.update(id: identifier!, group!, textField.text!)
            }
            endModifing()
            // UI Update - 다른 text field의 포커스를 잃는 것을 막기 위해 변경된 열만 업데이트
            if let upperView = self.superview as? UITableView {
                let index = todoList!.getTodoIndex(id: identifier!)
                upperView.reloadRows(at: [[0, index]], with: .none)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !textField.text!.isEmpty {
            todoList!.update(id: identifier!, group!, textField.text!)
        }
        endModifing()
        delegate?.changeMode(mode: .add)
        // UI Update
        if let upperView = self.superview as? UITableView {
            upperView.reloadData()
        }
        
        return true
    }
}
