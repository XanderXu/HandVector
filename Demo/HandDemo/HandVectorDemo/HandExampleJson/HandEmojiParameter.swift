//
//  HandEmojiParameter.swift
//  FingerDance
//
//  Created by 许同学 on 2023/12/24.
//

import RealityFoundation
import ARKit

struct HandEmojiParameter: Codable {
    struct JointInfo: Codable {
        let position: simd_float3
        let name: HandSkeleton.JointName.NameCodingKey
        
        var transform: Transform {
            .init(translation: position)
        }
    }
    let name: String
    let left: [JointInfo]?
    let right: [JointInfo]?
    
    
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

