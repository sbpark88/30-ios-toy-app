//
//  ViewController.swift
//  Weather
//
//  Created by 박새별 on 10/26/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var weatherStackView: UIStackView!

    let successRange: Range<Int> = (200..<300)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherStackView.isHidden = true
    }

    @IBAction func tapFetchWeatherButton(_ sender: UIButton) {
        if let cityName = cityNameTextField.text {
            getCurrentWeather(cityName: cityName)
            cityNameTextField.endEditing(true)
        }
    }

    func getCurrentWeather(cityName: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=3f413e250242a4ca401bf02c302006cc&lang=kr&units=metric&q=\(cityName)") else {
            return
        }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { [weak self] data, response, error in
            guard let data, error == nil else {
                debugPrint(error!)
                return
            }
            let decoder = JSONDecoder()
            if let response = response as? HTTPURLResponse, self!.successRange.contains(response.statusCode) {
                guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = false
                    self?.configureView(weatherInformaton: weatherInformation)
                }
            } else {
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return}
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
            }
        }.resume()
    }

}

extension ViewController {
    func configureView(weatherInformaton: WeatherInformation) {
        cityNameLabel.text = weatherInformaton.name
        weatherDescriptionLabel.text = weatherInformaton.weather.first?.description
        tempLabel.text = "\(weatherInformaton.temp.temp)℃"
        maxTempLabel.text = "최고 : \(weatherInformaton.temp.maxTemp)℃"
        minTempLabel.text = "최저 : \(weatherInformaton.temp.minTemp)℃"
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
