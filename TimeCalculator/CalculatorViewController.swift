//
//  CalculatorViewController.swift
//  TimeCalculator
//
//  Created by 김민지 on 2021/12/13.
//

import UIKit
import AVFoundation

class CalculatorViewController: UIViewController {
    var player: AVAudioPlayer!
    
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
    
    var input = [String](), operand = [String]()
    var countPlusTapped = 0, countMinusTapped = 0
    var isPlusTapped = false, isMinusTapped = false
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppearanceCheck(self)
    }
    
    // 버튼이 눌릴 때마다 소리 출력
    @IBAction func buttonPressed(_ sender: Any) {
        let soundOff = UserDefaults.standard.bool(forKey: "SoundOff")
        if !soundOff {
            let systemSoundID: SystemSoundID = 1104
            AudioServicesPlaySystemSound(systemSoundID)
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
        
        if isMinusTapped == true {
            isMinusTapped = false
        }
    }
    
    // AC 버튼 눌렀을 때
    @IBAction func allClearButtonTapped(_ sender: UIButton) {
        input = []
        operand = []
        
        countPlusTapped = 0
        countMinusTapped = 0
        isPlusTapped = false
        isMinusTapped = false
        
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
        // - 버튼이 이미 눌러져있을 때 symbol 만 바뀌게
        if isPlusTapped == false {
            symbolLabel.text = "+"
            
            if countPlusTapped == 0 {
                // 처음 눌렀으면 input 값을 operand에 넣기
                operand = input
                print("operand = \(operand.joined())")
            } else {
                // 처음 누른게 아니면 input + operand 값을 operand에 넣기
                let result = Int(operand.joined())! + Int(input.joined())!
                operand = String(result).map { String($0) }
                print("operand = \(operand.joined())")
            }
            
            input = []
            countPlusTapped = countPlusTapped + 1
            
            operand = convertTimeFormat(operand)
            updateLabel(inputLabel, input)
            updateLabel(operandLabel, operand)
        } else {
            print("이미 + 버튼 눌렀잖아!")
        }
        
        isPlusTapped = true
    }
    
    // - 버튼 눌렀을 때
    @IBAction func minusButtonTapped(_ sender: UIButton) {
        // + 버튼이 이미 눌러져있을 때 symbol 만 바뀌게
        if isMinusTapped == false {
            symbolLabel.text = "-"
            
            if countMinusTapped == 0 {
                operand = input
                print("operand = \(operand.joined())")
            } else {
                let result = minusOperation()
                operand = String(result).map { String($0) }
                print("operand = \(operand.joined())")
            }
            
            input = []
            countMinusTapped = countMinusTapped + 1
            
            operand = convertTimeFormat(operand)
            updateLabel(inputLabel, input)
            updateLabel(operandLabel, operand)
        } else {
            print("이미 - 버튼 눌렀잖아!")
        }
        
        isMinusTapped = true
    }
    
    // = 버튼 눌렀을 때
    @IBAction func equalButtonTapped(_ sender: UIButton) {
        print("clicked equal!!")
        print("input = \(input.joined())")
        print("operand = \(operand.joined())")
        
        if symbolLabel.text == "+" {
            let result = Int(operand.joined())! + (Int(input.joined()) ?? 0)
            print("plus result = \(result)")
            input = String(result).map { String($0) }
            operand = []
        } else if symbolLabel.text == "-" {
            let result = minusOperation()
            print("minus result = \(result)")
            input = String(result).map { String($0) }
            operand = []
        }
        
        updateLabel(inputLabel, input)
        updateLabel(operandLabel, operand)
        symbolLabel.text = ""
        
        countPlusTapped = 0
        countMinusTapped = 0
        isPlusTapped = false
        isMinusTapped = false
    }
    
    func minusOperation() -> Int {
        // operand가 3자리 이상이고, operand의 분이 input 분보다 작을 때 무조건 -40
        var result = 0
        if operand.count > 2 {
            let operandLastIndex = operand.lastIndex(of: operand.last!)!
            let operandMinute = Int(operand[operandLastIndex - 1 ... operandLastIndex].joined())!
            
            let inputLastIndex = input.lastIndex(of: input.last ?? "0") ?? 0
            var inputMinute = 0
            
            if input.count > 1 {
                inputMinute = Int(input[inputLastIndex - 1 ... inputLastIndex].joined())!
            } else {
                inputMinute = Int(input.joined()) ?? 0
            }
            
            print("operandMinute = \(operandMinute), inputMinute = \(inputMinute)")
            if operandMinute < inputMinute {
                result = Int(operand.joined())! - (Int(input.joined()) ?? 0) - 40
            } else {
                result = Int(operand.joined())! - (Int(input.joined()) ?? 0)
            }
        } else {
            result = Int(operand.joined())! - (Int(input.joined()) ?? 0)
        }
        
        if result < 0 {
            result = Int(input.joined())!
        }
        
        return result
    }
    
    func convertTimeFormat(_ value: [String]) -> [String] {
        // 시간 포맷에 맞추기 (분이 60에서 99사이라면 60을 뺀 값을 분에 적고 시에 +1 해주기)
        // 두글자 이상일 때 [6, 1] 뒤에서 두글자 가져오기
        if value.count > 1 {
            let lastIndex = value.lastIndex(of: value.last!)!
            var operandMinute = Int(value[lastIndex - 1 ... lastIndex].joined())!
            
            if operandMinute > 59 {
                var operandHour = 0
                
                if value.count > 2 {
                    operandHour = Int(value[0...lastIndex - 2].joined())!
                }
                operandHour = operandHour + 1
                operandMinute = operandMinute - 60
                print("format => \(operandHour):\(String(format: "%02d", operandMinute))")
                return "\(operandHour)\(String(format: "%02d", operandMinute))".map { String($0) }
            }
        }
        return value
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
