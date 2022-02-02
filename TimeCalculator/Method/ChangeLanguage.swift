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
