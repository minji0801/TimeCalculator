<div align="center">
  
  <!-- Header -->
  [![header](https://capsule-render.vercel.app/api?type=waving&color=6667AB&height=250&section=header&text=h:ours&desc=Hour%20%2F%20D-day%20Calculator&descAlignY=55&fontSize=75&fontAlignY=40&fontColor=FFFFFF)](https://github.com/minji0801/TimeCalculator)
  
  h:ours is a combination of ```'hours'``` and a ```colon(:)``` indicating the time.

  Hope this helps in calculating the time for each of us, and it contains the meaning of ```'hours is ours'```.
  
  <br/>
  
  <!-- Badge -->
  ![version](https://img.shields.io/badge/v-1.3.2-brightgreen?style=flat-square)
  ![iOS](https://img.shields.io/badge/iOS-000000?style=flat-square&logo=iOS&logoColor=white)
  ![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white)
  ![Xcode](https://img.shields.io/badge/Xcode-147EFB?style=flat-square&logo=Xcode&logoColor=white)
  ![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=GitHub&logoColor=white)
  ![Figma](https://img.shields.io/badge/Figma-F24E1E?style=flat-square&logo=Figma&logoColor=white)
  [![App Store](https://img.shields.io/badge/App%20Store-0D96F6?style=flat-square&logo=App%20Store&logoColor=white)](https://apps.apple.com/kr/app/h-ours/id1605524722)
  [![Notion](https://img.shields.io/badge/Notion-181717?style=flat-square&logo=Notion&logoColor=white)](https://midi-dill-147.notion.site/h-ours-4d1c8693f14f417d8676e4d2742aab38)
  [![Gmail](https://img.shields.io/badge/Gmail-EA4335?style=flat-square&logo=Gmail&logoColor=white)](https://mail.google.com/mail/?view=cm&amp;fs=1&amp;to=hcolonours.help@gmail.com)

</div>

<!-- Navigation -->
# Navigation
1. [Motive](#-개발-동기)
2. [Goals](#-개발-목표)
3. [시간 계산](#-시간-계산)
4. [디데이 계산](#-디데이-계산)
5. [계산 기록](#-계산-기록)
6. [설정](#-설정)
7. [앱 추적 권한](#-앱-추적-권한)
8. [Design](#-화면-및-디자인)
9. [First time dealing with this](#-이번에-처음-다룬-것)
10. [Contact](#-만나러-가기)
11. [Version History](#Version-History)

<br/>

<!-- 1. 개발 동기 -->
## 🔥 개발 동기
- **시간을 계산하기가 불편하다.**
  - 매일 플래너에 Total Time을 기록하기 위한 시간 계산에 불편함이 있다.
  - ‘Hours’ 앱으로 시간을 계산하고 있지만 이보 더 좋은 앱을 개발하고 싶다.

- **디데이 계산도 할 수 있으면 좋겠다.**
  - ‘Hours’ 앱은 시간만 계산할 수 있다.
  - 시간 계산뿐만 아니라 날짜 계산(디데이)까지 가능하면 더 편리할 것 이다.

<br/>

<!-- 2. 개발 목표 -->
## 🎯 개발 목표
- **시간 계산**
  - 시간 계산이 제일 우선으로, 앱을 켜면 바로 시간을 계산할 수 있다.
  - 일반 계산기 형태로 시간을 계산한다. (‘Hours’ 앱과 유사)

- **디데이 계산**
  - 기준일과 목표일을 입력하면 계산한 디데이를 출력한다.
  - 기준일과 목표일의 기본값으로 오늘 날짜가 입력된다.

- **다국어 지원**
  - 이전에 출시한 'Scoit'은 영어만 지원했고, '모닥이'는 한국어만 지원했다.
  - 이번에는 현지화를 통해 다양한 나라에서 사용할 수 있도록 언어를 지원한다.

<br/>

<!-- 3. 시간 계산 -->
## ⏰ 시간 계산

### 1. 시간 형식 변환

시간 계산에서 제일 큰 문제는 **"연산자를 클릭할 때 입력한 시간 또는 연산 결과를 올바른 시간 포맷으로 보여줘야 한다"** 는 것이다.

> 예시) 
>
>     입력: 3:66 +
>     출력: 4:06
> 
>     입력: 1:50 + 0:25
>     출력: 2:15

<br/>
<br/>

그래서 입력 값을 올바른 시간 형식으로 변환하는 메서드를 만들었다. 입력한 시간의 분이 60~99 사이라면 분에 60을 빼고 시에 1을 더한다.

연산 기호를 누른 후 반드시 실행되며, 연산 결과가 있다면 그 결과값에도 적용된다.

> 예시) 
>
>     입력: 3:66 +
>     convertTimeFormat 메서드가 호출된다.
>     [String] 타입으로 입력한 시간을 파라미터로 받아온다. ➜ (["3", "6", "6"])
>     분(66)이 60~99 사이니까 분에 60을 빼고 시에 1을 더한 값인 406을 반환한다.

<br/>

```swift
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
```

<br/>
<br/>

### 2. 뺄셈과 덧셈

우선, 뺄셈은 첫번째 피연산자가 세자리 이상이고 분이 두번째 피연산자의 분보다 작으면 40을 뺀다.
> 예시) 
>
>     입력: 1:05 - 0:30 =
>     계산: 105 - 30 - 40 = 35
>     출력: 0:35
>
> ➜ 첫번째 피연산자(105)가 세자리이고, 분(5)이 두번째 피연산자의 분(30)보다 작기 때문에 40을 뺐다.

<br/>

그리고 덧셈에서는 아래와 같이 계산되는 문제가 있었다. 입력한 시간을 String에서 Int형으로 바꾸고 더했으니 그 결과가 출력된 것이다.
> 예시)
>
>     입력: 0:58 + 0:53 = 
>     출력: 1:11 (원래 1:51)

<br/>

그래서 덧셈은 입력한 시간의 분이 모두 두자리이고 분의 합이 100을 넘으면 40을 더한다.
> 예시)
>
>     입력: 0:58 + 0:53 =
>     계산: 58 + 53 + 40 = 151 
>     출력: 1:51 
>
> ➜ 입력한 시간의 분(58과 53)이 모두 두자리고, 두 합(111)이 100을 넘기때문에 40을 더했다.

<br/>
<br/>

### 3. 연산자 연속 클릭 시
처음에는 연산자 버튼을 클릭하면 해당 연산을 바로 실행하도록 구현했는데, 그러면 연산자 버튼을 연속으로 클릭했을 때가 문제다. 그래서 operation 메서드를 만들어서 연산자 버튼이 클릭될 때마다 호출한다.

> operation 메서드 
>
>     displayNumber 변수에 값이 있을 때만 연산을 수행한다.
>     (displayNumber는 입력한 시간을 숫자형태로 저장하는 String 타입 변수)
>     (즉, 2:58을 입력하면 displayNumber는 "258"이다.)
>     따라서, 연산자 버튼을 연속해서 클릭하더라도 에러가 발생하지 않는다.

<br/>

```swift
// 연산 함수
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
            case .add:
                // 둘다 분이 두자리고 두 합이 100이 넘으면 40 더하기
                let firstMin = self.firstOperand.suffix(2)
                let secondMin = self.secondOperand.suffix(2)

                if firstMin.count == 2 && secondMin.count == 2 && (Int(firstMin)! + Int(secondMin)!) > 99 {
                    self.result = "\(firstOperand + secondOperand + 40)"
                } else {
                    self.result = "\(firstOperand + secondOperand)"
                }

            case .subtract:
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
```

<br/>

<!-- 4. 디데이 계산 -->
## 📅 디데이 계산

디데이 계산이 은근 헷갈렸다. Calendar의 dateComponents메서드로 기준일과 종료일의 차이를 계산한다. 계산 결과가 음수면 절대값으로 변환하고 앞에 "+"를 붙이고, 계산 결과가 0이거나 양수면 1을 더한 후 앞에 "-"를 붙인다.

> 예시)
>
>     기준일: 2022.2.10, 종료일: 2022.2.17
>     dateComponents 메서드의 결과가 6이라서 1을 더하고 앞에 "-"를 붙인다.
>     출력: D - 7
>
>     기준일: 2022.2.10, 종료일: 2022.2.3
>     dateComponents 메서드의 결과가 -7이라서 절대값으로 변환한 후 앞에 "+"를 붙인다.
>     출력: D + 7

<br/>

```swift
// 디데이 계산
func calculationDday() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    if let language = UserDefaults.standard.array(forKey: "Language")?.first as? String {
        formatter.locale = Locale(identifier: language)
    }

    let startDate = formatter.string(from: startDatePicker.date)
    let endDate = formatter.string(from: endDatePicker.date)

//        print("startDate : \(startDate), endDate : \(endDate)")

    if startDate == endDate {
        return "- DAY"
    } else {
        let result = Calendar.current.dateComponents(
            [.day],
            from: startDatePicker.date,
            to: endDatePicker.date
        ).day!
//            print("result = \(result)")
        if result < 0 {
            // result가 음수면 절대값씌워서 앞에 + 붙이기
            return "+ \(result.magnitude)"
        } else {
            // 0이거나 양수면 1더해서 앞에 - 붙이기
            return "- \((result + 1))"
        }
    }
}
```
<br/>

<!-- 5. 계산 기록 -->
## 📝 계산 기록
등호(=) 버튼을 클릭했을 때 UserDefaults를 이용해서 계산식을 로컬에 저장한다.

```swift
// = 버튼 눌렀을 때
@IBAction func equalButtonTapped(_ sender: UIButton) {
    symbolLabel.text = ""
    self.operation(self.currentOperation)
    self.isClickedEqual = true
    self.isClickedOperation = false

    // 계산 기록하기 : 계산식이 담긴 문자열(연산식 + "=" + 결과값)을 UserDefaults에 저장하기
    // formula가 "0:00 = 0:00"이면 저장하지 않기
    // ex) 4:16 + 1:09 + 0:37 = 6:02

    self.formula += "\(updateLabel(self.secondOperand)) = \(self.outputLabel.text!)"

    if self.formula != "0:00 = 0:00" {
        var history = UserDefaults.standard.array(forKey: "History") as? [String]
        if history == nil {
            history = [formula]
        } else {
            history?.append(formula)
        }
        UserDefaults.standard.set(history!, forKey: "History")
    }
    self.formula = ""
}
```

<br/>

단, 올바른 계산식을 만들기 위해서 숫자 버튼을 클릭할 때마다 isClickedOperation 변수를 확인한다. 

<br/>

숫자 버튼을 눌렀을 때 이미 더하기(+)나 빼기(-)를 누른적이 있다면(isClickedOperation = true) 계산식을 만들고, 더하기(+)나 빼기(-)를 누른적은 없지만 등호(=)를 누른적이 있다면(isClickedOperation = false, isClickedEqual = true) 피연산자와 현재 연산자의 값을 초기화한다.

<br/>

계산식을 만들기 위해 첫번째 피연산자를 가져올 때 주의해야 한다. 즉, 연산을 제일 처음하는 경우를 말하는데, 두번째 피연산자가 없을 때와 등호(=)를 누른 후 추가 연산을 할 때만 첫번째 피연산자를 가져온다.

<br/>

그리고 여기서 두번째 피연산자가 반복해서 계산식에 입력되는 문제가 있었다. 그래서 isAddedFormula 변수로 두번째 피연산자를 계산식에 넣었는지 확인한다. 더하기(+)나 빼기(-) 를 클릭하면 false로 값을 초기화한다.

```swift
// 올바른 계산식 만들기
func createCorrectFormula() {
    if self.isClickedOperation {    // +나 -연산자 누른적 있으면
        // 첫번째 연산자 가져오는 경우 : 두번째 연산자가 없을 때, = 기호 누른 후 추가로 연산할 때
        if self.secondOperand.isEmpty || isClickedEqual {
            formula = updateLabel(self.firstOperand)
            switch self.currentOperation {
            case .add:
                formula += " + "
            case .subtract:
                formula += " - "
            default:
                break
            }
        } else {
            // secondOperand를 이미 formula에 넣은 경우는 다시 넣지 않도록
            if !self.isAddedFormula {
                formula += updateLabel(self.secondOperand)
                switch self.currentOperation {
                case .add:
                    formula += " + "
                case .subtract:
                    formula += " - "
                default:
                    break
                }
                self.isAddedFormula = true
            }
        }
    } else {    // +나 -연산자 누른적은 없지만 =연산자 누른적 있으면
        if self.isClickedEqual {
            self.firstOperand = ""
            self.secondOperand = ""
            self.currentOperation = .unknown
            self.isClickedEqual = false
        }
    }
}
```

<br/>

<!-- 6. 설정 -->
## 🛠 설정
### 다크 모드
설정의 '다크 모드' 버튼으로 앱의 UI Style을 변경할 수 있다.

<br/>

<p align="center"><img src="https://user-images.githubusercontent.com/49383370/152300020-5cae4abe-4ab4-4473-b604-eb86e3a059d9.jpeg"></p>

<br/>

UserDefaults로 키가 "Dark"인 로컬저장소에서 값을 가져온 후 이와 반대로 저장한다. 앱의 기본 Appearance를 Light로 설정했기 때문에 처음에 가져오는 값은 false다.

<br/>

```swift
// 다크모드 버튼 클릭 시
@IBAction func darkModeButtonTapped(_ sender: UIButton) {
    let appearance = UserDefaults.standard.bool(forKey: "Dark")

    if appearance {
        UserDefaults.standard.set(false, forKey: "Dark")
    } else {
        UserDefaults.standard.set(true, forKey: "Dark")
    }
    self.viewWillAppear(true)
}
```

<br/>

viewWillAppear 메서드에서 appearanceCheck 함수가 호출된다. UserDefaults로 로컬에 저장한 값을 가져와 앱의 Appearance를 변경한다. 모든 ViewController의 viewWillAppear 메서드에서 appearanceCheck 함수를 호출한다.

<br/>

```swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    appearanceCheck(self)
}
```

```swift
// UserDefaults에 저장된 값을 통해 다크모드 확인하는 메소드
func appearanceCheck(_ viewController: UIViewController) {
    let appearance = UserDefaults.standard.bool(forKey: "Dark")

    if appearance {
        viewController.overrideUserInterfaceStyle = .dark
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            UIApplication.shared.statusBarStyle = .default
        }
    } else {
        viewController.overrideUserInterfaceStyle = .light
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .darkContent
        } else {
            UIApplication.shared.statusBarStyle = .default
        }
    }
}
```

<br/>

### 사운드
기본으로 버튼 클릭 시 소리가 나도록 구현했는데, 설정의 '사운드' 버튼을 통해 소리가 나지 않도록 할 수 있다. 

<br/>

<p align="center"><img src="https://user-images.githubusercontent.com/49383370/152310768-25e6b7c8-26dc-4b9e-83d4-de5d5fe38db3.jpeg"></p>

<br/>

UserDefaluts로 키가 "SoundOff"인 로컬 저장소에서 값을 가져온 후 이와 반대로 저장한다.

<br/>

```swift
// 버튼 사운드 클릭 시
@IBAction func soundButtonTapped(_ sender: UIButton) {
    let soundOff = UserDefaults.standard.bool(forKey: "SoundOff")
    UserDefaults.standard.set(!soundOff, forKey: "SoundOff")
}
```

그리고 버튼을 클릭하면 로컬에 저장된 값을 가져와 AVFoundation 프레임워크로 소리를 재생한다.

<br/>

```swift
import AVFoundation

// 버튼이 눌릴 때마다 소리 출력
@IBAction func buttonPressed(_ sender: Any) {
    let soundOff = UserDefaults.standard.bool(forKey: "SoundOff")
    if !soundOff {
        let systemSoundID: SystemSoundID = 1104
        AudioServicesPlaySystemSound(systemSoundID)
    }
}
```

<br/>

### 언어
설정의 '언어' 버튼을 통해서 앱의 언어를 변경할 수 있다. 1.3.2 버전을 기준으로 총 8개의 언어를 지원하고 있다.

<br/>

<p align="center"><img src="https://user-images.githubusercontent.com/49383370/152671549-b8ddf5c3-cd00-4350-a95b-cf97c7428545.jpeg"></p>

<br/>

'언어' 버튼을 클릭하면 changeLanguageFirst, changeLanguageSecond, changeLanguageThird 메서드를 호출해서 UserDefaults로 키가 "Language"인 로컬에 값을 저장한다. 하나의 메서드로 작성할 시 SwiftLint의 순환 복잡도 룰에 위반되기 때문에 메서드를 3개로 나눈 것이다.

```swift
@IBAction func languageButtonTapped(_ sender: UIButton) {
    ...
    changeLanguageFirst((sender.titleLabel?.text)!)
    changeLanguageSecond((sender.titleLabel?.text)!)
    changeLanguageThird((sender.titleLabel?.text)!)
    ...
}
```

```swift
// 언어 변경 첫번째
func changeLanguageFirst(_ text: String) {
    switch text {
    case "English":
        UserDefaults.standard.set(["en"], forKey: "Language")
    case "简体中文":
        UserDefaults.standard.set(["zh-Hans"], forKey: "Language")
    case "繁體中文":
        UserDefaults.standard.set(["zh-Hant"], forKey: "Language")
    case "日本語":
        UserDefaults.standard.set(["ja"], forKey: "Language")
    case "Español":
        UserDefaults.standard.set(["es"], forKey: "Language")
    case "Français":
        UserDefaults.standard.set(["fr"], forKey: "Language")
    case "Deutsch":
        UserDefaults.standard.set(["de"], forKey: "Language")
    case "Русский":
        UserDefaults.standard.set(["ru"], forKey: "Language")
    default: break
    }
}

// 언어 변경 두번째
func changeLanguageSecond(_ text: String) {
    switch text {
    case "Português (Brasil)":
        UserDefaults.standard.set(["pt-BR"], forKey: "Language")
    case "Italiano":
        UserDefaults.standard.set(["it"], forKey: "Language")
    case "한국어":
        UserDefaults.standard.set(["ko"], forKey: "Language")
    case "Türkçe":
        UserDefaults.standard.set(["tr"], forKey: "Language")
    case "Nederlands":
        UserDefaults.standard.set(["nl"], forKey: "Language")
    case "ภาษาไทย":
        UserDefaults.standard.set(["th"], forKey: "Language")
    case "Svenska":
        UserDefaults.standard.set(["sv"], forKey: "Language")
    case "Dansk":
        UserDefaults.standard.set(["da"], forKey: "Language")
    default: break
    }
}

// 언어 변경 세번째
func changeLanguageThird(_ text: String) {
    switch text {
    case "Tiếng Việt":
        UserDefaults.standard.set(["vi"], forKey: "Language")
    case "Norsk Bokmål":
        UserDefaults.standard.set(["nb"], forKey: "Language")
    case "Polski":
        UserDefaults.standard.set(["pl"], forKey: "Language")
    case "Suomi":
        UserDefaults.standard.set(["fi"], forKey: "Language")
    case "Bahasa Indonesia":
        UserDefaults.standard.set(["id"], forKey: "Language")
    case "Čeština":
        UserDefaults.standard.set(["cs"], forKey: "Language")
    case "Українська":
        UserDefaults.standard.set(["uk"], forKey: "Language")
    default: break
    }
}
```

<br/>

### 앱 평가
설정의 '앱 평가' 버튼을 통해 App Store 앱페이지로 이동한다.

<br/>

<p align="center"><img src="https://user-images.githubusercontent.com/49383370/152300317-e8fc9497-b8ec-4fa0-8110-100c99f1600b.jpeg"></p>

<br/>

```swift
// 앱 평가 버튼 클릭 시
@IBAction func reviewButtonTapped(_ sender: UIButton) {
    // 스토어 url 열기
    let store = "https://apps.apple.com/kr/app/h-ours/id1605524722"
    if let url = URL(string: store), UIApplication.shared.canOpenURL(url) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
```

<br/>

### 피드백 보내기
설정의 '피드백 보내기' 버튼을 통해서 개발자에게 피드백을 보낼 수 있다.

<br/>

<p align="center"><img src="https://user-images.githubusercontent.com/49383370/152298101-6f4ae3b8-b9c4-4efd-b4c3-df52b07d0c8a.jpeg"></p>

<br/>

MessageUI 프레임워크를 이용하여 Mail 앱으로 이메일 작성 화면을 보여준다.

<br/>

```swift
import MessageUI

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
                         Device Model : \(self.getDeviceIdentifier())
                         Device OS : \(UIDevice.current.systemVersion)
                         App Version : \(self.getCurrentVersion())
                         ----------------------------
                         """

        composeViewController.setToRecipients(["hcolonours.help@gmail.com"])
        composeViewController.setSubject("<h:ours> Feedback")
        composeViewController.setMessageBody(bodyString, isHTML: false)

        self.present(composeViewController, animated: true, completion: nil)
    } else {
//            print("메일 보내기 실패")
        let sendMailErrorAlert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let goAppStoreAction = UIAlertAction(title: goTitle, style: .default) { [weak self] _ in
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
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
}
```

<br/>

<!-- 7. 앱 추적 권한 -->
## 📍 앱 추적 권한
사용자에게 맞춤형 광고를 제공하기 위해서 앱을 처음 설치하고 실행할 때 앱 추적 권한을 요청한다.

<br/>

```swift
import AdSupport
import AppTrackingTransparency

...

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // 앱 추적 권한 요청
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .authorized:           // 허용됨
                        print("Authorized")
                        print("IDFA = \(ASIdentifierManager.shared().advertisingIdentifier)")
                    case .denied:               // 거부됨
                        print("Denied")
                    case .notDetermined:        // 결정되지 않음
                        print("Not Determined")
                    case .restricted:           // 제한됨
                        print("Restricted")
                    @unknown default:           // 알려지지 않음
                        print("Unknow")
                    }
                }
            }
        }

        // AdMob
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
```

<br/>

<!-- 8. Design -->
## Design
### Accent Color
The point color is ```'Veri Peri'```, the color of the year for 2022.

<p align="left"><img width="100" src="https://user-images.githubusercontent.com/49383370/159161578-9fcae8f3-81f2-487a-855d-9b48ebd8d7b9.png"></p>

### App Icon
The shape of a circle made of repeating dots is reminiscent of a clock, and the double dot (:) in the center means the time symbol.

<p align="left"><img width="100" src="https://user-images.githubusercontent.com/49383370/159161637-7f0a4cf0-1434-481f-96e7-f0b9b4e88c98.png"></p>

### UI/UX
<p align="center"><img alt="UI/UX Light Mode" src="https://user-images.githubusercontent.com/49383370/159161762-49967309-34b0-44e0-84d8-e3cdc81fb43f.png"></p>

<br/>

<!-- 9. First time dealing with this -->
## First time dealing with this
- ### Localization
  For the first time, I dealt with Localization for multilingual support, which was an important goal of this app development. It can be implemented in storyboard or code, but in h:ours, it was implemented in code.

  > Blog: https://velog.io/@minji0801/iOS-Swift-다국어-지원

- ### App Tracking Appearncey
  I tried it while developing 'Modakyi', but it didn't work, so I gave it up first, but h:ours solved it. It didn't work because AppDelegate immediately requested the app tracking permission.  I solved it by requesting permission a bit late with ```DispatchQueue.main.asyncAfter(deadline: .now() + 1) {}```.

  > Blog: https://velog.io/@minji0801/iOS-Swift-앱-추적-권한-Alert-띄우기

- ### Figma
  In the initial development of 'Modakyi', only simple icons were created with Figma, but 'h:ours' also produced ```icons, app store thumbnails, and tutorial images```. When I first encountered Figma in 'Modakyi', I didn't know how to operate it well, but the contents of Figma I learned in the 'KDC Introduction to Developing My Own iOS App' lecture I took in December 2021 was helpful.

  <p align="center"><img alt="Figma" src="https://user-images.githubusercontent.com/49383370/153407648-401c8396-a0ab-4820-b258-d56ae9f36b7c.png"></p>

- ### gitignore
  I tried gitignore in the past, but it didn't work, so I passed it on, but I solved it this time. One blog said that gitignore should be applied when creating a project for the first time, but it was applied well even if there was a lot of code and it was committed.

  Now, since I hide the Google key value of Info.plist with gitignore and upload it, there is no longer a warning notification from gitguardian.

  > Blog: https://velog.io/@minji0801/iOS-개발자는-gitignore-어떻게-만드나요

- ### SwiftLint
  SwiftLint learned in the 'Fast Campus iOS App Development with Swift Super Grid Package' lecture was applied to 'h:ours'.

  > Blog: https://velog.io/@minji0801/SwiftLint

<br/>

<!-- 10. Contact -->
## Contact
### App Store
> https://apps.apple.com/kr/app/h-ours/id1605524722

### Notion
> https://midi-dill-147.notion.site/h-ours-4d1c8693f14f417d8676e4d2742aab38

### Gmail
> hcolonours.help@gmail.com

<br/>

<!-- 11.Version History -->
## Version History
### v1.0.0 (2022.1.21)
> - Support Korean and English
> - Provide basic functions

### v1.1.0 (2022.1.23)
> - Support Japanese and Chinese (Simplified, Traditional)
> - D-day calculation error correction (D-day output value is different from normal result)
> - Settings: Add app rating function

### v1.2.0 (2022.1.27)
> - Add App Tracking Permissions and Ads

### v1.3.0 (2022.1.31)
> - Support Spanish, French and German

### v1.3.1 (2022.2.3)
> - Time calculation error correction (correction of the error in which the first operand is initialized when the operation continues after the previous calculation result)
> - Apply SwiftLint

### v1.3.2 (2022.2.9)
> - Fix calculation history error (Fixed an error where the second operand was repeated when creating a formula)


<br/>
<br/>

---

<br/>
<br/>

<!-- Footer -->
<div align="center">
  
  <!-- GitHub Stats -->
  <a href="https://github.com/minji0801"><img src="https://github-readme-stats.vercel.app/api?username=minji0801&show_icons=true&theme=buefy"/></a>
  
  <br/>
  <br/>
  <br/>
  
  <!-- Hit -->
  <a href="https://github.com/minji0801/TimeCalculator"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fminji0801%2FTimeCalculator&count_bg=%236667AB&title_bg=%23555555&icon=github.svg&icon_color=%23E7E7E7&title=hits&edge_flat=false"/></a>
</div>
