//
//  HistoryViewController.swift
//  TimeCalculator
//
//  Created by 김민지 on 2022/01/10.
//

import UIKit
import GoogleMobileAds

final class HistoryViewController: UIViewController {
    private lazy var text = ""
    private lazy var alertTitle = ""
    private lazy var alertMessage = ""
    private lazy var noTitle = ""
    private lazy var yesTitle = ""

    @IBOutlet weak var historyTextView: UITextView!
    @IBOutlet weak var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguage()

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
            text = ""
        } else {
            history.forEach {
                text += """
                       \($0) \n\n
                       """
            }
        }
        historyTextView.text = text
    }

    // 휴지통 버튼 클릭시
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let noAction = UIAlertAction(title: noTitle, style: .destructive, handler: nil)
        let yesAction = UIAlertAction(title: yesTitle, style: .default) { [weak self] _ in
            UserDefaults.standard.set([], forKey: "History")
            DispatchQueue.main.async {
                self?.viewWillAppear(true)
            }
        }

        alert.addAction(noAction)
        alert.addAction(yesAction)
        present(alert, animated: true)
    }

    // 닫기 버튼 클릭시
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: false)
    }

    // 언어 설정
    func setLanguage() {
        let language = LanguageManaer.currentLanguage()
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
                    ?? Bundle.main.path(forResource: "en", ofType: "lproj")
        let bundle = Bundle(path: path!)

        alertTitle = bundle?.localizedString(forKey: "delete_history_title", value: nil, table: nil) ?? ""
        alertMessage = bundle?.localizedString(forKey: "delete_history_message", value: nil, table: nil) ?? ""
        noTitle = bundle?.localizedString(forKey: "delete_history_no", value: nil, table: nil) ?? ""
        yesTitle = bundle?.localizedString(forKey: "delete_history_yes", value: nil, table: nil) ?? ""
    }
}
