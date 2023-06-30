//
//  Store.swift
//  Diary
//
//  Created by 박새별 on 2023/06/23.
//

import Foundation

struct Store {
    
    let userDefaults = UserDefaults.standard
    let prefix = "Diary"
    
    func saveDiaryList(diaryList: [Diary]) {
        let diaryDictionaryList = diaryList.map {
            [
                "id": $0.id,
                "title": $0.title,
                "content": $0.content,
                "date": $0.date,
                "favorite": $0.favorite
            ] as [String : Any]
        }
        self.userDefaults.set(diaryDictionaryList, forKey: "diaryList")
    }
    
    func loadDiaryList() -> [Diary]? {
        guard let diaryDictionaryList = self.userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return nil }
        let diaryList: [Diary] = diaryDictionaryList.compactMap {
            guard let id = $0["id"] as? String,
                  let title = $0["title"] as? String,
                  let content = $0["content"] as? String,
                  let date = $0["date"] as? Date,
                  let favorite = $0["favorite"] as? Bool else { return nil }
            return Diary(id: id, title: title, content: content, date: date, favorite: favorite)
        }.sorted { $0.date < $1.date }
        return diaryList
    }
    
    func updateDiaryList(diary: Diary) {
        guard let oldDiaryList = self.loadDiaryList() else { return }
        let newDiaryList = oldDiaryList.map { $0.id == diary.id ? diary : $0 }
        self.saveDiaryList(diaryList: newDiaryList)
    }
    
    func getLastId() -> String? {
        guard let oldDiaryLst = self.loadDiaryList() else { return nil }
        return oldDiaryLst.max { $0.id < $1.id }?.id
    }
    
    func generateId() -> String {
        if let lastId = getLastId() {
            return prefix + String(format: "%06d", Int(lastId.suffix(lastId.count - 6))! + 1)
        } else {
            return prefix + String(format: "%06d", 1)
        }
    }
}
