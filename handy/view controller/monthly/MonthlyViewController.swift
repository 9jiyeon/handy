//
//  MonthlyViewController.swift
//  handy
//
//  Created by jiyeon on 2021/09/01.
//

import FSCalendar
import UIKit

enum MonthlyMode {
    case todo, diary, photo
}

class MonthlyViewController: UIViewController {
    let todoManager = TodoManager.shared
    
    // MARK: IBOutlet
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    // MARK: 필요한 변수들
    private let daysOfWeek = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
    
    private var currentPage: Date?
    
    private lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MM yyyy"
        return df
    }()
    
    private var mode: MonthlyMode = .todo {
        didSet {
            if mode == .todo {
                print("todo mode")
            } else if mode == .diary {
                print("diary mode")
            } else {
                print("photo mode")
            }
            calendarView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 변경 사항(이벤트 생성, 삭제 등)을 반영하기 위해 reload
        calendarView.reloadData()
    }
    
    func configureView() {
        // calender view
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.calendarHeaderView.isHidden = true
        calendarView.appearance.todayColor = .init(red: 218/255, green: 217/255, blue: 255/255, alpha: 1.0)
        calendarView.appearance.titleSelectionColor = .black
        calendarView.appearance.selectionColor = nil
        calendarView.appearance.eventDefaultColor = .init(red: 102/255, green: 051/255, blue: 153/255, alpha: 1.0)
        calendarView.appearance.eventSelectionColor = .init(red: 102/255, green: 051/255, blue: 153/255, alpha: 1.0)
        calendarView.appearance.weekdayTextColor = .black
        for (index, weekdayLabel) in calendarView.calendarWeekdayView.weekdayLabels.enumerated() {
            weekdayLabel.text = daysOfWeek[index]
        }
        let date = dateFormatter.string(from: calendarView.currentPage)
        monthLabel.text = date.components(separatedBy: " ")[0]
        yearLabel.text = date.components(separatedBy: " ")[1]
    }
    
    func changePage(isPrev: Bool) {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = isPrev ? -1 : 1
        
        currentPage = calendar.date(byAdding: dateComponents, to: currentPage ?? Date())
        calendarView.setCurrentPage(currentPage!, animated: true)
    }
    
    // MARK: IBAction
    @IBAction func prevBtnClicked(_ sender: UIButton) {
        changePage(isPrev: true)
    }
    
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        changePage(isPrev: false)
    }
    
    @IBAction func todayBtnClicked(_ sender: UIButton) {
        calendarView.setCurrentPage(calendarView.today!, animated: true)
    }
    
    @IBAction func changeMonthlyMode(_ sender: UIButton) {
        switch(sender.accessibilityIdentifier) {
        case "todo":
            mode = .todo
        case "diary":
            mode = .diary
        case "photo":
            mode = .photo
        default:
            break
        }
    }
}

extension MonthlyViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if mode == .todo {
            if let todoList = todoManager.todoLists[date] {
                return todoList.todos.count
            }
        }
        
        return 0
    }
    
    // 날짜 선택 시 해당 날짜의 Daily View로 이동
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if mode == .todo {
            guard let todoVC = self.storyboard?.instantiateViewController(identifier: "ToDoViewController") as? ToDoViewController else { return }
            todoVC.date = date
            navigationController?.pushViewController(todoVC, animated: true)
        } else if mode == .diary {
            guard let diaryVC = self.storyboard?.instantiateViewController(identifier: "DiaryViewController") as? DiaryViewController else { return }
            diaryVC.date = date
            navigationController?.pushViewController(diaryVC, animated: true)
        }
    }
    
    // 달이 바뀌었을 때 month label, year label 내용 변경
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let date = dateFormatter.string(from: calendar.currentPage)
        monthLabel.text = date.components(separatedBy: " ")[0]
        yearLabel.text = date.components(separatedBy: " ")[1]
    }
}
