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
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
    }
    
    func configureView() {
        // calender view
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.calendarHeaderView.isHidden = true
        calendarView.appearance.todayColor = .init(red: 218/255, green: 217/255, blue: 255/255, alpha: 1.0)
        calendarView.appearance.selectionColor = .init(red: 213/255, green: 213/255, blue: 213/255, alpha: 1.0)
        calendarView.appearance.weekdayTextColor = .black
        for (index, weekdayLabel) in calendarView.calendarWeekdayView.weekdayLabels.enumerated() {
            weekdayLabel.text = daysOfWeek[index]
        }
        let date = dateFormatter.string(from: calendarView.currentPage)
        monthLabel.text = date.components(separatedBy: " ")[0]
        yearLabel.text = date.components(separatedBy: " ")[1]
    }
    
    func changePage(_ isPrev: Bool) {
        let calengar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = isPrev ? -1 : 1
        
        currentPage = calengar.date(byAdding: dateComponents, to: currentPage ?? Date())
        calendarView.setCurrentPage(currentPage!, animated: true)
    }
    
    // MARK: IBAction
    @IBAction func prevBtnClicked(_ sender: UIButton) {
        changePage(true)
    }
    
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        changePage(false)
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
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let date = dateFormatter.string(from: calendar.currentPage)
        monthLabel.text = date.components(separatedBy: " ")[0]
        yearLabel.text = date.components(separatedBy: " ")[1]
    }
}
