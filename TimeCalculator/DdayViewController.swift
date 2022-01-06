//
//  DdayViewController.swift
//  TimeCalculator
//
//  Created by 김민지 on 2021/12/16.
//

import UIKit
import AVFoundation

class DdayViewController: UIViewController {
    var player: AVAudioPlayer!
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endLabel: UILabel!
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
        self.setLanguage()
        // 아랍어 인 경우에는 Label, DatePicker 위치 바꾸기
    }
    
    // 계산하기 버튼 눌렀을 때
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        let soundOff = UserDefaults.standard.bool(forKey: "SoundOff")
        if !soundOff {
            let systemSoundID: SystemSoundID = 1105
            AudioServicesPlaySystemSound(systemSoundID)
        }
        
        let day = calculationDday()
        ddayLabel.text = "D \(day)"
    }
    
    func calculationDday() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let language = UserDefaults.standard.array(forKey: "Language")?.first as? String {
            formatter.locale = Locale(identifier: language)
        }
        
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
    
    // 언어 설정
    func setLanguage() {
        var language = UserDefaults.standard.array(forKey: "Language")?.first as? String
        if language == nil {
            let str = String(NSLocale.preferredLanguages[0])
            language = String(str.dropLast(3))
        }
        let path = Bundle.main.path(forResource: language, ofType: "lproj") ?? Bundle.main.path(forResource: "en", ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        self.startLabel.text = bundle?.localizedString(forKey: "start", value: nil, table: nil)
        self.endLabel.text = bundle?.localizedString(forKey: "end", value: nil, table: nil)
        self.calculateButton.setTitle(bundle?.localizedString(forKey: "calculate", value: nil, table: nil), for: .normal)
        
        self.startDatePicker.locale = Locale(identifier: language!)
        self.endDatePicker.locale = Locale(identifier: language!)
    }
}
