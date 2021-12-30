//
//  SettingViewController.swift
//  TimeCalculator
//
//  Created by 김민지 on 2021/12/17.
//

import UIKit
import AVFoundation
import MessageUI

class SettingViewController: UIViewController {
    var player: AVAudioPlayer!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var darkModeButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.versionLabel.text = "iOS v\(getCurrentVersion()) build \(getBuildNumber())"
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissLanguageVCNotification(_:)), name: NSNotification.Name("DismissLanguageVC"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppearanceCheck(self)
        self.setLanguage()
        
        reviewButton.layer.borderColor = UIColor.systemGray.cgColor
        reviewButton.layer.borderWidth = 1
        
        [darkModeButton, soundButton, feedbackButton, languageButton].forEach {
            $0?.layer.borderWidth = 1
            if self.overrideUserInterfaceStyle == .light {
                $0?.layer.borderColor = UIColor.black.cgColor
            } else {
                $0?.layer.borderColor = UIColor.white.cgColor
            }
        }
    }
    
    @objc func didDismissLanguageVCNotification(_ notification: Notification) {
        self.viewWillAppear(true)
    }
    
    // 모든 버튼이 눌릴 때마다 소리 출력
    @IBAction func buttonPressed(_ sender: UIButton) {
        let soundOff = UserDefaults.standard.bool(forKey: "SoundOff")
        if !soundOff {
            let systemSoundID: SystemSoundID = 1105
            AudioServicesPlaySystemSound(systemSoundID)
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
    
    // 앱 평가 버튼 클릭 시
    @IBAction func reviewButtonTapped(_ sender: UIButton) {
        // 스토어 url 열기
//        if let url = URL(string: ""), UIApplication.shared.canOpenURL(url) {
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//        }
    }
    
    // 피드백 보내기 버튼 클릭 시
    @IBAction func feedbackButtonTapped(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let composeViewController = MFMailComposeViewController()
            composeViewController.mailComposeDelegate = self
            
            let bodyString = """
                             이곳에 피드백을 작성해 주시면 최대한 빨리 답변해 드리겠습니다.
                             
                             -------------------
                             
                             Device Model : \(self.getDeviceIdentifier())
                             Device OS : \(UIDevice.current.systemVersion)
                             App Version : \(self.getCurrentVersion())
                             
                             -------------------
                             """
            
            composeViewController.setToRecipients(["timeCalculator.help@gmail.com"])
            composeViewController.setSubject("<시간계산기> 피드백")
            composeViewController.setMessageBody(bodyString, isHTML: false)
            
            self.present(composeViewController, animated: true, completion: nil)
        } else {
            print("메일 보내기 실패")
            let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
            let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
                // 앱스토어로 이동하기(Mail)
                if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
            
            sendMailErrorAlert.addAction(goAppStoreAction)
            sendMailErrorAlert.addAction(cancleAction)
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
    }
    
    // 언어 버튼 클릭 시
    @IBAction func languageButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let languageViewController = storyboard.instantiateViewController(withIdentifier: "LanguageViewController")
        languageViewController.modalPresentationStyle = .fullScreen
        self.present(languageViewController, animated: false, completion: nil)
    }
    
    // Device Identifier 찾기
    func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
    // 현재 버전 가져오기
    func getCurrentVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }
    
    // 빌드 번호 가져오기
    func getBuildNumber() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let build = dictionary["CFBundleVersion"] as? String else { return "" }
        return build
    }
    
    // 언어 설정
    func setLanguage() {
        guard let language = UserDefaults.standard.array(forKey: "Language")?.first as? String else { return }
        let index = language.index(language.startIndex, offsetBy: 2)
        let languageCode = String(language[..<index])
        
        let path = Bundle.main.path(forResource: languageCode, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        self.titleLabel.text = bundle?.localizedString(forKey: "settings", value: nil, table: nil)
        self.darkModeButton.setTitle(bundle?.localizedString(forKey: "dark", value: nil, table: nil), for: .normal)
        self.soundButton.setTitle(bundle?.localizedString(forKey: "sound", value: nil, table: nil), for: .normal)
        self.reviewButton.setTitle(bundle?.localizedString(forKey: "review", value: nil, table: nil), for: .normal)
        self.feedbackButton.setTitle(bundle?.localizedString(forKey: "feedback", value: nil, table: nil), for: .normal)
        self.languageButton.setTitle(bundle?.localizedString(forKey: "language", value: nil, table: nil), for: .normal)
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}
