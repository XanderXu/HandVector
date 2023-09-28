//
//  HandAnchor+Extensions.swift
//  HandVector
//
//  Created by xu on 2023/9/28.
//

import Foundation
import simd
import ARKit

extension HandAnchor.Chirality: Codable {
    private var codingKeys: String {
        switch self {
        case .left:
            return "left"
        case .right:
            return "right"
        }
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let nameStr = try container.decode(String.self)
        switch nameStr {
        case "left":
            self = .left
        case "right":
            self = .right
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown Chirality")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.codingKeys)
    }
}

extension HandSkeleton.JointName: Codable {
    private var codingKeys: String {
        switch self {
        case .wrist:
            return "wrist"
        case .thumbKnuckle:
            return "thumbKnuckle"
        case .thumbIntermediateBase:
            return "thumbIntermediateBase"
        case .thumbIntermediateTip:
            return "thumbIntermediateTip"
        case .thumbTip:
            return "thumbTip"
        case .indexFingerMetacarpal:
            return "indexFingerMetacarpal"
        case .indexFingerKnuckle:
            return "indexFingerKnuckle"
        case .indexFingerIntermediateBase:
            return "indexFingerIntermediateBase"
        case .indexFingerIntermediateTip:
            return "indexFingerIntermediateTip"
        case .indexFingerTip:
            return "indexFingerTip"
        case .middleFingerMetacarpal:
            return "middleFingerMetacarpal"
        case .middleFingerKnuckle:
            return "middleFingerKnuckle"
        case .middleFingerIntermediateBase:
            return "middleFingerIntermediateBase"
        case .middleFingerIntermediateTip:
            return "middleFingerIntermediateTip"
        case .middleFingerTip:
            return "middleFingerTip"
        case .ringFingerMetacarpal:
            return "ringFingerMetacarpal"
        case .ringFingerKnuckle:
            return "ringFingerKnuckle"
        case .ringFingerIntermediateBase:
            return "ringFingerIntermediateBase"
        case .ringFingerIntermediateTip:
            return "ringFingerIntermediateTip"
        case .ringFingerTip:
            return "ringFingerTip"
        case .littleFingerMetacarpal:
            return "littleFingerMetacarpal"
        case .littleFingerKnuckle:
            return "littleFingerKnuckle"
        case .littleFingerIntermediateBase:
            return "littleFingerIntermediateBase"
        case .littleFingerIntermediateTip:
            return "littleFingerIntermediateTip"
        case .littleFingerTip:
            return "littleFingerTip"
        case .forearmWrist:
            return "forearmWrist"
        case .forearmArm:
            return "forearmArm"
        @unknown default:
            return self.description
        }
    }
    private static func jointName(from codingKey: String) -> HandSkeleton.JointName? {
        switch codingKey {
        case "wrist":
            return .wrist
        case "thumbKnuckle":
            return .thumbKnuckle
        case "thumbIntermediateBase":
            return .thumbIntermediateBase
        case "thumbIntermediateTip":
            return .thumbIntermediateTip
        case "thumbTip":
            return .thumbTip
        case "indexFingerMetacarpal":
            return .indexFingerMetacarpal
        case "indexFingerKnuckle":
            return .indexFingerKnuckle
        case "indexFingerIntermediateBase":
            return .indexFingerIntermediateBase
        case "indexFingerIntermediateTip":
            return .indexFingerIntermediateTip
        case "indexFingerTip":
            return .indexFingerTip
        case "middleFingerMetacarpal":
            return .middleFingerMetacarpal
        case "middleFingerKnuckle":
            return .middleFingerKnuckle
        case "middleFingerIntermediateBase":
            return .middleFingerIntermediateBase
        case "middleFingerIntermediateTip":
            return .middleFingerIntermediateTip
        case "middleFingerTip":
            return .middleFingerTip
        case "ringFingerMetacarpal":
            return .ringFingerMetacarpal
        case "ringFingerKnuckle":
            return .ringFingerKnuckle
        case "ringFingerIntermediateBase":
            return .ringFingerIntermediateBase
        case "ringFingerIntermediateTip":
            return .ringFingerIntermediateTip
        case "ringFingerTip":
            return .ringFingerTip
        case "littleFingerMetacarpal":
            return .littleFingerMetacarpal
        case "littleFingerKnuckle":
            return .littleFingerKnuckle
        case "littleFingerIntermediateBase":
            return .littleFingerIntermediateBase
        case "littleFingerIntermediateTip":
            return .littleFingerIntermediateTip
        case "littleFingerTip":
            return .littleFingerTip
        case "forearmWrist":
            return .forearmWrist
        case "forearmArm":
            return .forearmArm
        default:
            return nil
        }
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let nameStr = try container.decode(String.self)
        if let jn = Self.jointName(from: nameStr) {
            self = jn
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown JointName:\(nameStr)")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.codingKeys)
    }
}
