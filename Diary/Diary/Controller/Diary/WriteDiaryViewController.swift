//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by 박새별 on 2023/06/22.
//

import UIKit

protocol WriteDiaryViewDelegate: AnyObject {
    func didSelectRegister(diary: Diary)
}

class WriteDiaryViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    lazy var store = Store()
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?
    var diaryEditorMode: DiaryEditorMode = .new
    
    weak var delegate: WriteDiaryViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentTextView()
        self.configureDatePicker()
        self.confirmButton.isEnabled = false
        
        self.setDiaryEditorMode()
        
        // for validator
        self.contentTextView.delegate = self
        self.titleTextField.delegate = self
        self.dateTextField.delegate = self
    }
    
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
        guard let diary = generateDiary() else { return }
        switch self.diaryEditorMode {
        case .new: saveNewDiary(diary: diary)
        case let .edit(oldDiary): editDiary(diary: Diary(id: oldDiary.id,
                                                         title: diary.title,
                                                         content: diary.content,
                                                         date: diary.date,
                                                         favorite: oldDiary.favorite
                                                        ))}
    }
    
    private func saveNewDiary(diary: Diary) {
        self.delegate?.didSelectRegister(diary: diary)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func editDiary(diary: Diary) {
        let diaryEditNotificationPublisher = Notification(
            name: Notification.Name("editDiary"),
            object: diary
        )
        NotificationCenter.default.post(diaryEditNotificationPublisher)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func generateDiary() -> Diary? {
        guard let title = self.titleTextField.text else { return nil }
        guard let content = self.contentTextView.text else { return nil }
        guard let date = self.diaryDate else { return nil }
        return Diary(id: UUID().uuidString, title: title, content: content, date: date)
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
        let selectedDate = datePicker.date
        self.diaryDate = selectedDate
        self.dateTextField.text = DateUtil.dateToStringFullFormat(date: selectedDate)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setDiaryEditorMode() {
        switch self.diaryEditorMode {
        case .new: diaryModeIsNewDiary()
        case let .edit(diary): diaryModeIsEditDiary(diary: diary)
        }
    }
    
    private func diaryModeIsNewDiary() {
        let today = Date()
        self.diaryDate = today
        self.dateTextField.text = DateUtil.dateToStringFullFormat(date: today)
    }
    
    private func diaryModeIsEditDiary(diary: Diary) {
        self.titleTextField.text = diary.title
        self.contentTextView.text = diary.content
        self.diaryDate = diary.date
        self.dateTextField.text = DateUtil.dateToStringFullFormat(date: diary.date)
        self.confirmButton.title = "수정"
    }
}

// MARK: Validator
extension WriteDiaryViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.validateInputData()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.validateInputData()
    }
    
    private func validateInputData() {
        let titleIsDone = !(self.titleTextField.text?.isEmpty ?? true)
        let dateIsDone = !(self.dateTextField.text?.isEmpty ?? true)
        let contentIsDone = !(self.contentTextView.text?.isEmpty ?? true)
        
        self.confirmButton.isEnabled = titleIsDone && dateIsDone && contentIsDone
    }
}
