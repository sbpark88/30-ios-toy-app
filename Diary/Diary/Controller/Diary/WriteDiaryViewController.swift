//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by 박새별 on 2023/06/22.
//

import UIKit

class WriteDiaryViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentTextView()
        self.configureDatePicker()
        self.confirmButton.isEnabled = false
        
        // MARK: for validator
        self.contentTextView.delegate = self
        self.titleTextField.delegate = self
        self.dateTextField.delegate = self
    }
    
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
    }
}

// MARK: init
extension WriteDiaryViewController {
    private func configureContentTextView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.contentTextView.layer.borderColor = borderColor.cgColor
        self.contentTextView.layer.borderWidth = 0.5
        self.contentTextView.layer.cornerRadius = 5.0
    }
    
    private func configureDatePicker() {
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange), for: .valueChanged)
        self.datePicker.locale = Locale(identifier: "ko_KR")
        self.dateTextField.inputView = self.datePicker
    }
    
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy 년 MM 월 dd 일 (EEEEE)" // 2023년 06월 22일 (목)
        formatter.locale = Locale(identifier: "ko_KR")
        self.diaryDate = datePicker.date
        self.dateTextField.text = formatter.string(from: datePicker.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: Adopt protocol for 'titleTextField', 'dateTextField' delegate
extension WriteDiaryViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.validateInputData()
    }
}


// MARK: Adopt protocol for 'contentTextView' delegate
extension WriteDiaryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.validateInputData()
    }
}

// MARK: Validator
extension WriteDiaryViewController {
    private func validateInputData() {
        let titleIsDone = !(self.titleTextField.text?.isEmpty ?? true)
        let dateIsDone = !(self.dateTextField.text?.isEmpty ?? true)
        let contentIsDone = !(self.contentTextView.text?.isEmpty ?? true)

        self.confirmButton.isEnabled = titleIsDone && dateIsDone && contentIsDone
    }
}