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

    var cityCovidManager: CityCovidManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        cityCovidManager = CityCovidManager(delegate: self)
        getCityCovidOverview()
    }

    func getCityCovidOverview() {
        cityCovidManager.fetchCityCovidOverview { [weak self] result in
            guard let self else { return } // 일시적으로 strong reference 가 되도록 한다.
            switch result {
            case let .success(result):
                // AF 는 기본적으로 메인 스레드에서 실행되기 때문에 직접 "DispatchQueue" 를 만들지 않는다.
                didUpdateCityCovidOverview(result.korea)
                didUpdatePieChartView(result.allCities)
            case let .failure(error):
                debugPrint("Error: \(error)명")
            }
        }
    }

}

extension ViewController: CityCovidManagerDelegate {

    func didUpdateCityCovidOverview(_ covid: CovidOverview) {
        totalCaseLabel.text = "\(covid.totalCase)명"
        newCaseLabel.text = "\(covid.newCase)명"
    }

    func didUpdatePieChartView(_ covidByCity: [CovidOverview]) {
        let entries = covidByCity.compactMap { [weak self] overview -> PieChartDataEntry? in
            guard let self else { return nil }
            return PieChartDataEntry(
//                value: Double(overview.newCase.replacingOccurrences(of: ",", with: "")) ?? 0,
                value: convertStringToFormattedDouble(from: overview.newCase),
                label: overview.countryName,
                data: overview
            )
        }
        let dataSet = PieChartDataSet(entries: entries, label: "코로나 발생 현황")
        dataSet.sliceSpace = 1
        dataSet.entryLabelColor = .black
        dataSet.xValuePosition = .outsideSlice
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.3
        dataSet.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.pastel()
            + ChartColorTemplates.material()
        pieChartView.data = PieChartData(dataSet: dataSet)
    }

    func convertStringToFormattedDouble(from str: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: str)?.doubleValue ?? 0
    }

}
