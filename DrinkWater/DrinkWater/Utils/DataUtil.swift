//
//  DataUtil.swift
//  DrinkWater
//
//  Created by 박새별 on 1/30/24.
//

import Foundation

struct DataUtil {
    
    enum CastingError: Error {
        case inputIsNil
    }
    
    func toJSON<T: Encodable>(_ data: T?) throws -> Data {
        guard let data else { throw CastingError.inputIsNil }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        return try encoder.encode(data)
    }

    func toDictionary<T: Encodable>(_ data: T?) throws -> Any {
        guard let data else { throw CastingError.inputIsNil }
        
        let jsonData = try toJSON(data)
        return try JSONSerialization.jsonObject(with: jsonData, options: .fragmentsAllowed)
    }
    
    func fromJSON<T: Decodable>(_ type: T.Type, from data: Data?) throws -> T {
        guard let data else { throw CastingError.inputIsNil }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode(type, from: data)
    }

    func fromDictionary<T: Decodable>(_ type: T.Type, withJSONObject obj: Any?) throws -> T {
        guard let obj else { throw CastingError.inputIsNil }
        
        let data = try JSONSerialization.data(withJSONObject: obj, options: .fragmentsAllowed)
        return try fromJSON(type, from: data)
    }
    
    func toUserDefaults<T: Encodable>(_ value: T, forkey: String) throws {
        let encodedValue = try PropertyListEncoder().encode(value)
        UserDefaults.standard.setValue(encodedValue, forKey: forkey)
    }
    
    func fromUserDefaults<T: Decodable>(_ type: T.Type, forkey: String) throws -> T? {
        guard let data = UserDefaults.standard.object(forKey: forkey) as? Data else { return nil }
        return try PropertyListDecoder().decode(type, from: data)
    }
    
}
