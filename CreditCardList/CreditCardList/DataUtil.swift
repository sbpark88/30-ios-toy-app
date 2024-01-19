//
//  DataUtil.swift
//  CreditCardList
//
//  Created by 박새별 on 1/18/24.
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
        
        do {
            let data = try toJSON(data)
            return try JSONSerialization.jsonObject(with: data,
                                                    options: .fragmentsAllowed)
        } catch {
            throw error
        }
    }

    func fromJSON<T: Decodable>(_ type: T.Type, from data: Data?) throws -> T {
        guard let data else { throw CastingError.inputIsNil }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 // .millisecondsSince1970 or .secondsSince1970
        
        return try decoder.decode(type, from: data)
    }

    func fromDictionary<T: Decodable>(_ type: T.Type, withJSONObject obj: Any?) throws -> T {
        guard let obj else { throw CastingError.inputIsNil }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: obj,
                                                  options: .fragmentsAllowed)
            
            return try fromJSON(type, from: data)
        } catch {
            throw error
        }
    }
    
}
