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
        
        let appearance = UserDefaults.standard.bool(forKey: "Dark")
        
        [englishButton, chineseHansButton, chineseHantButton, japaneseButton, spanishButton, frenchButton, germanButton, russianButton, portugueseButton, italianButton, koreanButton, turkishButton, dutchButton, thaiButton, swedishButton, danishButton,  vietnameseButton, norwegianButton, polishButton, finnishButton,  indonesianButton, czechButton, ukrainianButton].forEach {
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
        AppearanceCheck(self)
    }
    
    @IBAction func languageButtonTapped(_ sender: UIButton) {
        // 사운드 출력
        let soundOff = UserDefaults.standard.bool(forKey: "SoundOff")
        if !soundOff {
            let systemSoundID: SystemSoundID = 1105
            AudioServicesPlaySystemSound(systemSoundID)
        }
        
        // 언어 변경
        switch sender.titleLabel?.text! {
        case "English":
            UserDefaults.standard.set(["en"], forKey: "Language")
        case "简体中文":
            UserDefaults.standard.set(["zh-Hans"], forKey: "Language")
        case "繁體中文":
            UserDefaults.standard.set(["zh-Hant"], forKey: "Language")
        case "日本語":
            UserDefaults.standard.set(["ja"], forKey: "Language")
        case "Español":
            UserDefaults.standard.set(["es"], forKey: "Language")
        case "Français":
            UserDefaults.standard.set(["fr"], forKey: "Language")
        case "Deutsch":
            UserDefaults.standard.set(["de"], forKey: "Language")
        case "Русский":
            UserDefaults.standard.set(["ru"], forKey: "Language")
        case "Português (Brasil)":
            UserDefaults.standard.set(["pt-BR"], forKey: "Language")
        case "Italiano":
            UserDefaults.standard.set(["it"], forKey: "Language")
        case "한국어":
            UserDefaults.standard.set(["ko"], forKey: "Language")
        case "Türkçe":
            UserDefaults.standard.set(["tr"], forKey: "Language")
        case "Nederlands":
            UserDefaults.standard.set(["nl"], forKey: "Language")
        case "ภาษาไทย":
            UserDefaults.standard.set(["th"], forKey: "Language")
        case "Svenska":
            UserDefaults.standard.set(["sv"], forKey: "Language")
        case "Dansk":
            UserDefaults.standard.set(["da"], forKey: "Language")
        case "Tiếng Việt":
            UserDefaults.standard.set(["vi"], forKey: "Language")
        case "Norsk Bokmål":
            UserDefaults.standard.set(["nb"], forKey: "Language")
        case "Polski":
            UserDefaults.standard.set(["pl"], forKey: "Language")
        case "Suomi":
            UserDefaults.standard.set(["fi"], forKey: "Language")
        case "Bahasa Indonesia":
            UserDefaults.standard.set(["id"], forKey: "Language")
        case "Čeština":
            UserDefaults.standard.set(["cs"], forKey: "Language")
        case "Українська":
            UserDefaults.standard.set(["uk"], forKey: "Language")
        default:
            break
        }
        dismiss(animated: false, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name("DismissLanguageVC"), object: nil, userInfo: nil)
    }}
