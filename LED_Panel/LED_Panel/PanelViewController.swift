//
//  ViewController.swift
//  LED_Panel
//
//  Created by 박새별 on 2023/05/09.
//

import UIKit

class PanelViewController: UIViewController {
    
    @IBOutlet weak var contentsLabel: UILabel!
    
    var settingViewControllerDelegate: SettingViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentsLabel.textColor = .yellow
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingViewController = segue.destination as? SettingViewController else { return }
        settingViewController.delegate = self
        if let currentPanel = generateLedPanelDataFromUILabel() {
            if currentPanel.isValid() {
                settingViewController.ledPanel = currentPanel
            }
        }
    }
    
    private func generateLedPanelDataFromUILabel() -> LEDPanel? {
        LEDPanel(text: contentsLabel.text,
                 textColor: contentsLabel.textColor,
                 backgroundColor: view.backgroundColor)
    }
    
}

extension PanelViewController: LEDPanelSettingDelegate {
    func changeContentsLabel(ledPanel: LEDPanel) {
        self.contentsLabel.text = ledPanel.text ?? "Label"
        self.contentsLabel.textColor = ledPanel.textColor
        self.view.backgroundColor = ledPanel.backgroundColor
    }
}
