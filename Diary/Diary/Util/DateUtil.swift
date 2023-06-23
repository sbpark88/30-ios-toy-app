//
//  DateUtil.swift
//  Diary
//
//  Created by 박새별 on 2023/06/23.
//

import Foundation

struct DateUtil {

    static let localeKorea = "ko_KR"

    static func generateDateToStringFunction(dateFormat: String) -> (_ date: Date) -> String {
        { date in
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            formatter.locale = Locale(identifier: localeKorea)
            return formatter.string(from: date)
        }
    }

    static func dateToStringShortFormat(date: Date) -> String {
        generateDateToStringFunction(dateFormat: "yy년 MM월 dd일 (EEEEE)")(date)
    }

    static func dateToStringFullFormat(date: Date) -> String {
        generateDateToStringFunction(dateFormat: "yyyy년 MM월 dd일 (EEEEE)")(date)
    }

}
