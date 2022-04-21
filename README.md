<div align="center">
  
  <!-- Header -->
  [![header](https://capsule-render.vercel.app/api?type=waving&color=6667AB&height=250&section=header&text=h:ours&desc=Hours%20%2F%20D-day%20Calculator&descAlignY=55&fontSize=75&fontAlignY=40&fontColor=FFFFFF)](https://github.com/minji0801/TimeCalculator)
  
  h:ours is a combination of ```'hours'``` and a ```colon(:)``` indicating the time.

  Hope this helps in calculating the hours for each of us, and it contains the meaning of ```'hours is ours'```.
  
  <br/>
  
  <!-- Badge -->
  ![version](https://img.shields.io/badge/v-1.4.0-brightgreen?style=flat-square)
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
1. [Motive](#Motive)
2. [Goals](#Goals)
3. [Hours](#Hours)
4. [D-day](#D-day)
5. [Record](#Record)
6. [Settings](#Settings)
7. [Design](#Design)
8. [First time dealing with this](#First-time-dealing-with-this)
9. [Contact](#Contact)
10. [Version History](#Version-History)

<br/>

<!-- 1. Motive -->
## Motive
I write down D-day and total study hours on my daily planner everyday. D-day was counted directly or through a web site, and the total study hours was calculated using the 'Hours' app. Since the 'Hours' app could only count the hours, I made an app that could count up to D-day.

<br/>

<!-- 2. Goals -->
## Goals
- User can calculate hours in the form of a general calculator.
- If user enter the start date and end date, the calculated D-day is displayed.
- Supports languages for use in various countries.

<br/>

<!-- 3. Hours -->
## Hours
This is the first screen you see when you launch the app. Hours can be calculated in the form of a regular calculator. Code is [here](https://github.com/minji0801/TimeCalculator/blob/main/TimeCalculator/CalculatorViewController.swift)

<p align="left"><img width="200" src="https://user-images.githubusercontent.com/49383370/159242720-83dc09fc-bcf2-4ad6-a56e-39bc290efece.png"></p>

- ### Time format conversion
  The biggest problem in hours calculation was to display the entered hours or calculation result in the correct format when clicking the operator.

  > ex)
  >
  >     input : 3:66 +  
  >     output: 4:06
  >     
  >     input : 1:50 + 0:25
  >     output: 2:15

  If the minute of the hour entered is between 60 and 99, subtract 60 from the minute and add 1 to the hour to convert it to the correct time format.
  
  > ex)
  >
  >     input : 3:66 +
  >     convertTimeFormat method is called.
  >     Receives the input time as a [String] type as a parameter. → (["3", "6", "6"])
  >     Since the minute (66) is between 60 and 99, it returns 406, which is the value obtained by subtracting 60 from the minute and adding 1 to the hour.

- ### Addition
  If the minutes of the entered hour are all two digits, and the sum of the minutes exceeds 100, add 40.
 
   > ex)
   >
   >     input : 0:58 + 0:53 =
   >     calculation: 58 + 53 + 40 = 151
   >     output: 1:51
   >     → Since both the minutes (58 and 53) of the entered hour have two digits, and the sum (111) exceeds 100, 40 is added.

- ### Subtraction
   If the first operand has more than three digits and the minute is less than the minute of the second operand, subtract 40.
   
   > ex)
   >
   >     input: 1:05 - 0:30 =
   >     calculation: 105 - 30 - 40 = 35
   >     output: 0:35
   >     → Since the first operand (105) has three digits, and the minute (5) is less than the minute (30) of the second operand,  40 is subtracted.

- ### Operator consecutive clicks
  At first, it was implemented to execute the corresponding operation immediately when the operator button is clicked, but then the problem is when the operator button is clicked consecutively. So, I create an method and call it whenever the operator button is clicked.

  >     The operation is performed only when the displayNumber variable has a value.
  >     (displayNumber is a String type variable that stores the input time as a number)
  >     (i.e. if you enter 2:58, displayNumber is "258")
  >     Therefore, no error occurs even if the operator button is clicked consecutively.

<br/>

<!-- 4. D-day -->
## D-day
Calculate the difference between the start date and the end date using the ```dateComponents``` method of ```Calendar```. Code is [here](https://github.com/minji0801/TimeCalculator/blob/main/TimeCalculator/DdayViewController.swift)

<p align="left"><img width="200" src="https://user-images.githubusercontent.com/49383370/159429974-d018cf99-5856-41bd-aa9d-ef01ca88d79f.png"></p>

If the calculation result is ```0 or negative```, 1 is added after converting the absolute value, and "+" is added in front.

If the calculation result is ```positive```, it is calculated differently depending on whether the start date has been changed. If you change the start date, subtract 1 and add a "-" in front of it. If the start date has not been changed, prefix it with a "-".

The reason for doing this is that the number of days is calculated based on the time from the start date to the end date, and if the start date is not changed, one less day is counted.

> ex)
>
>     start: March 22, 2022 (default)
>     end: March 29, 2022 
>     output: D - 7
>     → Since the calculation result is 7 and the start date has not been changed, add "-" in front of it.
>
>     start: 2022.3.22 (start date changed)
>     end: 2022.3.29 
>     output: D - 7
>     → Since the calculation result is 8 and the start date has been changed, subtract 1 and add "-" in front.
>
>     start: March 22, 2022 
>     end: March 15, 2022
>     output: D + 7
>     → Since the calculation result is -6, it is converted to an absolute value, and 1 is added and a "+" is added in front.

<br/>

<!-- 5. Record -->
## Record
Shows the time calculation result stored in Userdefaults. You can also reset records. Code is [here](https://github.com/minji0801/TimeCalculator/blob/main/TimeCalculator/HistoryViewController.swift)

<p align="left"><img width="200" src="https://user-images.githubusercontent.com/49383370/159430089-1f7c81b7-a261-4ad6-8930-10908e9b7b47.png"></p>

When the equal sign(=) is clicked in the hours calculator, the calculation formula is saved in UserDefaults. However, to make a correct calculation formular, check the ```isClickedOperation``` variable every time a number is clicked. Code is [here](https://github.com/minji0801/TimeCalculator/blob/main/TimeCalculator/CalculatorViewController.swift)

If you have already pressed plus(+) or minus(-) when you press a number ```(isClickedOperation = true)```, create a calculation formula. If you have never pressed plus(+) or minus(-) but have pressed the equal sign(=) ```(isClickedOperation = false, isClickedEqual = true)```, initializes the values of the operands and the current operator.

Also, the first operand get only when there is no second operand and when performing an addition operation after pressing the equal sign(=). And check whether the second operand is inserted into the calculation formula with the ```isAddedFormula``` variable. If click plus(+) or minus(-), initializes the value to false.

If it don't do this, the formula is generated as follows.
>     calculation: 4:36 + 0:35 + 0:21 + 0:22 = 5:54
>     calculation formula: 4:36 + 0:35 + 0:35 + 0:21 + 0:21 + 0:22 = 5:54
<br/>

<!-- 6. Settings -->
## Settings
Various functions such as dark mode, sound settings, language change, app rating, send feedback provided on the setting screen. Code is [here](https://github.com/minji0801/TimeCalculator/blob/main/TimeCalculator/SettingViewController.swift)

<p align="left"><img width="200" src="https://user-images.githubusercontent.com/49383370/159439992-6b17cd6a-306d-489c-911b-bb7c37137652.png"></p>

- ### Dark mode
  The ```appearanceCheck``` function is called in the ```viewWillAppear``` method, and the Appearance of the app is changed by getting the value stored in UserDefaults.

- ### Sound settings
  You can disable the button click sound through the ```'Sound'``` button in the settings. Get the value stored in UserDefaults and play the sound with the ```AVFoundation``` framework.

- ### Change language
  You can change the language of the app through the 'Language' button in Settings. As of version 1.4.0, a total of 11 languages are supported.

  <p align="left"><img width="200" src="https://user-images.githubusercontent.com/49383370/159459341-e76901bc-87d2-4c14-81ef-7d4b8393c469.png"></p>

  When the ```'Language'``` button is clicked, the changeLanguageFirst, changeLanguageSecond, changeLanguageThird methods are called and the value is saved in UserDefaults using ```LanguageManager```. The method is divided into three because it violates ```SwiftLint's cyclic complexity rule```. Code is [here](https://github.com/minji0801/TimeCalculator/blob/main/TimeCalculator/Manager/LanguageManager.swift)

- ### App rating
  Go to the App Store app page through the ```'Rate the App'``` button in Settings and show the review writing screen.

- ### Send feedback
  Using the ```MessageUI``` framework, the Mail app shows the email composing screen.

<br/>

<!-- 7. Design -->
## Design
### Accent Color
The point color is ```'Veri Peri'```, the color of the year for 2022.

<p align="left"><img width="100" src="https://user-images.githubusercontent.com/49383370/159161578-9fcae8f3-81f2-487a-855d-9b48ebd8d7b9.png"></p>

### App Icon
The shape of a circle made of repeating dots is reminiscent of a clock, and the double dot (:) in the center means the time symbol.

<p align="left"><img width="100" src="https://user-images.githubusercontent.com/49383370/159161637-7f0a4cf0-1434-481f-96e7-f0b9b4e88c98.png"></p>

### UI/UX
<p align="center"><img alt="UI/UX Light Mode" src="https://user-images.githubusercontent.com/49383370/159465188-6a642866-968e-48ef-9126-76be44674776.png"></p>

<br/>

<!-- 8. First time dealing with this -->
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

<!-- 9. Contact -->
## Contact
### App Store
> https://apps.apple.com/kr/app/h-ours/id1605524722

### Notion
> https://midi-dill-147.notion.site/h-ours-4d1c8693f14f417d8676e4d2742aab38

### Gmail
> hcolonours.help@gmail.com

<br/>

<!-- 10.Version History -->
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
> - Hours calculation error correction (correction of the error in which the first operand is initialized when the operation continues after the previous calculation result)
> - Apply SwiftLint

### v1.3.2 (2022.2.9)
> - Fix calculation history error (Fixed an error where the second operand was repeated when creating a formula)

### v1.4.0 (2022.3.22)
> - Add Portuguese, Italian, and Vietnamese
> - Correct D-day calculation errors
> - Modify of app evaluation function

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
  
  <!-- Hit -->
  <a href="https://github.com/minji0801/TimeCalculator"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fminji0801%2FTimeCalculator&count_bg=%236667AB&title_bg=%23555555&icon=github.svg&icon_color=%23E7E7E7&title=hits&edge_flat=false"/></a>
</div>
