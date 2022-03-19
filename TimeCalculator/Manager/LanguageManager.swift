//
//  LanguageManager.swift
//  TimeCalculator
//
//  Created by 김민지 on 2022/03/19.
//  언어 변경 Manager

import Foundation

enum Language {
    case english, chineseS, chineseT, japanese, spanish, french, german, russian
    case portuguese, italian, korean, turkish, dutch, thai, swedish, danish
    case vietnamese, norwegian, polish, finnish, indonesian, czech, ukrainian

    var code: [String] {
        switch self {
        case .english: return ["en"]
        case .chineseS: return ["zh-Hans"]
        case .chineseT: return ["zh-Hant"]
        case .japanese: return ["ja"]
        case .spanish: return ["es"]
        case .french:  return ["fr"]
        case .german: return ["de"]
        case .russian:  return ["ru"]
        case .portuguese: return ["pt-BR"]
        case .italian: return ["it"]
        case .korean: return ["ko"]
        case .turkish:  return ["tr"]
        case .dutch:  return ["nl"]
        case .thai: return ["th"]
        case .swedish: return ["sv"]
        case .danish: return ["da"]
        case .vietnamese: return ["vi"]
        case .norwegian: return ["nb"]
        case .polish: return ["pl"]
        case .finnish: return ["fi"]
        case .indonesian: return ["id"]
        case .czech: return ["cs"]
        case .ukrainian: return ["uk"]
        }
    }
}

let selectedLanguageKey = "Language"

class LanguageManaer {

    static func currentLanguage() -> String {
        if let storedLanguage = UserDefaults.standard.array(forKey: selectedLanguageKey)?.first as? String {
            return storedLanguage
        } else {
            // 저장된 언어가 없을 때
            let str = String(NSLocale.preferredLanguages[0])
            return String(str.dropLast(3))
        }
    }

    /// 언어 저장하기
    static func applyLanguage(language: Language) {
        UserDefaults.standard.set(language.code, forKey: selectedLanguageKey)
    }
}
