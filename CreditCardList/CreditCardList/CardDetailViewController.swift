//
//  CardDetailViewController.swift
//  CreditCardList
//
//  Created by 박새별 on 1/9/24.
//

import UIKit
import Lottie

class CardDetailViewController: UIViewController {
    
    var promotionDetail: PromotionDetail?
    
    @IBOutlet weak var lottieView: LottieAnimationView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var periodLabel: UILabel!
    @IBOutlet private weak var conditionLabel: UILabel!
    @IBOutlet private weak var benfitConditionLabel: UILabel!
    @IBOutlet private weak var benfitDetailLabel: UILabel!
    @IBOutlet private weak var benfitDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationView = LottieAnimationView(name: "money")
        lottieView.contentMode = .scaleAspectFit
        lottieView.addSubview(animationView)
        lottieView.frame = lottieView.bounds
        animationView.loopMode = .loop
        animationView.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let promotionDetail else { return }
        titleLabel.text = """
            \(promotionDetail)카드 쓰면
            \(promotionDetail)만원을 드려요
            """
        periodLabel.text = promotionDetail.period
        conditionLabel.text = promotionDetail.condition
        benfitConditionLabel.text = promotionDetail.benefitCondition
        benfitDetailLabel.text = promotionDetail.benefitDate
        benfitDateLabel.text = promotionDetail.benefitDate
    }
    
}
