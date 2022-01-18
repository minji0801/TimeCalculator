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
    
    var formula = ""                // 계산식 담는 문자열
    var isClickedOperation = false  // 연산자 버튼이 눌렸는지
    var isClickedEqual = false      // = 기호 눌렀는지
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tutorial = UserDefaults.standard.bool(forKey: "showedTutorial")
        if !tutorial {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let tutorialViewController = storyboard.instantiateViewController(withIdentifier: "TutorialViewController")
            tutorialViewController.modalPresentationStyle = .fullScreen
            self.present(tutorialViewController, animated: false, completion: nil)
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
        // 계산식 바르게 만들기 위해서
        if self.isClickedOperation {    // 계산 끝난 후 연산기호 누르면
            
            if self.secondOperand.isEmpty || isClickedEqual {
                // 첫번째 연산자 가져오는 경우 : 두번째 연산자가 없을 때, = 기호 누른 후 추가로 연산할 때
                formula = updateLabel(self.firstOperand)
            } else {
                formula += updateLabel(self.secondOperand)
            }
            
            switch self.currentOperation {
            case .Add:
                formula += " + "
            case .Subtract:
                formula += " - "
            default:
                break
            }
        } else {    // 계산 끝난 후 바로 숫자 누르면
            if self.isClickedEqual {
                self.firstOperand = ""
                self.secondOperand = ""
                self.currentOperation = .unknown
                self.isClickedEqual = false
                
            }
        }
        
        self.isClickedOperation = false
        
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
        self.isClickedOperation = false
        self.isClickedEqual = false
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
        self.isClickedEqual = true
        
        // 계산 기록하기 : 계산식이 담긴 문자열(연산식 + "=" + 결과값)을 UserDefaults에 저장하기
        // ex) 4:16 + 1:09 + 0:37 = 6:02
        formula += "\(updateLabel(self.secondOperand)) = \(self.outputLabel.text!)"
        
        var history = UserDefaults.standard.array(forKey: "History") as? [String]
        if history == nil {
            history = [formula]
        } else {
            history?.append(formula)
        }
        UserDefaults.standard.set(history! ,forKey: "History")
        
        self.formula = ""
    }
    
    func operation(_ operation: Operation) {
        self.isClickedOperation = true
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
                    // 둘다 분이 두자리고 두 합이 100이 넘으면 40 더하기
                    let firstMin = self.firstOperand.suffix(2)
                    let secondMin = self.secondOperand.suffix(2)
                    
                    if firstMin.count == 2 && secondMin.count == 2 && (Int(firstMin)! + Int(secondMin)!) > 99 {
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
    
    // 빼기 연산 함수
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

//            print("operandMinute = \(operandMinute), inputMinute = \(inputMinute)")
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
    
    // 시간 포맷에 맞춰 변환하는 함수
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
//                print("format => \(operandHour):\(String(format: "%02d", operandMinute))")
                return "\(operandHour)\(String(format: "%02d", operandMinute))"
            }
        }
        return value.joined()
    }
}
