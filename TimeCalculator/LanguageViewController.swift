//
//  LanguageViewController.swift
//  TimeCalculator
//
//  Created by 김민지 on 2021/12/29.
//

import UIKit
import AVFoundation

class LanguageViewController: UIViewController {
    var player: AVAudioPlayer!

    @IBOutlet weak var notiLabel: UILabel!

    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var chineseHansButton: UIButton!
    @IBOutlet weak var chineseHantButton: UIButton!
    @IBOutlet weak var japaneseButton: UIButton!
    @IBOutlet weak var spanishButton: UIButton!
    @IBOutlet weak var frenchButton: UIButton!
    @IBOutlet weak var germanButton: UIButton!
    @IBOutlet weak var russianButton: UIButton!
    @IBOutlet weak var portugueseButton: UIButton!
    @IBOutlet weak var italianButton: UIButton!
    @IBOutlet weak var koreanButton: UIButton!
    @IBOutlet weak var turkishButton: UIButton!
    @IBOutlet weak var dutchButton: UIButton!
    @IBOutlet weak var thaiButton: UIButton!
    @IBOutlet weak var swedishButton: UIButton!
    @IBOutlet weak var danishButton: UIButton!
    @IBOutlet weak var vietnameseButton: UIButton!
    @IBOutlet weak var norwegianButton: UIButton!
    @IBOutlet weak var polishButton: UIButton!
    @IBOutlet weak var finnishButton: UIButton!
    @IBOutlet weak var indonesianButton: UIButton!
    @IBOutlet weak var czechButton: UIButton!
    @IBOutlet weak var ukrainianButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguage()

        let appearance = UserDefaults.standard.bool(forKey: "Dark")

        [
            englishButton, chineseHansButton, chineseHantButton, japaneseButton, spanishButton, frenchButton,
            germanButton, russianButton, portugueseButton, italianButton, koreanButton, turkishButton, dutchButton,
            thaiButton, swedishButton, danishButton, vietnameseButton, norwegianButton, polishButton, finnishButton,
            indonesianButton, czechButton, ukrainianButton
        ].forEach {
            $0?.layer.borderWidth = 1
            if appearance {
                $0?.layer.borderColor = UIColor.white.cgColor
            } else {
                $0?.layer.borderColor = UIColor.black.cgColor
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCheck(self)
    }

    @IBAction func languageButtonTapped(_ sender: UIButton) {
        // 사운드 출력
        let soundOff = UserDefaults.standard.bool(forKey: "SoundOff")
        if !soundOff {
            let systemSoundID: SystemSoundID = 1105
            AudioServicesPlaySystemSound(systemSoundID)
        }

        changeLanguageFirst((sender.titleLabel?.text)!)
        changeLanguageSecond((sender.titleLabel?.text)!)
        changeLanguageThird((sender.titleLabel?.text)!)

        dismiss(animated: false, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name("DismissLanguageVC"), object: nil, userInfo: nil)
    }

    // 언어 설정
    func setLanguage() {
        let language = LanguageManaer.currentLanguage()
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
                    ?? Bundle.main.path(forResource: "en", ofType: "lproj")
        let bundle = Bundle(path: path!)

        notiLabel.text = bundle?.localizedString(forKey: "language_noti", value: nil, table: nil)
    }
}
