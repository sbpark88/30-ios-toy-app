//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 박새별 on 2023/06/22.
//

import UIKit

protocol DiaryDetailViewDelegate: AnyObject {
    func deleteDiary(indexPath: IndexPath)
}

class DiaryDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    weak var delegate: DiaryDetailViewDelegate?
    
    var diary: Diary?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }

    @IBAction func tapEditButton(_ sender: UIButton) {
    }
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        guard let indexPath else { return }
        self.delegate?.deleteDiary(indexPath: indexPath)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension DiaryDetailViewController {
    private func configureView() {
        guard let diary else { return }
        self.titleLabel.text = diary.title
        self.contentTextView.text = diary.content
        self.dateLabel.text = DateUtil.dateToStringFullFormat(date: diary.date)
    }
}
