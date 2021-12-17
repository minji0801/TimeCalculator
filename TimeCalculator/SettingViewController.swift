//
//  SettingViewController.swift
//  TimeCalculator
//
//  Created by 김민지 on 2021/12/17.
//

import UIKit
import AVFoundation

class SettingViewController: UIViewController {
    var player: AVAudioPlayer!
    
    @IBOutlet weak var darkModeButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var feedbackButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppearanceCheck(self)
        
        [darkModeButton, soundButton, reviewButton, feedbackButton].forEach {
            $0?.layer.borderWidth = 1
            if self.overrideUserInterfaceStyle == .light {
                $0?.layer.borderColor = UIColor.black.cgColor
            } else {
                $0?.layer.borderColor = UIColor.white.cgColor
            }
        }
    }
    
    // 모든 버튼이 눌릴 때마다 소리 출력
    @IBAction func buttonPressed(_ sender: UIButton) {
        let soundOff = UserDefaults.standard.bool(forKey: "SoundOff")
        if !soundOff {
            let url = Bundle.main.url(forResource: "click", withExtension: "wav")
            player = try! AVAudioPlayer(contentsOf: url!)
            player.play()
        }
    }
    
    // 다크모드 버튼 클릭 시
    @IBAction func darkModeButtonTapped(_ sender: UIButton) {
        if self.overrideUserInterfaceStyle == .light {
            UserDefaults.standard.set("Dark", forKey: "Appearance")
        } else {
            UserDefaults.standard.set("Light", forKey: "Appearance")
        }
        self.viewWillAppear(true)
    }
    
    // 버튼 사운드 클릭 시
    @IBAction func soundButtonTapped(_ sender: UIButton) {
        let soundOff = UserDefaults.standard.bool(forKey: "SoundOff")
        UserDefaults.standard.set(!soundOff, forKey: "SoundOff")
    }
    
}
