//
//  CalculatorViewController.swift
//  TimeCalculator
//
//  Created by 김민지 on 2021/12/13.
//

import UIKit

class CalculatorViewController: UIViewController {
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var operandLabel: UILabel!
    @IBOutlet weak var inputLabel: UILabel!
    
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    
    @IBOutlet weak var allClearButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var equalButton: UIButton!
    
    var input = [String]()
    var operand = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.layer.cornerRadius = 20
        
        [zeroButton, oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton, allClearButton, deleteButton, minusButton, plusButton, equalButton].forEach {
            $0?.layer.cornerRadius = ($0?.layer.bounds.height)! / 3
            $0?.layer.shadowColor = UIColor.darkGray.cgColor
            $0?.layer.shadowOpacity = 0.3
            $0?.layer.shadowOffset = CGSize.init(width: 5, height: 5)
            $0?.layer.shadowRadius = 10
        }
    }
    
    // 숫자 눌렀을 때
    @IBAction func numberButtonTapped(_ sender: UIButton) {
        let clickValue = sender.title(for: .normal)!
        if input.isEmpty && clickValue == "0" {
            // 입력안됨
        } else {
            input.append(clickValue)
            print(input.joined())
            updateInputLabel()
        }
    }
    
    // AC 버튼 눌렀을 때
    @IBAction func allClearButtonTapped(_ sender: UIButton) {
        input = []
        inputLabel.text = "0:00"
    }
    
    // Del 버튼 눌렀을 때
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        if !input.isEmpty {
            input.removeLast()
            updateInputLabel()
        }
    }
    
    func updateInputLabel() {
        switch input.count {
        case 0: inputLabel.text = "0:00"
        case 1: inputLabel.text = "0:0\(input[0])"
        case 2: inputLabel.text = "0:\(input.joined())"
        case 3: inputLabel.text = "\(input[0]):\(input[1...2].joined())"
        case 4: inputLabel.text = "\(input[0...1].joined()):\(input[2...3].joined())"
        case 5: inputLabel.text = "\(input[0...2].joined()):\(input[3...4].joined())"
        case 6: inputLabel.text = "\(input[0]).\(input[1...3].joined()):\(input[4...5].joined())"
        case 7: inputLabel.text = "\(input[0...1].joined()).\(input[2...4].joined()):\(input[5...6].joined())"
        case 8: inputLabel.text = "\(input[0...2].joined()).\(input[3...5].joined()):\(input[6...7].joined())"
        default:
            break
        }
    }
}
