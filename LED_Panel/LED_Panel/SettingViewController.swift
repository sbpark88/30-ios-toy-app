//
//  SettingViewController.swift
//  LED_Panel
//
//  Created by 박새별 on 2023/05/10.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textColorButtons: UIStackView!
    @IBOutlet var backgroundColorButtons: [UIButton]!
    
    var delegate: PanelViewController?
    var ledPanel: LEDPanel! = LEDPanel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeButtonDefaultTitle(buttons: textColorButtons.arrangedSubviews)
        self.removeButtonDefaultTitle(buttons: backgroundColorButtons)
        if let ledPanel {
            setCurrentSetting(ledPanel)
        }
    }
    
    @IBAction func textColorButtonTouch(_ sender: UIButton) {
        textColorButtons.arrangedSubviews.forEach { button in
            button.layer.opacity = button == sender ? 1.0 : 0.2
        }
        guard let textColor = sender.restorationIdentifier?.components(separatedBy: "__").last else { return }
        ledPanel.textColor = TextColorDic[textColor]
    }
    
    @IBAction func backgroundColorButtonTouch(_ sender: UIButton) {
        backgroundColorButtons.forEach { button in
            button.layer.opacity = button == sender ? 1.0 : 0.2
        }
        guard let backgroundColor = sender.accessibilityIdentifier?.components(separatedBy: "__").last else { return }
        ledPanel.backgroundColor = BackgroundColorDic[backgroundColor]
    }
    
    @IBAction func tapSaveButton(_ sender: UIButton) {
        guard let text = textField.text else { return }
        ledPanel.text = text
        if ledPanel.isValid() {
            delegate?.changeContentsLabel(ledPanel: ledPanel)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}


// MARK: Initializer
extension SettingViewController {
    // 버튼 옆 기본 문구 생성되는거 감추기 위한 초기화
    private func removeButtonDefaultTitle(buttons: [UIView]) {
        buttons.forEach {
            guard let button = $0 as? UIButton else { return }
            button.setTitle("", for: .normal)
        }
    }
    
    private func setCurrentSetting(_ ledPanel: LEDPanel) {
        guard ledPanel.isValid() else { return }
        
        // text setting
        textField.text = ledPanel.text
        // text color setting
        let currentTextColorString = TextColorDic.first { $0.value == ledPanel.textColor }?.key
        textColorButtons.arrangedSubviews.first {
            $0.restorationIdentifier?.components(separatedBy: "__").last == currentTextColorString
        }?.layer.opacity = 1.0
        // background color setting
        let currentBackgroundColorString = BackgroundColorDic.first { $0.value == ledPanel.backgroundColor }?.key
        backgroundColorButtons.first {
            $0.accessibilityIdentifier?.components(separatedBy: "__").last == currentBackgroundColorString
        }?.layer.opacity = 1.0
    }
}

protocol LEDPanelSettingDelegate {
    func changeContentsLabel(ledPanel: LEDPanel)
}
