//
//  HandEmojiParameter.swift
//  FingerDance
//
//  Created by 许同学 on 2023/12/24.
//

import RealityFoundation
import ARKit
import simd

//🫶🤲👐🙌👏🙏
//👍👎👊✊🤛🤜🫷🫸🤞✌️🫰🤟🤘👌🤌🤏🫳🫴👈👉👆👇☝️✋🤚🖐️🖖👋🤙🫲🫱🖕✍️🫵
//todo:👍👎🫷🫸🤞🤟🤘🤏🫳🫴🖐️🖖👋🤙🖕
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
    let handsDistanceLimit: Float?
    
    
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
    
    func convertToHandVector() -> (left: HandVectorMatcher?, right: HandVectorMatcher?) {
        var leftVector: HandVectorMatcher?
        if let left {
            var allPositions: [HandSkeleton.JointName.NameCodingKey : HandVectorMatcher.PositionInfo] = [:]
            left.forEach { joint in
                allPositions[joint.name] = HandVectorMatcher.PositionInfo(name: joint.name, isTracked: true, position: joint.position)
            }
            leftVector = HandVectorMatcher(chirality: .left, allPositions: allPositions, transform: .init(1))
        }
        var rightVector: HandVectorMatcher?
        if let right {
            var allPositions: [HandSkeleton.JointName.NameCodingKey : HandVectorMatcher.PositionInfo] = [:]
            right.forEach { joint in
                allPositions[joint.name] = HandVectorMatcher.PositionInfo(name: joint.name, isTracked: true, position: joint.position)
            }
            rightVector = HandVectorMatcher(chirality: .right, allPositions: allPositions, transform: .init(1))
        }
        return (left: leftVector, right: rightVector)
    }
}



