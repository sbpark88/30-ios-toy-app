//
//  Store.swift
//  Diary
//
//  Created by 박새별 on 2023/06/23.
//

import Foundation

struct Store {
    
    let userDefaults = UserDefaults.standard
    
    func saveDiaryList(diaryList: [Diary]) {
        let data = diaryList.map {
            [
                "title": $0.title,
                "content": $0.content,
                "date": $0.date,
                "favorite": $0.favorite
            ] as [String : Any]
        }
        self.userDefaults.set(data, forKey: "diaryList")
    }
    
    func loadDiaryList() -> [Diary]? {
        guard let data = self.userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return nil }
        let diaryList: [Diary] = data.compactMap {
            guard let title = $0["title"] as? String else { return nil }
            guard let content = $0["content"] as? String else { return nil }
            guard let date = $0["date"] as? Date else { return nil }
            guard let favorite = $0["favorite"] as? Bool else { return nil }
            return Diary(title: title, content: content, date: date, favorite: favorite)
        }.sorted { $0.date < $1.date }
        return diaryList
    }
}
