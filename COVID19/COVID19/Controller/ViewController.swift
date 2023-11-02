//
//  ViewController.swift
//  COVID19
//
//  Created by 박새별 on 10/29/23.
//

import UIKit
import DGCharts

class ViewController: UIViewController {

    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var cityCovidManager: CityCovidManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        isLoadingNow(true)
        cityCovidManager = CityCovidManager(delegate: self)
        getCityCovidOverview()
    }

    func getCityCovidOverview() {
        cityCovidManager.fetchCityCovidOverview { [weak self] result in
            guard let self else { return } // 일시적으로 strong reference 가 되도록 한다.
            isLoadingNow(false)
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
    
    func isLoadingNow(_ loading: Bool) {
        loading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = !loading
        labelStackView.isHidden = loading
        pieChartView.isHidden = loading
    }

}

extension ViewController: CityCovidManagerDelegate {

    func didUpdateCityCovidOverview(_ covid: CovidOverview) {
        totalCaseLabel.text = "\(covid.totalCase)명"
        newCaseLabel.text = "\(covid.newCase)명"
    }

    func didUpdatePieChartView(_ covidByCity: [CovidOverview]) {
        pieChartView.delegate = self
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

extension ViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let covidDetailViewController = storyboard?.instantiateViewController(identifier: "CovidDetailViewController") as? CovidDetailViewController else { return }
        guard let selectedCityCovidOverview = entry.data as? CovidOverview else { return }
        covidDetailViewController.selectedCityCovidOverview = selectedCityCovidOverview
        navigationController?.pushViewController(covidDetailViewController, animated: true)
    }
    
}
