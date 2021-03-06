//
//  CalculatorViewController.swift
//  TimeCalculator
//
//  Created by 김민지 on 2021/12/13.
//

import UIKit
import AVFoundation
import GoogleMobileAds

enum Operation {
    case add
    case subtract
    case unknown
}

final class CalculatorViewController: UIViewController {

    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!

    private lazy var displayNumber = ""
    private lazy var firstOperand = ""
    private lazy var secondOperand = ""
    private lazy var result = ""
    private lazy var currentOperation: Operation = .unknown

    private lazy var formula = ""                // 계산식 담는 문자열
    private lazy var isClickedOperation = false  // 연산자 버튼이 눌렸는지
    private lazy var isClickedEqual = false      // = 기호 눌렀는지
    private lazy var isAddedFormula = false      // secondOperand를 formula에 넣었는지

    override func viewDidLoad() {
        super.viewDidLoad()

        // Admob 광고
        bannerView.adUnitID = "ca-app-pub-7980627220900140/3292460324"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())

        // Check Tutorial
        let tutorial = UserDefaults.standard.bool(forKey: "showedTutorial")
        if !tutorial {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let tutorialViewController = storyboard.instantiateViewController(withIdentifier: "TutorialViewController")
            tutorialViewController.modalPresentationStyle = .fullScreen
            present(tutorialViewController, animated: false)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCheck(self)
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
        createCorrectFormula()

        guard let numberValue = sender.title(for: .normal) else { return }
        if displayNumber.count < 8 {
            displayNumber += numberValue
            outputLabel.text = updateLabel(displayNumber)
        }
    }

    // 올바른 계산식 만들기
    func createCorrectFormula() {
        if isClickedOperation {    // +나 -연산자 누른적 있으면
            // 첫번째 연산자 가져오는 경우 : 두번째 연산자가 없을 때, = 기호 누른 후 추가로 연산할 때
            if secondOperand.isEmpty || isClickedEqual {
                formula = updateLabel(firstOperand)
                switch currentOperation {
                case .add:
                    formula += " + "
                case .subtract:
                    formula += " - "
                default:
                    break
                }
            } else {
                // secondOperand를 이미 formula에 넣은 경우는 다시 넣지 않도록
                if !isAddedFormula {
                    formula += updateLabel(secondOperand)
                    switch currentOperation {
                    case .add:
                        formula += " + "
                    case .subtract:
                        formula += " - "
                    default:
                        break
                    }
                    isAddedFormula = true
                }
            }
        } else {    // +나 -연산자 누른적은 없지만 =연산자 누른적 있으면
            if isClickedEqual {
                firstOperand = ""
                secondOperand = ""
                currentOperation = .unknown
                isClickedEqual = false
            }
        }
    }

    // outputLabel에 시간형식으로 값 보여주기
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
        displayNumber = ""
        firstOperand = ""
        secondOperand = ""
        result = ""
        currentOperation = .unknown
        outputLabel.text = "0:00"
        symbolLabel.text = ""
        isClickedOperation = false
        isClickedEqual = false
        formula = ""
    }

    // Del 버튼 눌렀을 때
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        if !displayNumber.isEmpty {
            displayNumber.removeLast()
            outputLabel.text = updateLabel(displayNumber)
        }
    }

    // + 버튼 눌렀을 때
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        symbolLabel.text = "+"
        operation(.add)
        isAddedFormula = false
    }

    // - 버튼 눌렀을 때
    @IBAction func minusButtonTapped(_ sender: UIButton) {
        symbolLabel.text = "-"
        operation(.subtract)
        isAddedFormula = false
    }

    // = 버튼 눌렀을 때
    @IBAction func equalButtonTapped(_ sender: UIButton) {
        symbolLabel.text = ""
        operation(currentOperation)
        isClickedEqual = true
        isClickedOperation = false

        // 계산 기록하기 : 계산식이 담긴 문자열(연산식 + "=" + 결과값)을 UserDefaults에 저장하기
        // formula가 "0:00 = 0:00"이면 저장하지 않기
        // ex) 4:16 + 1:09 + 0:37 = 6:02

        formula += "\(updateLabel(secondOperand)) = \(outputLabel.text!)"

        if formula != "0:00 = 0:00" {
            var history = UserDefaults.standard.array(forKey: "History") as? [String]
            if history == nil {
                history = [formula]
            } else {
                history?.append(formula)
            }
            UserDefaults.standard.set(history!, forKey: "History")
        }
        formula = ""
    }

    /// 연산 함수
    func operation(_ operation: Operation) {
        isClickedOperation = true
        displayNumber = convertTimeFormat(displayNumber.map { String($0) })

        if currentOperation != .unknown {
            // 두번째 이상으로 연산기호 눌렀을 때
            if !displayNumber.isEmpty {
                secondOperand = displayNumber
                displayNumber = ""

                guard let firstOperand = Int(self.firstOperand) else { return }
                guard let secondOperand = Int(self.secondOperand) else { return }

                // 연산 실시
                switch self.currentOperation {
                case .add:
                    // 둘다 분이 두자리고 두 합이 100이 넘으면 40 더하기
                    let firstMin = self.firstOperand.suffix(2)
                    let secondMin = self.secondOperand.suffix(2)

                    if firstMin.count == 2 && secondMin.count == 2 && (Int(firstMin)! + Int(secondMin)!) > 99 {
                        result = "\(firstOperand + secondOperand + 40)"
                    } else {
                        result = "\(firstOperand + secondOperand)"
                    }

                case .subtract:
                    result = String(minusOperation(self.firstOperand, self.secondOperand))

                default:
                    break
                }

                result = convertTimeFormat(result.map { String($0) })
                self.firstOperand = result
                outputLabel.text = updateLabel(result)
            }

            currentOperation = operation
        } else {
            // 처음으로 연산기호 눌렀을 때
            outputLabel.text = updateLabel(displayNumber)
            firstOperand = self.displayNumber
            currentOperation = operation
            displayNumber = ""
        }
    }

    // 뺄셈 연산
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

    // 시간 형식으로 맞춰 변환하는 함수
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
                operandHour += 1
                operandMinute -= 60
//                print("format => \(operandHour):\(String(format: "%02d", operandMinute))")
                return "\(operandHour)\(String(format: "%02d", operandMinute))"
            }
        }
        return value.joined()
    }
}
