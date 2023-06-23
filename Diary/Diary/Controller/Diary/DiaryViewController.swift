
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let writeDiaryViewController = segue.destination as? WriteDiaryViewController {
            writeDiaryViewController.delegate = self
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

extension DiaryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: Double = 12
        let screenWidth: Double = Double(UIScreen.main.bounds.width)
        let cellWidth: Double = screenWidth / 2 - padding * 2
        return CGSize(width: cellWidth, height: 200)
    }
}

extension DiaryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell() }
        let diary = self.diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = DateUtil.dateToStringShortFormat(date: diary.date)
        return cell
    }
}

extension DiaryViewController: WriteDiaryViewDelegate {
    func didSelectRegister(diary: Diary) {
        self.diaryList.append(diary)
    }
}

// MARK: Segue to Diary Detail View
extension DiaryViewController: UICollectionViewDelegate, DiaryDetailViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let diaryDeatilViewController = self.storyboard?.instantiateViewController(identifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        let selectedDiary = self.diaryList[indexPath.row]
        diaryDeatilViewController.diary = selectedDiary
        diaryDeatilViewController.indexPath = indexPath
        diaryDeatilViewController.delegate = self
        self.navigationController?.pushViewController(diaryDeatilViewController, animated: true)
    }
    
    func deleteDiary(indexPath: IndexPath) {
        self.diaryList.remove(at: indexPath.row)
    }
}
