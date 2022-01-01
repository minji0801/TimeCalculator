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
    @IBOutlet weak var koreanButton: UIButton!
    @IBOutlet weak var chineseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppearanceCheck(self)
        
        [englishButton, chineseButton, koreanButton].forEach {
            $0?.layer.borderWidth = 1
            if self.overrideUserInterfaceStyle == .light {
                $0?.layer.borderColor = UIColor.black.cgColor
            } else {
                $0?.layer.borderColor = UIColor.white.cgColor
            }
        }
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
        case "한국어":
            UserDefaults.standard.set(["ko"], forKey: "Language")
        default:
            break
        }
        dismiss(animated: false, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name("DismissLanguageVC"), object: nil, userInfo: nil)
    }}
