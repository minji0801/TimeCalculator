//
//  SettingViewController.swift
//  TimeCalculator
//
//  Created by 김민지 on 2021/12/17.
//

import UIKit
import AVFoundation
import MessageUI

final class SettingViewController: UIViewController {
    private var player: AVAudioPlayer!
    private lazy var alertTitle = ""
    private lazy var alertMessage = ""
    private lazy var goTitle = ""
    private lazy var cancleTitle = ""

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var darkModeButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setLanguage()
        versionLabel.text = "iOS v\(getCurrentVersion()) build \(getBuildNumber())"

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didDismissLanguageVCNotification(_:)),
            name: NSNotification.Name("DismissLanguageVC"),
            object: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCheck(self)

        let appearance = UserDefaults.standard.bool(forKey: "Dark")

        [darkModeButton, soundButton, languageButton, feedbackButton, reviewButton, backButton].forEach {
            $0?.layer.borderWidth = 1
            if appearance {
                $0?.layer.borderColor = UIColor.white.cgColor
            } else {
                $0?.layer.borderColor = UIColor.black.cgColor
            }
        }
    }

    @objc func didDismissLanguageVCNotification(_ notification: Notification) {
        setLanguage()
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
        let appearance = UserDefaults.standard.bool(forKey: "Dark")

        if appearance {
            UserDefaults.standard.set(false, forKey: "Dark")
        } else {
            UserDefaults.standard.set(true, forKey: "Dark")
        }
        viewWillAppear(true)
    }

    // 버튼 사운드 클릭 시
    @IBAction func soundButtonTapped(_ sender: UIButton) {
        let soundOff = UserDefaults.standard.bool(forKey: "SoundOff")
        UserDefaults.standard.set(!soundOff, forKey: "SoundOff")
    }

    // 앱 평가 버튼 클릭 시
    @IBAction func reviewButtonTapped(_ sender: UIButton) {
        // 스토어 url 열기
        let store = "https://apps.apple.com/kr/app/h-ours/id1605524722"
        if let url = URL(string: store), UIApplication.shared.canOpenURL(url) {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems =  [URLQueryItem(name: "action", value: "write-review")]

            guard let writeReviewURL = components?.url else { return }

            if #available(iOS 10.0, *) {
                UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(writeReviewURL)
            }
        }
    }

    // 피드백 보내기 버튼 클릭 시
    @IBAction func feedbackButtonTapped(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let composeViewController = MFMailComposeViewController()
            composeViewController.mailComposeDelegate = self

            let bodyString = """
                             Please write your feedback here.
                             I will reply you as soon as possible.
                             If there is an incorrect translation, please let me know and I will correct it.
                             thank you :)



                             ----------------------------
                             Device Model : \(getDeviceIdentifier())
                             Device OS : \(UIDevice.current.systemVersion)
                             App Version : \(getCurrentVersion())
                             ----------------------------
                             """

            composeViewController.setToRecipients(["hcolonours.help@gmail.com"])
            composeViewController.setSubject("<h:ours> Feedback")
            composeViewController.setMessageBody(bodyString, isHTML: false)

            present(composeViewController, animated: true)
        } else {
//            print("메일 보내기 실패")
            let sendMailErrorAlert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            let goAppStoreAction = UIAlertAction(title: goTitle, style: .default) { _ in
                // 앱스토어로 이동하기(Mail)
                let store = "https://apps.apple.com/kr/app/mail/id1108187098"
                if let url = URL(string: store), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            let cancleAction = UIAlertAction(title: cancleTitle, style: .destructive, handler: nil)

            sendMailErrorAlert.addAction(goAppStoreAction)
            sendMailErrorAlert.addAction(cancleAction)
            present(sendMailErrorAlert, animated: true)
        }
    }

    // 언어 버튼 클릭 시
    @IBAction func languageButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let languageViewController = storyboard.instantiateViewController(withIdentifier: "LanguageViewController")
        languageViewController.modalPresentationStyle = .fullScreen
        present(languageViewController, animated: false)
    }

    // 뒤로 가기 버튼 클릭 시
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
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
        let language = LanguageManaer.currentLanguage()
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
                    ?? Bundle.main.path(forResource: "en", ofType: "lproj")
        let bundle = Bundle(path: path!)

        titleLabel.text = bundle?.localizedString(forKey: "settings", value: nil, table: nil)
        darkModeButton.setTitle(bundle?.localizedString(forKey: "dark", value: nil, table: nil), for: .normal)
        soundButton.setTitle(bundle?.localizedString(forKey: "sound", value: nil, table: nil), for: .normal)
        reviewButton.setTitle(bundle?.localizedString(forKey: "review", value: nil, table: nil), for: .normal)
        feedbackButton.setTitle(bundle?.localizedString(forKey: "feedback", value: nil, table: nil), for: .normal)
        languageButton.setTitle(bundle?.localizedString(forKey: "language", value: nil, table: nil), for: .normal)
        backButton.setTitle(bundle?.localizedString(forKey: "back", value: nil, table: nil), for: .normal)

        alertTitle = bundle?.localizedString(forKey: "send_feedback_title", value: nil, table: nil) ?? ""
        alertMessage = bundle?.localizedString(forKey: "send_feedback_message", value: nil, table: nil) ?? ""
        goTitle = bundle?.localizedString(forKey: "send_feedbacky_go", value: nil, table: nil) ?? ""
        cancleTitle = bundle?.localizedString(forKey: "send_feedback_cancle", value: nil, table: nil) ?? ""
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        dismiss(animated: true)
    }
}
