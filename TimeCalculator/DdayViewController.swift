//
//  DdayViewController.swift
//  TimeCalculator
//
//  Created by 김민지 on 2021/12/16.
//

import UIKit

class DdayViewController: UIViewController {
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var ddayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculateButton.layer.cornerRadius = 30
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppearanceCheck(self)
    }
    
    // 계산하기 버튼 눌렀을 때
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        let day = calculationDday()
        ddayLabel.text = "D \(day)"
    }
    
    func calculationDday() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko")
        
        let startDate = formatter.string(from: startDatePicker.date)
        let endDate = formatter.string(from: endDatePicker.date)
        
        print("startDate : \(startDate), endDate : \(endDate)")
        
        if startDate == endDate {
            return "- DAY"
        } else {
            let result = Calendar.current.dateComponents([.day], from: endDatePicker.date, to: startDatePicker.date).day!
            if result > 0 {
                return "+ \(result)"
            } else {
                return "- \((result - 1).magnitude)"
            }
        }
    }
}
