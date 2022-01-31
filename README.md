<!-- Header -->
<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=6667AB&height=300&section=header&text=h:ours&desc=Time%20and%20D-day%20Calculator&descAlignY=60&fontSize=85&fontAlignY=40&fontColor=FFFFFF"/>
</p>
<br/>
<br/>
<br/>

<!-- Badge -->
![Generic badge](https://img.shields.io/badge/version-1.3.0-brightgreen)
![Generic badge](https://img.shields.io/badge/platform-iOS-lightgrey)
![Generic badge](https://img.shields.io/badge/language-Swift-orange)
![Generic badge](https://img.shields.io/badge/database-Firebase-blue)
![Generic badge](https://img.shields.io/badge/tool-Xcode-blue)
![Generic badge](https://img.shields.io/badge/tool-Github-lightgrey)
![Generic badge](https://img.shields.io/badge/tool-Notion-lightgrey)
![Generic badge](https://img.shields.io/badge/tool-Figma-orange)
[![Generic badge](https://img.shields.io/badge/contact-App%20Store-blue)](https://apps.apple.com/kr/app/h-ours/id1605524722)
[![Generic badge](https://img.shields.io/badge/contact-Gmail-red)](https://mail.google.com/mail/?view=cm&amp;fs=1&amp;to=hcolonours@gmail.com)
<br/>
<br/>
<br/>
<br/>
<br/>

h:ours 네이밍한 설명
<br/>
<br/>

<!-- Navigation -->
# 목차
0. [실행하기 전](#-실행하기-전)
1. [개발 동기](#-개발-동기)
2. [개발 목표](#-개발-목표)
3. [시간 계산](#-시간-계산)
4. [디데이 계산](#-디데이-계산)
5. [계산 기록](#-계산-기록)
6. [언어 지원](#-언어-지원)
7. [그 외 기능](#-그-외-기능)
8. [화면 및 디자인](#-화면-및-디자인)
9. [만나러 가기](#-만나러-가기)
10. [버전 기록](#-버전-기록)
<br/>

<!-- 0. 실행하기 전 -->
## 🛠 실행하기 전
### Cocoapods
```
pod 'Google-Mobile-Ads-SDK'
```
<br/>


<!-- 1. 개발 동기 -->
## 🔥 개발 동기
### 1. 시간을 계산하는데 불편함이 있다.
- 매일 플래너에 Total Time을 기록하는데에 있어 시간 계산에 대한 불편함이 있다.
- ‘Hours’ 앱을 시간을 계산하고 있지만 이와 차별화된 앱을 개발하고 싶다.

### 2. 시간과 더불어 날짜 계산도 한 곳에서 할 수 있으면 편리하겠다.
- ‘Hours’ 앱은 시간만 계산할 수 있다. 
- 시간 계산뿐만 아니라 날짜 계산(디데이)도 가능한 앱이 출시되면 좋겠다.
<br/>

<!-- 2. 개발 목표 -->
## 🎯 개발 목표
### 1. 시간 계산
- 시간 계산이 제일 우선으로, 앱을 켜면 바로 시간을 계산할 수 있다.
- 일반 계산기 형태로 시간을 계산한다. (‘Hours’ 앱과 유사)

### 2. 날짜 계산
- 기준일과 목표일을 사용자가 입력하면 디데이를 계산하여 보여준다.
- 기준일과 목표일의 기본값에 오늘 날짜가 입력된다.

### 3. 다국어 지원
- 앞서 출시한 'Scoit'은 영어만 지원했고, '모닥이'는 한국어만 지원했다.
- 이번에는 현지화를 통해 다양한 나라에서 편하게 이용할 수 있다.
<br/>

<!-- 3. 시간 계산 -->
## ⏰ 시간 계산
### 1. 시간 형식 변환

시간 계산에 있어서 "연산자를 클릭할 때 입력한 시간 또는 연산 결과를 올바른 시간 포맷으로 보여줘야 한다" 는 것이 제일 큰 문제였다.  
> 예1) 사용자가 3:66를 입력하고 + 를 클릭하면 4:06으로 보여줘야 한다.  
> 
> 예2) 1:50 + 0:25 의 연산 결과는 2:15로 보여줘야 한다.
<br/>
<br/>

따라서, 올바른 시간 형식으로 값을 변환하는 converTimeFormat 메서드를 만들었다.

converTimeFormat 메서드는 입력받은 시간의 분이 60~99 사이라면 분에서 60을 빼고 시에는 1을 더한다.

이 메서드는 연산 기호를 누른 후 반드시 실행되며, 연산 결과가 있다면 그 결과값에 대해서도 적용된다.

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

뺄셈 연산은 첫번째 피연산자가 세자리 이상이고, 첫번째 피연산자의 분이 두번째 피연산자의 분보다 작으면 40을 뺀다.
> ex) 1:05 - 0:30 
> 
> => 105 - 30 - 40 = 35
>   
> => 0:35
<br/>

덧셈 연산의 경우 아래와 같이 연산되는 문제가 있었다.
> 0:58 + 0:53 = 1:11 
> 
> (정상적인 연산 결과는 1:51이다.)

이는 입력받은 시간을 String에서 Int형으로 바꾸고 덧셈을 했으니 58 + 53 = 111를 1:11로 올바르게 보여준 것이다.
<br/>

따라서, 입력받은 두 시간의 분이 모두 두자리이고 분의 합이 100을 넘으면 40을 더한다.
> ex) 0:58 + 0:53 
> 
> => 58 + 53 + 40 = 151 
> 
> => 1:51 
<br/>
<br/>

### 3. 연산자 연속 클릭 처리
처음에는 연산자 버튼을 클릭하면 해당 연산을 바로 실행하도록 구현했으나, 사용자가 실수로 + 버튼을 클릭했다가 - 버튼을 클릭한 경우에는 에러가 발생한다.

그래서 operation 메서드를 따로 만들었고 연산자가 클릭되었을 때 실행된다.

이 메서드에서 displayNumber 값이 있을 때만 연산을 수행한다. (displayNumber는 사용자가 입력한 시간을 숫자형태로 저장하는 String 타입 변수)

따라서, 연산자 버튼을 연속해서 클릭하더라도 에러가 발생하지 않는다.

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
등호(=) 버튼을 클릭했을 때 UserDefaults를 이용해서 계산식을 로컬에 저장한다.

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

단, 올바른 계산식을 만들기 위해서 숫자 버튼을 클릭할 때마다 isClickedOperation 변수를 확인한다.

숫자 버튼을 눌렀을 때 이미 연산자를 누른적이 있다면(isClickedOperation = true) 계산식을 만들고, 연산자를 누른적은 없지만 등호(=)를 누른적이 있다면(isClickedOperation = false, isClickedEqual = true) 피연산자와 현재 연산자의 값을 초기화시킨다.

계산식을 만들 때 주의할 점은 첫번째 피연산자를 가져올 때이다.

즉, 연산을 제일 처음할 경우인데 두번째 피연산자가 없을 때와 등호(=) 기호를 누른 후에 추가로 연산을 진행할 때만 첫번째 피연산자를 가져오면 된다.

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

계산이 끝난 후에 사용자가 행할 수 있는 연산의 갈래는 두가지가 있다.
> 1) 앞서 계산한 결과에 이어 바로 연산한다.
>
> 2) 바로 숫자를 입력하고 새 연산을 시작한다.
<br/>

<!-- 6. 언어 지원 -->
## 🌐 언어 지원
<br/>

<!-- 7. 그 외 기능 -->
## 📌 그 외 기능
### 다크모드
### 사운드 설정
### 앱 평가
### 피드백 보내기
### 앱 추적 권한 요청
### IBDesignable
### 튜토리얼 뷰(Pagecontrol)
<br/>

<!-- 8. 화면 및 디자인 -->
## 🌈 화면 및 디자인
### Accent Color
h:ours의 포인트 색상은 팬톤에서 선정한 2022년 올해의 컬러 '베리 페리(Veri Peri)'이다.

<p align="center"><img src="https://user-images.githubusercontent.com/49383370/151350738-ec07e9ac-4de9-4388-9f47-f5584fdabc98.png"><p/>
<br/>

### App Icon
- **초기 버전**

  반복되는 점들로 이루어진 원의 형태는 시계의 시점과 분점을 연상하고, 가운데에 위치한 쌍점(:)은 앱 이름(h:ours)에도 사용되었듯이 시간을 표시할 때 사용되는 부호를 의미한다.  

<p align="center"><img width="500" src="https://user-images.githubusercontent.com/49383370/151354559-0966e195-8053-4047-afcd-e73b9e5f1609.png"><p/>
  
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
<br/>
<br/>

---
<br/>
<br/>
<br/>

<!-- Footer -->
<p align="center"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fminji0801%2FTimeCalculator&count_bg=%236769AB&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)"/></p>

<p align="center"><img src="https://github-readme-stats.vercel.app/api?username=minji0801&show_icons=true&theme=material-palenight"/></p>
