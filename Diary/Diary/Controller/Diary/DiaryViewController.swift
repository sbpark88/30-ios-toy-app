//
//  ViewController.swift
//  Diary
//
//  Created by 박새별 on 2023/06/22.
//

import UIKit

class DiaryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diaryList: [Diary] = [Diary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

