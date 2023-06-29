
//
//  ViewController.swift
//  Diary
//
//  Created by 박새별 on 2023/06/22.
//

import UIKit

class DiaryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    lazy var store = Store()
    
    private var diaryList: [Diary] = [Diary]() {
        didSet {
            self.diaryList = self.diaryList.sorted { $0.date < $1.date }
            self.collectionView.reloadData()
            self.store.saveDiaryList(diaryList: diaryList)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurCollectionView()
        if let savedDiaryList = self.store.loadDiaryList() {
            self.diaryList = savedDiaryList
        }
    }
}

// MARK: init
extension DiaryViewController {
    private func configurCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
}

extension DiaryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let diaryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell() }
        let diary = self.diaryList[indexPath.row]
        diaryCell.titleLabel.text = diary.title
        diaryCell.dateLabel.text = DateUtil.dateToStringShortFormat(date: diary.date)
        return diaryCell
    }
}

// MARK: Delegate
extension DiaryViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let diaryDeatilViewController = self.storyboard?.instantiateViewController(identifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        let selectedDiary = self.diaryList[indexPath.row]
        diaryDeatilViewController.diary = selectedDiary
        diaryDeatilViewController.indexPath = indexPath
        diaryDeatilViewController.delegate = self
        self.navigationController?.pushViewController(diaryDeatilViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: Double = 12
        let screenWidth: Double = Double(UIScreen.main.bounds.width)
        let cellWidth: Double = screenWidth / 2 - padding * 2
        return CGSize(width: cellWidth, height: 200)
    }
}

extension DiaryViewController: WriteDiaryViewDelegate {
    func didSelectRegister(diary: Diary) {
        self.diaryList.append(diary)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let writeDiaryViewController = segue.destination as? WriteDiaryViewController {
            writeDiaryViewController.delegate = self
        }
    }
}

extension DiaryViewController: DiaryDetailViewDelegate {
    func deleteDiary(indexPath: IndexPath) {
        self.diaryList.remove(at: indexPath.row)
    }
    
    func updateDiary(indxPath: IndexPath, diary: Diary) {
        self.diaryList[indxPath.row] = diary
    }
}
