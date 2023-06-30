//
//  StarViewController.swift
//  Diary
//
//  Created by 박새별 on 2023/06/22.
//

import UIKit

class StarViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    lazy var store = Store()
    
    private var diaryList: [Diary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.diaryList = self.store.loadDiaryList()?.filter({ $0.favorite })
        self.collectionView.reloadData()
    }
    
}

// MARK: init
extension StarViewController {
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
}

extension StarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.diaryList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let starCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StarCell", for: indexPath) as? StarCell,
              let diary = self.diaryList?[indexPath.row]
        else { return UICollectionViewCell() }
        starCell.titleLabel.text = diary.title
        starCell.dateLabel.text = DateUtil.dateToStringShortFormat(date: diary.date)
        return starCell
    }
}

// MARK: Delegate
extension StarViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let diaryDetailViewController = self.storyboard?.instantiateViewController(identifier: "DiaryDetailViewController") as? DiaryDetailViewController,
              let selectedDiary = self.diaryList?[indexPath.row]
        else { return }
        diaryDetailViewController.diary = selectedDiary
        self.navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: Double = 10
        let screenWidth: Double = Double(UIScreen.main.bounds.width)
        let cellWidth: Double = screenWidth - padding * 2
        return CGSize(width: cellWidth, height: 80)
    }
}
