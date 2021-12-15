//
//  CalculatorViewController.swift
//  TimeCalculator
//
//  Created by 김민지 on 2021/12/13.
//

import UIKit
import Foundation

class CalculatorViewController: UIViewController {
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var operandLabel: UILabel!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    
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
    var operand = [String]()
    
    var countPlusTapped = 0
    var isPlusTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.layer.cornerRadius = 20
        
        [zeroButton, oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton, allClearButton, deleteButton, minusButton, plusButton, equalButton].forEach {
            $0?.layer.cornerRadius = ($0?.layer.bounds.height)! / 3
            $0?.layer.shadowColor = UIColor.darkGray.cgColor
            $0?.layer.shadowOpacity = 0.1
            $0?.layer.shadowOffset = CGSize.init(width: 5, height: 5)
            $0?.layer.shadowRadius = 10
        }
    }
    
    // 숫자 버튼 눌렀을 때
    @IBAction func numberButtonTapped(_ sender: UIButton) {
        let clickValue = sender.title(for: .normal)!
        if input.isEmpty && clickValue == "0" {
            // 입력안됨
        } else {
            input.append(clickValue)
            //            print(input.joined())
            updateLabel(inputLabel, input)
        }
        
        if isPlusTapped == true {
            isPlusTapped = false
        }
    }
    
    // AC 버튼 눌렀을 때
    @IBAction func allClearButtonTapped(_ sender: UIButton) {
        input = []
        operand = []
        
        countPlusTapped = 0
        isPlusTapped = false
        
        inputLabel.text = "0:00"
        operandLabel.text = "0:00"
        symbolLabel.text = ""
    }
    
    // Del 버튼 눌렀을 때
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        if !input.isEmpty {
            input.removeLast()
            updateLabel(inputLabel, input)
        }
    }
    
    // + 버튼 눌렀을 때
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        if isPlusTapped == false {
            symbolLabel.text = "+"
            
            if countPlusTapped == 0 {
                // 처음 눌렀으면 input 값을 operand에 넣기
                operand = input
                print("operand = \(operand.joined())")
            } else {
                // 처음 누른게 아니면 input + operand 값을 operand에 넣기
                let result = Int(input.joined())! + Int(operand.joined())!
                operand = String(result).map { String($0) }
                print("operand = \(operand.joined())")
                
            }
            
            input = []
            countPlusTapped = countPlusTapped + 1
            
            convertTimeFormat()
            updateLabel(inputLabel, input)
            updateLabel(operandLabel, operand)
            
            // inputLabel 앞에 + 붙이기
        } else {
            print("이미 + 버튼 눌렀잖아!")
        }
        
        isPlusTapped = true
    }
    
    func convertTimeFormat() {
        // 시간 포맷에 맞추기 (분이 60에서 99사이라면 60을 뺀 값을 분에 적고 시에 +1 해주기)
        // 두글자 이상일 때 [6, 1] 뒤에서 두글자 가져오기
        let lastIndex = operand.lastIndex(of: operand.last!)!
        var operandMinute = Int(operand[lastIndex - 1 ... lastIndex].joined())!
        
        if operandMinute > 59 {
            var operandHour = 0
            
            if operand.count > 2 {
                operandHour = Int(operand[0...lastIndex - 2].joined())!
            }
            operandHour = operandHour + 1
            operandMinute = operandMinute - 60
            operand = "\(operandHour)\(String(format: "%02d", operandMinute))".map { String($0) }
            print("format => \(operandHour):\(String(format: "%02d", operandMinute))")
        }
    }
    
    func updateLabel(_ label: UILabel, _ value: [String]) {
        switch value.count {
        case 0: label.text = "0:00"
        case 1: label.text = "0:0\(value[0])"
        case 2: label.text = "0:\(value.joined())"
        case 3: label.text = "\(value[0]):\(value[1...2].joined())"
        case 4: label.text = "\(value[0...1].joined()):\(value[2...3].joined())"
        case 5: label.text = "\(value[0...2].joined()):\(value[3...4].joined())"
        case 6: label.text = "\(value[0]).\(value[1...3].joined()):\(value[4...5].joined())"
        case 7: label.text = "\(value[0...1].joined()).\(value[2...4].joined()):\(value[5...6].joined())"
        case 8: label.text = "\(value[0...2].joined()).\(value[3...5].joined()):\(value[6...7].joined())"
        default:
            break
        }
    }
}
