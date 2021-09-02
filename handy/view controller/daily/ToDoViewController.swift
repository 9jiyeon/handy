//
//  ToDoViewController.swift
//  handy
//
//  Created by jiyeon on 2021/09/01.
//

import UIKit

class ToDoViewController: UIViewController {
    let todoManager = TodoManager.shared
    
    // MARK: IBOutlet
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var showTodoView: UITableView!
    @IBOutlet weak var addTodoView: UIView!
    @IBOutlet weak var showGroupButton: UIButton!
    @IBOutlet weak var addTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var groupStackView: UIStackView!
    
    // MARK: 필요한 변수들
    var date: Date?
    var todoList: TodoList?
    var modifyingCell: ToDoCell?
    
    var mode: ToDoMode = .show {
        didSet {
            if mode == .add {
                addTodoView.isHidden = false
                addButton.isHidden = true
                addTextField.becomeFirstResponder()
                groupStackView.isHidden = false
            } else if mode == .modify {
                addTodoView.isHidden = false
                addButton.isHidden = true
                groupStackView.isHidden = false
            } else {
                addTodoView.isHidden = true
                addButton.isHidden = false
                groupStackView.isHidden = true
                addTextField.resignFirstResponder()
            }
        }
    }
    
    var group: ToDoGroup = .blue {
        didSet {
            if mode == .add {
                showGroupButton.tintColor = group.toUIColor()
            } else if mode == .modify {
                setGroup(cell: modifyingCell!)
            }
        }
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MM.dd."
        return df
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let todoList = todoManager.todoLists[date!] {
            self.todoList = todoList
        } else {
            self.todoList = TodoList()
        }
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if todoList!.todos.count == 0 {
            todoManager.todoLists[date!] = nil
        } else {
            todoManager.todoLists[date!] = todoList
        }
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func configureView() {
        // date label
        dateLabel.text = dateFormatter.string(from: date!)
        
        // table view
        showTodoView.delegate = self
        showTodoView.dataSource = self
        
        // add todo view
        addTodoView.isHidden = true
        
        // text field
        addTextField.delegate = self
        
        // group stack view
        groupStackView.frame.origin.x = 0
        groupStackView.isHidden = true
    }
    
    // MARK: IBAction
    @IBAction func addButtonClicked(_ sender: UIButton) {
        mode = .add
    }
    
    // 나중에 바꿔줘야 할 부분
    @IBAction func selectGroup(_ sender: UIButton) {
        switch(sender.accessibilityIdentifier) {
        case "red":
            group = .red
        case "yellow":
            group = .yellow
        case "blue":
            group = .blue
        default:
            break
        }
    }
    
    // MARK: Obj
    @objc func keyboardShow(noti: NSNotification) {
        if let keyboardFrame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardSize = keyboardFrame.cgRectValue.height
            self.groupStackView.frame.origin.y = self.view.frame.height - self.groupStackView.frame.height - keyboardSize
        }
    }
    
    @objc func keyboardHide(noti: NSNotification) {
        self.groupStackView.frame.origin.y = self.view.frame.height - self.groupStackView.frame.height
    }
}

/* table view delegate, data source */
extension ToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todoList!.delete(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList!.todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell") as? ToDoCell
        else { return UITableViewCell() }
        cell.bind(todo: todoList!.todos[indexPath.row], todoList: todoList!)
        cell.delegate = self
        
        return cell
    }
}

/* text field delegate */
extension ToDoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 키보드 업 부르자
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.isEmpty {
            mode = .show
        } else {
            todoList?.add(Todo(group: group, task: textField.text!))
            showTodoView.reloadData()
            group = .blue
            textField.text = ""
        }
        
        return true
    }
}

/* ToDoCell delegate */
extension ToDoViewController: ToDoCellDelegate {
    func setModifyingCell(cell: ToDoCell) {
        self.modifyingCell = cell
    }
    
    func getMode() -> ToDoMode {
        return mode
    }
    
    func changeMode(mode: ToDoMode) {
        self.mode =  mode
    }
    
    func setGroup(cell: ToDoCell) {
        cell.group = group
    }
}
