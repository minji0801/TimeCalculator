<div align="center">
  
  <!-- Header -->
  ![header](https://capsule-render.vercel.app/api?type=waving&color=6667AB&height=300&section=header&text=h:ours&desc=시간%20%2F%20디데이%20계산기&descAlignY=60&fontSize=85&fontAlignY=40&fontColor=FFFFFF)
  
  <br/>
  <br/>
  
  <!-- Badge -->
  ![version](https://img.shields.io/badge/v-1.3.1-brightgreen?style=flat-square)
  
  <br/>
  <br/>
  
  ![iOS](https://img.shields.io/badge/iOS-000000?style=flat-square&logo=iOS&logoColor=white)
  ![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white)
  ![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=Firebase&logoColor=black)
  ![Xcode](https://img.shields.io/badge/Xcode-147EFB?style=flat-square&logo=Xcode&logoColor=white)
  ![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=GitHub&logoColor=white)
  ![Figma](https://img.shields.io/badge/Figma-F24E1E?style=flat-square&logo=Figma&logoColor=white)
  [![App Store](https://img.shields.io/badge/App%20Store-0D96F6?style=flat-square&logo=App%20Store&logoColor=white)](https://apps.apple.com/kr/app/h-ours/id1605524722)
  [![Notion](https://img.shields.io/badge/Notion-181717?style=flat-square&logo=Notion&logoColor=white)](https://midi-dill-147.notion.site/h-ours-4d1c8693f14f417d8676e4d2742aab38)
  [![Gmail](https://img.shields.io/badge/Gmail-EA4335?style=flat-square&logo=Gmail&logoColor=white)](https://mail.google.com/mail/?view=cm&amp;fs=1&amp;to=hcolonours@gmail.com)

  <br/>
  <br/>
  <br/>

  h:ours는 시간을 의미하는 hours와 시간을 표시하는 콜론(:)이 합쳐진 단어입니다.

  우리 각자들의 시간을 관리하고 계산하는 데 도움이 되길 바라며 '시간은 우리의 것(hours is ours)'이라는 뜻을 포함하고 있습니다.
</div>

<br/>
<br/>
<br/>

<!-- Navigation -->
# 목차
1. [개발 동기](#-개발-동기)
2. [개발 목표](#-개발-목표)
3. [시간 계산](#-시간-계산)
4. [디데이 계산](#-디데이-계산)
5. [계산 기록](#-계산-기록)
6. [언어 지원](#-언어-지원)
7. [기타](#-기타)
8. [화면 및 디자인](#-화면-및-디자인)
9. [만나러 가기](#-만나러-가기)
10. [버전 기록](#-버전-기록)

<br/>

<!-- 1. 개발 동기 -->
## 🔥 개발 동기
### 1. 시간을 계산하는데 불편함이 있다.
- 매일 플래너에 Total Time을 기록하는데에 있어 시간 계산에 대한 불편함이 있었습니다.
- ‘Hours’ 앱으로 시간을 계산하고 있지만 이와 차별화된 앱을 개발하고 싶었습니다.

### 2. 날짜 계산까지 한 곳에서 할 수 있으면 좋겠다.
- ‘Hours’ 앱은 시간만 계산할 수 있습니다.
- 시간 계산뿐만 아니라 날짜 계산(디데이)도 가능한 앱이 개발하고 싶었습니다.

<br/>

<!-- 2. 개발 목표 -->
## 🎯 개발 목표
### 1. 시간 계산
- 시간 계산이 제일 우선으로, 앱을 켜면 바로 시간을 계산할 수 있습니다.
- 일반 계산기 형태로 시간을 계산합니다. (‘Hours’ 앱과 유사)

### 2. 날짜 계산
- 기준일과 목표일을 사용자가 입력하면 디데이를 계산하여 보여줍니다.
- 기준일과 목표일의 기본값에 오늘 날짜가 입력됩니다.

### 3. 다국어 지원
- 이전에 출시한 'Scoit'은 영어만 지원했고, '모닥이'는 한국어만 지원했습니다.
- 이번에는 현지화를 통해 다양한 나라에서 편하게 이용할 수 있습니다.

<br/>

<!-- 3. 시간 계산 -->
## ⏰ 시간 계산
### 1. 시간 형식 변환

시간 계산에 있어서 "연산자를 클릭할 때 입력한 시간 또는 연산 결과를 올바른 시간 포맷으로 보여줘야 한다" 는 것이 제일 큰 문제였습니다.  
> 예1) 사용자가 3:66를 입력하고 + 를 클릭하면 4:06으로 보여줘야 한다.  
> 
> 예2) 1:50 + 0:25 의 연산 결과는 2:15로 보여줘야 한다.

<br/>
<br/>

따라서, 올바른 시간 형식으로 값을 변환하는 converTimeFormat 메서드를 만들었습니다.

> 입력받은 시간의 분이 60~99 사이라면 분에서 60을 빼고 시에는 1을 더한다.
>
> 연산 기호를 누른 후 반드시 실행되며, 연산 결과가 있다면 그 결과값에 대해서도 적용된다.

```swift
func convertTimeFormat(_ value: [String]) -> String {
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
            return "\(operandHour)\(String(format: "%02d", operandMinute))"
        }
    }
    return value.joined()
}
```

<br/>
<br/>

### 2. 뺄셈과 덧셈

뺄셈 연산은 첫번째 피연산자가 세자리 이상이고, 첫번째 피연산자의 분이 두번째 피연산자의 분보다 작으면 40을 뺍니다.
> ex) 1:05 - 0:30 
> 
> => 105 - 30 - 40 = 35
>   
> => 0:35

<br/>

덧셈 연산의 경우 아래와 같이 연산되는 문제가 있었습니다.
> 0:58 + 0:53 = 1:11 
> 
> (정상적인 연산 결과는 1:51이다.)

이는 입력받은 시간을 String에서 Int형으로 바꾸고 덧셈을 했으니 58 + 53 = 111를 1:11로 올바르게 보여준 것입니다.

<br/>

따라서, 덧셈 연산은 입력받은 두 시간의 분이 모두 두자리이고 분의 합이 100을 넘으면 40을 더합니다.
> ex) 0:58 + 0:53 
> 
> => 58 + 53 + 40 = 151 
> 
> => 1:51 

<br/>
<br/>

### 3. 연산자 연속 클릭 처리
개발 초기에 연산자 버튼을 클릭하면 해당 연산을 바로 실행하도록 구현했는데, 그러면 + 버튼을 클릭했다가 - 버튼을 클릭한 경우에는 에러가 발생했습니다.

그래서 operation 메서드를 따로 만들었고 연산자가 클릭되었을 때 호출합니다.

> displayNumber 값이 있을 때만 연산을 수행한다. (displayNumber는 사용자가 입력한 시간을 숫자형태로 저장하는 String 타입 변수)
>
> 따라서, 연산자 버튼을 연속해서 클릭하더라도 에러가 발생하지 않는다.

```swift
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
```

<br/>

<!-- 4. 디데이 계산 -->
## 📅 디데이 계산

<br/>

<!-- 5. 계산 기록 -->
## 📝 계산 기록
등호(=) 버튼을 클릭했을 때 UserDefaults를 이용해서 계산식을 로컬에 저장합니다.

```swift
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
```

<br/>

단, 올바른 계산식을 만들기 위해서 숫자 버튼을 클릭할 때마다 isClickedOperation 변수를 확인합니다.

숫자 버튼을 눌렀을 때 이미 연산자를 누른적이 있다면(isClickedOperation = true) 계산식을 만들고, 연산자를 누른적은 없지만 등호(=)를 누른적이 있다면(isClickedOperation = false, isClickedEqual = true) 피연산자와 현재 연산자의 값을 초기화합니다.

계산식을 만들 때 주의할 점은 첫번째 피연산자를 가져올 때입니다.

즉, 연산을 제일 처음할 경우인데 두번째 피연산자가 없을 때와 등호(=) 기호를 누른 후에 추가로 연산을 진행할 때만 첫번째 피연산자를 가져오면 됩니다.

```swift
@IBAction func numberButtonTapped(_ sender: UIButton) {
    // 계산식을 올바르게 만들기 위해서
    if self.isClickedOperation {    // 계산 끝난 후 연산자 누르면

        if self.secondOperand.isEmpty || isClickedEqual {
            // 첫번째 피연산자 가져오는 경우 : 두번째 피연산자가 없을 때, = 기호 누른 후 추가로 연산할 때
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

    guard let numberValue = sender.title(for: .normal) else { return }
    if displayNumber.count < 8 {
        self.displayNumber += numberValue
        self.outputLabel.text = updateLabel(displayNumber)
    }
}
```

<br/>

계산이 끝난 후에 사용자가 행할 수 있는 연산의 갈래는 두가지가 있습니다.
> 1) 앞서 계산한 결과에 이어 바로 연산한다.
>
> 2) 바로 숫자를 입력하고 새 연산을 시작한다.

<br/>

<!-- 6. 언어 지원 -->
## 🌐 언어 지원
설정에서 '언어' 버튼을 통해서 언어를 변경할 수 있습니다. 1.3.1 버전 기준으로 총 8개의 언어를 지원하고 있습니다.
<p align="center"><img src="https://user-images.githubusercontent.com/49383370/152671549-b8ddf5c3-cd00-4350-a95b-cf97c7428545.jpeg"></p>

<br/>

<!-- 7. 기타 -->
## 📌 기타
### 다크 모드
설정에서 '다크 모드' 버튼으로 앱의 UI Style을 변경할 수 있습니다.
<p align="center"><img src="https://user-images.githubusercontent.com/49383370/152300020-5cae4abe-4ab4-4473-b604-eb86e3a059d9.jpeg"></p>

UserDefaults를 이용하여 로컬에서 키가 "Dark"인 값을 가져온 후 반대로 저장합니다. 앱의 기본 모드를 Light로 설정했기 때문에 처음에는 무조건 false를 가져옵니다.
```swift
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

viewWillAppear()에서 appearanceCheck 함수가 호출되서 UserDefaults로 로컬에 저장한 값을 기준으로 앱의 Appearance를 변경합니다.

모든 ViewController의 viewWillAppear()에서 appearanceCheck 함수를 호출합니다.

```swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    appearanceCheck(self)
}
```

```swift
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

### 사운드 설정
기본으로 버튼 클릭 시 소리가 나는데, 설정에서 '사운드' 버튼을 통해 소리가 나지 않도록 설정할 수 있습니다. 
<p align="center"><img src="https://user-images.githubusercontent.com/49383370/152310768-25e6b7c8-26dc-4b9e-83d4-de5d5fe38db3.jpeg"></p>

UserDefaluts를 이용해 로컬에서 키가 "SoundOff"인 값을 가져온 후 반대로 저장합니다.

```swift
@IBAction func soundButtonTapped(_ sender: UIButton) {
    let soundOff = UserDefaults.standard.bool(forKey: "SoundOff")
    UserDefaults.standard.set(!soundOff, forKey: "SoundOff")
}
```

그리고 해당 버튼 클릭 시 로컬에 저장된 값을 가져와 그 값에 따라 사운드를 컨트롤합니다.

```swift
@IBAction func buttonPressed(_ sender: Any) {
    let soundOff = UserDefaults.standard.bool(forKey: "SoundOff")
    if !soundOff {
        let systemSoundID: SystemSoundID = 1104
        AudioServicesPlaySystemSound(systemSoundID)
    }
}
```

<br/>

### 앱 평가
설정에서 '앱 평가' 버튼을 통해 App Store의 h:ours 페이지로 이동할 수 있습니다.
<p align="center"><img src="https://user-images.githubusercontent.com/49383370/152300317-e8fc9497-b8ec-4fa0-8110-100c99f1600b.jpeg"></p>

```swift
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
설정에서 '피드백 보내기' 버튼을 통해서 개발자에게 피드백을 보낼 수 있습니다.
<p align="center"><img src="https://user-images.githubusercontent.com/49383370/152298101-6f4ae3b8-b9c4-4efd-b4c3-df52b07d0c8a.jpeg"></p>

MessageUI를 이용해서 Main 앱으로 이메일 작성 화면을 띄웁니다.

```swift
import MessageUI

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
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
}
```

### 앱 추적 권한 요청
사용자에게 맞춤형 광고를 제공하기 위해서 앱을 처음 설치하고 실행할 때 앱 추적 권한을 요청합니다.

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

### IBDesignable
### 튜토리얼 뷰(Pagecontrol)

<br/>

<!-- 8. 화면 및 디자인 -->
## 🌈 화면 및 디자인
### Accent Color
h:ours의 포인트 색상은 팬톤에서 선정한 2022년 올해의 컬러 '베리 페리(Veri Peri)'이다.

<p align="center"><img src="https://user-images.githubusercontent.com/49383370/151350738-ec07e9ac-4de9-4388-9f47-f5584fdabc98.png"></p>

<br/>

### App Icon
- **초기 버전**

  반복되는 점들로 이루어진 원의 형태는 시계의 시점과 분점을 연상하고, 가운데에 위치한 쌍점(:)은 앱 이름(h:ours)에도 사용되었듯이 시간을 표시할 때 사용되는 부호를 의미한다.  

<p align="center"><img width="500" src="https://user-images.githubusercontent.com/49383370/151354559-0966e195-8053-4047-afcd-e73b9e5f1609.png"></p>
  
- **최종 버전**

  두 종류 중에서 포인트 색상을 배경으로 한 아이콘을 채택했다.
  
<p align="center"><img src="https://user-images.githubusercontent.com/49383370/151538320-83cd6eb3-f13e-4fcd-88a4-63ec12723f7d.png"></p>

<br/>

### UI/UX
<p align="center"><img alt="UI/UX Light Mode" src="https://user-images.githubusercontent.com/49383370/151543869-aef6a8d8-d21d-42dd-b26d-b246608767eb.png"></p>
<p align="center"><img alt="UI/UX Dark Mode" src="https://user-images.githubusercontent.com/49383370/151543880-1c3f84cc-89cb-4e89-b6dd-fcb8e63331c6.png"></p>

<br/>

<!-- 9. 만나러 가기 -->
## 👀 만나러 가기
### App Store
> https://apps.apple.com/kr/app/h-ours/id1605524722

### Notion
> https://midi-dill-147.notion.site/h-ours-4d1c8693f14f417d8676e4d2742aab38

### Gmail
> hcolonours.help@gmail.com

<br/>

<!-- 10. 버전 기록 -->
## 🚀 버전 기록
### v1.0.0 (2022. 1. 21)
> - 한국어, 영어 지원
> - 기본 기능 제공(시간 및 디데이 계산, 이전 계산 기록 확인)
> - 설정 : 다크모드, 사운드 설정, 언어 변경, 피드백 보내기

### v1.1.0 (2022. 1. 23)
> - 일본어, 중국어(간체, 번체) 지원
> - 디데이 계산 오류 수정
> - 설정 : 앱 평가 기능 추가

### v1.2.0 (2022. 1. 27)
> - 앱 추적 권한 및 광고 추가

### v1.3.0 (2022. 1. 31)
> - 스페인어, 프랑스어, 독일어 지원

### v1.3.1 (2022. 2. 3)
> - 시간 계산 오류 수정, SwiftLint 적용

<br/>
<br/>

---

<br/>
<br/>
<br/>

<!-- Footer -->
<div align="center">
  <img src="https://github-readme-stats.vercel.app/api?username=minji0801&show_icons=true&theme=material-palenight"/>
  
  <br/>
  <br/>
  <br/>
  
  <img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fminji0801%2FTimeCalculator&count_bg=%236769AB&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)"/>
</div>
