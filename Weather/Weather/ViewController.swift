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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        session.dataTask(with: url) { data, response, error in
            if let error {
                print(error)
                return
            }
            guard let data else { return }
            let decoder = JSONDecoder()
            let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data)
            debugPrint(weatherInformation)
        }.resume()
    }

}
