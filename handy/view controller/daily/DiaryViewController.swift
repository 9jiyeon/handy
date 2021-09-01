//
//  DiaryViewController.swift
//  handy
//
//  Created by jiyeon on 2021/09/01.
//

import UIKit

class DiaryViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: 필요한 변수들
    var date: Date?
    
    private lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MM.dd."
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = dateFormatter.string(from: date!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
