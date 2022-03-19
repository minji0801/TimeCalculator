//
//  DdayViewController.swift
//  TimeCalculator
//
//  Created by 김민지 on 2021/12/16.
//

import UIKit
import AVFoundation
import GoogleMobileAds

final class DdayViewController: UIViewController {
    private let calendar = Calendar.current
    private let currentDate = Date()
    private let dateFormatter = DateFormatter()
    private lazy var daysCount: Int = 0

    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var ddayLabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        calculateButton.layer.cornerRadius = 30

        // Admob 광고
        bannerView.adUnitID = "ca-app-pub-7980627220900140/3292460324"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setLanguage()
        appearanceCheck(self)
    }

    // 새로고침
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        self.startDatePicker.date = Date()
        self.endDatePicker.date = Date()
        self.ddayLabel.text = "D - DAY"
    }

    // 계산하기
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        let soundOff = UserDefaults.standard.bool(forKey: "SoundOff")
        if !soundOff {
            let systemSoundID: SystemSoundID = 1105
            AudioServicesPlaySystemSound(systemSoundID)
        }

        let day = calculationDday()
        ddayLabel.text = "D \(day)"
    }

    // 디데이 계산
    func calculationDday() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let language = UserDefaults.standard.array(forKey: "Language")?.first as? String {
            formatter.locale = Locale(identifier: language)
        }

        let startDate = formatter.string(from: startDatePicker.date)
        let endDate = formatter.string(from: endDatePicker.date)

//        print("startDate : \(startDate), endDate : \(endDate)")

        if startDate == endDate {
            return "- DAY"
        } else {
            let result = Calendar.current.dateComponents(
                [.day],
                from: endDatePicker.date,
                to: startDatePicker.date
            ).day! + 1
//            print("result = \(result)")
            if result > 0 {
                return "+ \(result - 1)"
            } else {
                return "- \((result.magnitude + 1))"
            }
        }
    }

    // 언어 설정
    func setLanguage() {
        var language = LanguageManaer.currentLanguage()
        var path = Bundle.main.path(forResource: language, ofType: "lproj")
        if path == nil {
            path = Bundle.main.path(forResource: "en", ofType: "lproj")
            language = "en"
        }

        let bundle = Bundle(path: path!)

        self.startLabel.text = bundle?.localizedString(forKey: "start", value: nil, table: nil)
        self.endLabel.text = bundle?.localizedString(forKey: "end", value: nil, table: nil)
        self.calculateButton.setTitle(
            bundle?.localizedString(forKey: "calculate", value: nil, table: nil),
            for: .normal
        )

        self.startDatePicker.locale = Locale(identifier: language)
        self.endDatePicker.locale = Locale(identifier: language)
    }
}
