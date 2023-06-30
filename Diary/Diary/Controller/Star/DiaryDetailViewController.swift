//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 박새별 on 2023/06/22.
//

import UIKit

class DiaryDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    var favoriteButton: UIBarButtonItem?
    lazy var store = Store()
    
    var diary: Diary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func tapEditButton(_ sender: UIButton) {
        guard let writeDiaryViewController = self.storyboard?.instantiateViewController(withIdentifier: "WriteDiaryViewController") as? WriteDiaryViewController else { return }
        guard let diary = self.diary else { return }
        writeDiaryViewController.diaryEditorMode = .edit(diary)
        observe()
        self.navigationController?.pushViewController(writeDiaryViewController, animated: true)
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        self.store.deleteDiary(diary: diary!)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func observe() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editDiaryIsDone),
            name: NSNotification.Name("editDiary"),
            object: nil
        )
    }
    
    @objc func editDiaryIsDone(notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        self.diary = diary
        self.configureView()    // Diary 를 화면에 보여주는 함수
        self.store.updateDiary(diary: diary)
    }
}

// MARK: init
extension DiaryDetailViewController {
    private func configureView() {
        guard let diary else { return }
        self.titleLabel.text = diary.title
        self.contentTextView.text = diary.content
        self.dateLabel.text = DateUtil.dateToStringFullFormat(date: diary.date)
        self.favoriteButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapFavoriteButton))
        self.favoriteButton?.image = diary.favorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        self.favoriteButton?.tintColor = .orange
        self.navigationItem.rightBarButtonItem = self.favoriteButton
    }
    
    @objc func tapFavoriteButton() {
        guard let isFavorite = self.diary?.favorite else { return }
        self.favoriteButton?.image = isFavorite ? UIImage(systemName: "star") : UIImage(systemName: "star.fill")
        self.diary?.favorite = !isFavorite
        self.store.updateDiary(diary: diary!)
    }
}
