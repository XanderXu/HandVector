//
//  HandEmojiParameter.swift
//  FingerDance
//
//  Created by 许同学 on 2023/12/24.
//

import RealityFoundation
import ARKit
import HandVector

struct HandEmojiParameter: Codable {
    struct JointInfo: Codable {
        let position: simd_float3
        let name: HandSkeleton.JointName.NameCodingKey
        
        var transform: Transform {
            .init(translation: position)
        }
    }
    let emoji: String
    let left: [JointInfo]?
    let right: [JointInfo]?
    
    static func generateParameters(emoji: String, leftHandVector: HandVectorMatcher?, rightHandVector: HandVectorMatcher?) -> HandEmojiParameter? {
        if leftHandVector == nil, rightHandVector == nil {
            return nil
        }
        let left = leftHandVector?.allPositions.map { (key, value) in
            JointInfo(position: value.position, name: key)
        }
        
        let right = rightHandVector?.allPositions.map { (key, value) in
            JointInfo(position: value.position, name: key)
        }
        return HandEmojiParameter(emoji: emoji, left: left, right: right)
    }
    
    static func generateParameters(fileName: String?) -> HandEmojiParameter? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {return nil}
        do {
            let jsonStr = try String(contentsOfFile: path, encoding: .utf8)
            return jsonStr.toModel(HandEmojiParameter.self)
        } catch {
            print(error)
        }
        return nil
    }
    static func generateParametersDict(fileName: String?) -> [String: HandEmojiParameter]? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {return nil}
        do {
            let jsonStr = try String(contentsOfFile: path, encoding: .utf8)
            return jsonStr.toModel([String: HandEmojiParameter].self)
        } catch {
            print(error)
        }
        return nil
    }
}


extension Encodable {
    func toJson(encoding: String.Encoding = .utf8) -> String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return String(data: data, encoding: encoding)
    }
}
extension String {
    func toModel<T>(_ type: T.Type, using encoding: String.Encoding = .utf8) -> T? where T : Decodable {
        guard let data = self.data(using: encoding) else { return nil }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print(error)
        }
        return nil
    }
}
