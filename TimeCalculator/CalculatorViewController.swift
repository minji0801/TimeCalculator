//
//  CalculatorViewController.swift
//  TimeCalculator
//
//  Created by 김민지 on 2021/12/13.
//

import UIKit
import AVFoundation

enum Operation {
    case Add
    case Subtract
    case unknown
}

class CalculatorViewController: UIViewController {
    var player: AVAudioPlayer!
    
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    
    var displayNumber = ""
    var firstOperand = ""
    var secondOperand = ""
    var result = ""
    var currentOperation: Operation = .unknown
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 폰트 체크 하기
        UIFont.familyNames.sorted().forEach{ familyName in
            print("*** \(familyName) ***")
            UIFont.fontNames(forFamilyName: familyName).forEach { fontName in
                print("\(fontName)")
            }
            print("---------------------")
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
        guard let numberValue = sender.title(for: .normal) else { return }
        if displayNumber.count < 8 {
            self.displayNumber += numberValue
            self.outputLabel.text = updateLabel(displayNumber)
        }
    }
    
    func updateLabel(_ value: String) -> String {
        let value = value.map { String($0) }
        switch value.count {
        case 0: return "0:00"
        case 1: return "0:0\(value[0])"
        case 2: return "0:\(value.joined())"
        case 3: return "\(value[0]):\(value[1...2].joined())"
        case 4: return "\(value[0...1].joined()):\(value[2...3].joined())"
        case 5: return "\(value[0...2].joined()):\(value[3...4].joined())"
        case 6: return "\(value[0]).\(value[1...3].joined()):\(value[4...5].joined())"
        case 7: return "\(value[0...1].joined()).\(value[2...4].joined()):\(value[5...6].joined())"
        case 8: return "\(value[0...2].joined()).\(value[3...5].joined()):\(value[6...7].joined())"
        default: return ""
        }
    }
    
    // AC 버튼 눌렀을 때
    @IBAction func allClearButtonTapped(_ sender: UIButton) {
        self.displayNumber = ""
        self.firstOperand = ""
        self.secondOperand = ""
        self.result = ""
        self.currentOperation = .unknown
        self.outputLabel.text = "0:00"
        self.symbolLabel.text = ""
    }
    
    // Del 버튼 눌렀을 때
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        if !displayNumber.isEmpty {
            displayNumber.removeLast()
            self.outputLabel.text = updateLabel(displayNumber)
        }
    }
    
    // + 버튼 눌렀을 때
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        self.symbolLabel.text = "+"
        self.operation(.Add)
    }
    
    // - 버튼 눌렀을 때
    @IBAction func minusButtonTapped(_ sender: UIButton) {
        self.symbolLabel.text = "-"
        self.operation(.Subtract)
    }
    
    // = 버튼 눌렀을 때
    @IBAction func equalButtonTapped(_ sender: UIButton) {
        symbolLabel.text = ""
        self.operation(self.currentOperation)
    }
    
    func operation(_ operation: Operation) {
        self.displayNumber = convertTimeFormat(displayNumber.map { String($0) })
        
        if self.currentOperation != .unknown {
            // 두번째 이상으로 연산기호 눌렀을 때
            if !self.displayNumber.isEmpty {
                self.secondOperand = self.displayNumber
                self.displayNumber = ""
                
                guard let firstOperand = Int(self.firstOperand) else { return }
                guard let secondOperand = Int(self.secondOperand) else { return }
                
                // 연산 실시
                switch self.currentOperation {
                case .Add:
                    // 둘다 두자리이고 두 합이 100이 넘으면 40 더하기
                    if self.firstOperand.count == 2 && self.secondOperand.count == 2 && (firstOperand + secondOperand) > 99 {
                        self.result = "\(firstOperand + secondOperand + 40)"
                    } else {
                        self.result = "\(firstOperand + secondOperand)"
                    }
                    
                case .Subtract:
                    self.result = String(minusOperation(self.firstOperand, self.secondOperand))
                    
                default:
                    break
                }
                
                self.result = convertTimeFormat(self.result.map { String($0) })
                self.firstOperand = self.result
                self.outputLabel.text = updateLabel(self.result)
            }
            
            self.currentOperation = operation
        } else {
            // 처음으로 연산기호 눌렀을 때
            self.outputLabel.text = updateLabel(self.displayNumber)
            self.firstOperand = self.displayNumber
            self.currentOperation = operation
            self.displayNumber = ""
        }
    }
    
    func minusOperation(_ firstOperand: String, _ secondOperand: String) -> Int {
        // operand가 3자리 이상이고, operand의 분이 input 분보다 작을 때 무조건 -40
        var result = 0
        let firstOperand = firstOperand.map { String($0) }
        let secondOperand = secondOperand.map { String($0) }
        
        if firstOperand.count > 2 {
            let operandLastIndex = firstOperand.lastIndex(of: firstOperand.last!)!
            let operandMinute = Int(firstOperand[operandLastIndex - 1 ... operandLastIndex].joined())!

            let inputLastIndex = secondOperand.lastIndex(of: secondOperand.last ?? "0") ?? 0
            var inputMinute = 0

            if secondOperand.count > 1 {
                inputMinute = Int(secondOperand[inputLastIndex - 1 ... inputLastIndex].joined())!
            } else {
                inputMinute = Int(secondOperand.joined()) ?? 0
            }

            print("operandMinute = \(operandMinute), inputMinute = \(inputMinute)")
            if operandMinute < inputMinute {
                result = Int(firstOperand.joined())! - (Int(secondOperand.joined()) ?? 0) - 40
            } else {
                result = Int(firstOperand.joined())! - (Int(secondOperand.joined()) ?? 0)
            }
        } else {
            result = Int(firstOperand.joined())! - (Int(secondOperand.joined()) ?? 0)
        }

        if result < 0 {
            result = Int(secondOperand.joined())!
        }

        return result
    }
    
    func convertTimeFormat(_ value: [String]) -> String {
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
                return "\(operandHour)\(String(format: "%02d", operandMinute))"
            }
        }
        return value.joined()
    }
}
