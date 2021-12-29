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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppearanceCheck(self)
        
        [englishButton, koreanButton].forEach {
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
            let url = Bundle.main.url(forResource: "click", withExtension: "wav")
            player = try! AVAudioPlayer(contentsOf: url!)
            player.play()
        }
        
        // 언어 변경
        switch sender.titleLabel?.text! {
        case "English":
            print("영어로")
        case "한국어":
            print("한글로")
        default:
            break
        }
        
        dismiss(animated: false, completion: nil)
    }
}
