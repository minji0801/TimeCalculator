<!-- Header -->
<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=6769AB&height=300&section=header&text=h:ours&fontSize=90&fontColor=FFFFFF"/>
</p>
<div align="center"> 시간 & 디데이 계산기 </div>
<br/>
<br/>

<!-- Badge -->
![Generic badge](https://img.shields.io/badge/version-1.1.0-brightgreen)
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

<!-- Navigation -->
# 목차
1. [개발 동기](#-개발-동기)
2. [개발 목표](#-개발-목표)
3. [시간 계산](#-시간-계산)
4. [디데이 계산]
5. [이전 계산 기록]
6. [언어 지원]
7. [그 외 기능]
8. [UI/UX]
9. [Contact]
10. [버전기록]
<br/>

<!-- 1. 개발 동기 -->
## 🔥 개발 동기
**1. 시간을 계산하는데 불편함이 있다.**
- 매일 플래너에 Total Time을 기록하는데에 있어 시간 계산에 대한 불편함이 있다.
- ‘Hours’ 앱을 시간을 계산하고 있지만 이와 차별화된 앱을 개발하고 싶다.

**2. 시간과 더불어 날짜 계산도 한 곳에서 할 수 있으면 편리하겠다.**
- ‘Hours’ 앱은 시간만 계산할 수 있다. 
- 시간 계산뿐만 아니라 날짜 계산(디데이)도 가능한 앱이 출시되면 좋겠다.
<br/>

<!-- 2. 개발 목표 -->
## 🚀 개발 목표
**1. 시간 계산**
- 시간 계산이 제일 우선으로, 앱을 켜면 바로 시간을 계산할 수 있다.
- 일반 계산기 형태로 시간을 계산한다. (‘Hours’ 앱과 유사)

**2. 날짜 계산**
- 기준일과 목표일을 사용자가 입력하면 디데이를 계산하여 보여준다.
- 기준일과 목표일의 기본값에 오늘 날짜가 입력된다.

**3. 다국어 지원**
- 앞서 출시한 'Scoit'은 영어만 지원했고, '모닥이'는 한국어만 지원했다.
- 이번에는 현지화를 통해 다양한 나라에서 편하게 이용할 수 있다.
<br/>

<!-- 3. 시간 계산 -->
## ⏰ 시간 계산
시간을 계산하는 로직이 제일 까다롭고 오래걸렸다.

제일 큰 문제점은 연산자를 클릭할 때 입력한 시간 또는 연산 결과를 올바른 시간 포맷으로 보여줘야 한다는 것이였다.  
> 예1) 사용자가 3:66를 입력하고 + 를 클릭하면 4:06으로 보여줘야 한다.  
> 
> 예2) 1:50 + 0:25 의 연산 결과는 2:15로 보여줘야 한다.
<br/>
<br/>

그래서 올바른 시간 형식으로 변환하는 메서드를 만들었다. 입력받은 시간의 분이 60~99 사이라면 분은 60을 빼고 시는 1 증가시킨다.
converTimeFormat 메서드는 연산 기호를 누른 후 반드시 실행되며, 연산 결과가 있다면 그 결과값에 대해서도 실행된다.
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

뺄셈 연산은 첫번째 피연산자가 세자리 이상이고, 첫번째 피연산자의 분이 두번째 피연산자의 분보다 작으면 40을 뺀다.
> 예) 1:05 - 0:30 => 105 - 30 - 40 = 35 => 0:35
<br/>

덧셈 연산의 경우 아래와 같이 연산되는 문제가 있었다.

이는 입력받은 시간을 String에서 Int형으로 바꾸고 덧셈을 했으니 58 + 53 = 111를 1:11로 올바르게 보여준 것이다.
> 0:58 + 0:53 = 1:11 
> 
> (정상적인 연산 결과는 1:51이다.)
<br/>

덧셈 연산은 입력받은 두 시간의 분이 모두 두자리이고, 분의 합이 100을 넘으면 40을 더하여 해결했다.
> 예) 0:58 + 0:53 => 58 + 53 + 40 = 151 => 1:51 
<br/>


연산자를 눌렀는데 또누르면 에러발생!


## UI/UX
### Main Color
### Icon
###

## Contact
[App Store - h:ours](https://apps.apple.com/kr/app/h-ours/id1605524722)
[Notion]()
[Gmail]()

## 버전기록
### 1.0.0(날짜)
### 1.1.0(날짜)

---

<!-- Footer -->
<p align="center">
  <img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fminji0801%2FTimeCalculator&count_bg=%236769AB&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)"/>
</p>

<p align="center">
  <img src="https://github-readme-stats.vercel.app/api?username=minji0801&show_icons=true&theme=material-palenight"/>
</p>
