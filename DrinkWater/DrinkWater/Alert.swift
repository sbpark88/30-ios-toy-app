//
//  Alert.swift
//  DrinkWater
//
//  Created by 박새별 on 1/29/24.
//

import Foundation

struct Alert: Codable, Identifiable {
    var id: String = UUID().uuidString
    let date: Date
    let isOn: Bool
    
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
