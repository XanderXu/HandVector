//
//  HandEmojiParameter.swift
//  FingerDance
//
//  Created by 许同学 on 2023/12/24.
//

import RealityFoundation
#if canImport(ARKit)
import ARKit
import simd

//🫶🤲👐🙌👏🙏
//👍👎👊✊🤛🤜🫷🫸🤞✌️🫰🤟🤘👌🤌🤏🫳🫴👈👉👆👇☝️✋🤚🖐️🖖👋🤙🫲🫱🖕✍️🫵
//todo:👍👎🫷🫸🤞🤟🤘🤏🫳🫴🖐️🖖👋🤙🖕
@available(visionOS 1.0, *)
@available(macOS, unavailable)
@available(iOS, unavailable)
public struct HandEmojiParameter: Codable {
    public struct JointInfo: Codable {
        public let position: simd_float3
        public let name: HandSkeleton.JointName.NameCodingKey
        
        @available(iOS 13.0, *)
        public var transform: Transform {
            .init(translation: position)
        }
    }
    public let emoji: String
    public let left: [JointInfo]?
    public let right: [JointInfo]?
    public let handsDistanceLimit: Float?
    
    
    public static func generateParameters(fileName: String?) -> HandEmojiParameter? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {return nil}
        do {
            let jsonStr = try String(contentsOfFile: path, encoding: .utf8)
            return jsonStr.toModel(HandEmojiParameter.self)
        } catch {
            print(error)
        }
        return nil
    }
    public static func generateParametersDict(fileName: String?, bundle: Bundle) -> [String: HandEmojiParameter]? {
        guard let path = bundle.path(forResource: fileName, ofType: "json") else {return nil}
        do {
            let jsonStr = try String(contentsOfFile: path, encoding: .utf8)
            return jsonStr.toModel([String: HandEmojiParameter].self)
        } catch {
            print(error)
        }
        return nil
    }
    
    public func convertToHandVector() -> (left: HandVectorMatcher?, right: HandVectorMatcher?) {
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


#endif
