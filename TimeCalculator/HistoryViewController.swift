//
//  HistoryViewController.swift
//  TimeCalculator
//
//  Created by 김민지 on 2022/01/10.
//

import UIKit

class HistoryViewController: UIViewController {
    var text = ""
    
    @IBOutlet weak var historyTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let history = UserDefaults.standard.array(forKey: "History") as? [String] else { return }
        
        history.forEach {
            text += """
                    \($0) \n\n
                    """
        }
        
        historyTextView.text = self.text
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppearanceCheck(self)
    }
    
    // 휴지통 버튼 클릭시
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        // Alert 띄우기
        // UserDefaults에 History 모두 지우고 화면 Reload하기
        
    }

    // 닫기 버튼 클릭시
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}
