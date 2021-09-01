//
//  ToDoViewController.swift
//  handy
//
//  Created by jiyeon on 2021/09/01.
//

import UIKit

enum ToDoMode {
    case add, modify, show
}

class ToDoViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var showTodoView: UITableView!
    
    // MARK: 필요한 변수들
    var date: Date?
    
    var mode: ToDoMode = .show {
        didSet {
            if mode == .add {
                print("add mode")
            } else if mode == .modify {
                print("modify mode")
            } else {
                print("show mode")
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
        dateLabel.text = dateFormatter.string(from: date!)
    }
    
    func configureView() {
        // table view
        showTodoView.delegate = self
        showTodoView.dataSource = self
    }
}

extension ToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
