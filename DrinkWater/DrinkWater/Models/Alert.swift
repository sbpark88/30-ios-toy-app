//
//  Alert.swift
//  DrinkWater
//
//  Created by 박새별 on 1/29/24.
//

import Foundation

struct Alert: Codable, Identifiable {
    private(set) var id: String = UUID().uuidString
    let date: Date
    var isOn: Bool = true
    
    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: date)
    }
    
    var meridiem: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a"
        dateFormatter.locale = Locale(identifier: "ko")
        return dateFormatter.string(from: date)
    }
}
