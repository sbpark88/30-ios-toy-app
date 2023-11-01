//
//  CityCovidManager.swift
//  COVID19
//
//  Created by 박새별 on 10/30/23.
//


import UIKit
import Alamofire

protocol CityCovidManagerDelegate {
    func didUpdateCityCovidOverview(_ covid: CovidOverview)
    func didUpdatePieChartView(_ covidByCity: [CovidOverview])
}

typealias fetchCityCovidHandler = (Result<CityCovidOverview, Error>) -> Void

struct CityCovidManager {

    let cityCovidUrl = "https://api.corona-19.kr/korea/country/new/"
    let parameters = [
        "serviceKey": CovidAPI.serviceKey
    ]

    var delegate: CityCovidManagerDelegate?
    
    init(delegate: CityCovidManagerDelegate) {
        self.delegate = delegate
    }

    func fetchCityCovidOverview(completionHandler: @escaping fetchCityCovidHandler) {
        AF.request(cityCovidUrl, method: .get, parameters: parameters)
            .responseData { response in
                switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCovidOverview.self, from: data)
                        completionHandler(.success(result))
                    } catch {
                        completionHandler(.failure(error))
                    }
                case let .failure(error):
                    completionHandler(.failure(error))
                }
            }
    }

}
