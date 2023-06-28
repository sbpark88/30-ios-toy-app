//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 박새별 on 2023/06/22.
//

import UIKit

protocol DiaryDetailViewDelegate: AnyObject {
    func deleteDiary(indexPath: IndexPath)
    func updateDiary(indxPath: IndexPath, diary: Diary)
}

class DiaryDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    var favoriteButton: UIBarButtonItem?
    
    weak var delegate: DiaryDetailViewDelegate?
    
    var diary: Diary?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func tapEditButton(_ sender: UIButton) {
        guard let writeDiaryViewController = self.storyboard?.instantiateViewController(withIdentifier: "WriteDiaryViewController") as? WriteDiaryViewController else { return }
        guard let indexPath = self.indexPath else { return }
        guard let diary = self.diary else { return }
        writeDiaryViewController.diaryEditorMode = .edit(indexPath, diary)
        observe()
        self.navigationController?.pushViewController(writeDiaryViewController, animated: true)
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        guard let indexPath else { return }
        self.delegate?.deleteDiary(indexPath: indexPath)
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
        guard let indexPath = notification.userInfo?["indexPath"] as? IndexPath else { return }
        self.diary = diary
        self.configureView()    // Diary 를 화면에 보여주는 함수
        self.delegate?.updateDiary(indxPath: indexPath, diary: diary)
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
        guard let isFavorite = self.diary?.favorite, let indexPath = self.indexPath else { return }
        self.favoriteButton?.image = isFavorite ? UIImage(systemName: "star") : UIImage(systemName: "star.fill")
        self.diary?.favorite = !isFavorite
        self.delegate?.updateDiary(indxPath: indexPath, diary: self.diary!)
    }
}
