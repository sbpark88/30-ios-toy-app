//
//  CityCovidOverview.swift
//  COVID19
//
//  Created by 박새별 on 10/30/23.
//

import Foundation

struct CityCovidOverview: Codable {
    let korea: CovidOverview
    let seoul: CovidOverview
    let busan: CovidOverview
    let daegu: CovidOverview
    let incheon: CovidOverview
    let gwangju: CovidOverview
    let daejeon: CovidOverview
    let ulsan: CovidOverview
    let sejong: CovidOverview
    let gyeonggi: CovidOverview
    let gangwon: CovidOverview
    let chungbuk: CovidOverview
    let chungnam: CovidOverview
    let jeonbuk: CovidOverview
    let jeonnam: CovidOverview
    let gyeongbuk: CovidOverview
    let gyeongnam: CovidOverview
    let jeju: CovidOverview

    var allCities: [CovidOverview] {
        Mirror(reflecting: self).children.compactMap { $0.value as? CovidOverview }
    }
}

struct CovidOverview: Codable {
    let countryName: String // 시도명
    let newCase: String     // 신규확진환자수(전일대비)
    let totalCase: String   // 확진환자수
    let recovered: String   // 완치자수
    let death: String       // 사망자
    let percentage: String  // 발생률
    let newFcase: String    // 전일대비증감-지역발생
    let newCcase: String    // 전일대비증감-해외유입
}
