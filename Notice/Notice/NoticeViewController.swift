//
//  NoticeViewController.swift
//  Notice
//
//  Created by 박새별 on 1/27/24.
//

import UIKit

class NoticeViewController: UIViewController {
    
    var noticeContents: (title: String, detail: String, date: String)?

    @IBOutlet weak var noticeView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        noticeView.layer.cornerRadius = 6
        view.backgroundColor = .black.withAlphaComponent(0.5)
        
        guard let (title, detail, date) = noticeContents else { return }
        titleLabel.text = title
        detailLabel.text = detail
        dateLabel.text = date
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
