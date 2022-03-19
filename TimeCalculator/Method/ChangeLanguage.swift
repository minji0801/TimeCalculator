//
//  SetLanguage.swift
//  TimeCalculator
//
//  Created by 김민지 on 2022/02/02.
//  언어 변경 함수 한 개로 작성했을 시 SwiftLint 순한 복잡도를 위반하기 때문에 세개로 나눔

import Foundation
import UIKit

// 언어 변경 첫번째
func changeLanguageFirst(_ text: String) {
    switch text {
    case "English":
        LanguageManaer.applyLanguage(language: .english)
    case "简体中文":
        LanguageManaer.applyLanguage(language: .chineseS)
    case "繁體中文":
        LanguageManaer.applyLanguage(language: .chineseT)
    case "日本語":
        LanguageManaer.applyLanguage(language: .japanese)
    case "Español":
        LanguageManaer.applyLanguage(language: .spanish)
    case "Français":
        LanguageManaer.applyLanguage(language: .french)
    case "Deutsch":
        LanguageManaer.applyLanguage(language: .german)
    case "Русский":
        LanguageManaer.applyLanguage(language: .russian)
    default: break
    }
}

// 언어 변경 두번째
func changeLanguageSecond(_ text: String) {
    switch text {
    case "Português (Brasil)":
        LanguageManaer.applyLanguage(language: .portuguese)
    case "Italiano":
        LanguageManaer.applyLanguage(language: .italian)
    case "한국어":
        LanguageManaer.applyLanguage(language: .korean)
    case "Türkçe":
        LanguageManaer.applyLanguage(language: .turkish)
    case "Nederlands":
        LanguageManaer.applyLanguage(language: .dutch)
    case "ภาษาไทย":
        LanguageManaer.applyLanguage(language: .thai)
    case "Svenska":
        LanguageManaer.applyLanguage(language: .swedish)
    case "Dansk":
        LanguageManaer.applyLanguage(language: .danish)
    default: break
    }
}

// 언어 변경 세번째
func changeLanguageThird(_ text: String) {
    switch text {
    case "Tiếng Việt":
        LanguageManaer.applyLanguage(language: .vietnamese)
    case "Norsk Bokmål":
        LanguageManaer.applyLanguage(language: .norwegian)
    case "Polski":
        LanguageManaer.applyLanguage(language: .polish)
    case "Suomi":
        LanguageManaer.applyLanguage(language: .finnish)
    case "Bahasa Indonesia":
        LanguageManaer.applyLanguage(language: .indonesian)
    case "Čeština":
        LanguageManaer.applyLanguage(language: .czech)
    case "Українська":
        LanguageManaer.applyLanguage(language: .ukrainian)
    default: break
    }
}
