//
//  HistoryViewController.swift
//  TimeCalculator
//
//  Created by 김민지 on 2022/01/10.
//

import UIKit
import GoogleMobileAds

class HistoryViewController: UIViewController {
    var text = ""
    var alertTitle = "", alertMessage = ""
    var noTitle = "", yesTitle = ""

    @IBOutlet weak var historyTextView: UITextView!
    @IBOutlet weak var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLanguage()

        // Admob 광고
        bannerView.adUnitID = "ca-app-pub-7980627220900140/3292460324"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCheck(self)

        guard let history = UserDefaults.standard.array(forKey: "History") as? [String] else { return }

        if history.isEmpty {
            self.text = ""
        } else {
            history.forEach {
                self.text += """
                             \($0) \n\n
                             """
            }
        }
        historyTextView.text = self.text
    }

    // 휴지통 버튼 클릭시
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: self.alertTitle, message: self.alertMessage, preferredStyle: .alert)
        let noAction = UIAlertAction(title: self.noTitle, style: .destructive, handler: nil)
        let yesAction = UIAlertAction(title: self.yesTitle, style: .default) { [weak self] _ in
            UserDefaults.standard.set([], forKey: "History")
            DispatchQueue.main.async {
                self?.viewWillAppear(true)
            }
        }

        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }

    // 닫기 버튼 클릭시
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }

    // 언어 설정
    func setLanguage() {
        var language = UserDefaults.standard.array(forKey: "Language")?.first as? String
        if language == nil {
            let str = String(NSLocale.preferredLanguages[0])
            language = String(str.dropLast(3))
        }
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
                    ?? Bundle.main.path(forResource: "en", ofType: "lproj")
        let bundle = Bundle(path: path!)

        self.alertTitle = bundle?.localizedString(forKey: "delete_history_title", value: nil, table: nil) ?? ""
        self.alertMessage = bundle?.localizedString(forKey: "delete_history_message", value: nil, table: nil) ?? ""
        self.noTitle = bundle?.localizedString(forKey: "delete_history_no", value: nil, table: nil) ?? ""
        self.yesTitle = bundle?.localizedString(forKey: "delete_history_yes", value: nil, table: nil) ?? ""
    }
}
