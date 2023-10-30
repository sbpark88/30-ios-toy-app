//
//  ViewController.swift
//  COVID19
//
//  Created by 박새별 on 10/29/23.
//

import UIKit
import DGCharts

class ViewController: UIViewController {

    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    var cityCovidManager = CityCovidManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCityCovidOverview()
    }
    
    func getCityCovidOverview() {
        cityCovidManager.fetchCityCovidOverview { [weak self] result in
            guard let self = self else { return }   // 일시적으로 strong reference 가 되도록 한다.
            switch result {
            case let .success(result):
                debugPrint("Success: \(result)")
            case let .failure(error):
                debugPrint("Error: \(error)")
            }
        }
    }

}
