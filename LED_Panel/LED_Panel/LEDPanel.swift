//
//  LEDPanel.swift
//  LED_Panel
//
//  Created by 박새별 on 2023/05/11.
//

import UIKit

struct LEDPanel {
    var text: String?
    var textColor: UIColor?
    var backgroundColor: UIColor?
    
    func isValid() -> Bool {
        let defaultText = "Label"
        guard let text, text != defaultText else { return false }
        let textValid: Bool = true
        let textColorValid: Bool = textColor != nil && TextColorDic.values.contains(textColor!)
        let backgroundColorValid: Bool = backgroundColor != nil && BackgroundColorDic.values.contains(backgroundColor!)
        
        return textValid && textColorValid && backgroundColorValid
    }
}

typealias ColorSetting = [String: UIColor]

let TextColorDic: ColorSetting = [
    "TextYellowButton": .yellow,
    "TextPurpleButton": .purple,
    "TextGreenButton": .green
]

let BackgroundColorDic: ColorSetting = [
    "BackgroundBlackButton": .black,
    "BackgroundBlueButton": .blue,
    "BackgroundOrangeButton": .orange
]
