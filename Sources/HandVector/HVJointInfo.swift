//
//  File.swift
//  
//
//  Created by 许同学 on 2024/6/5.
//

import ARKit

public struct HVJointInfo: Sendable, Hashable {
    public let name: HandSkeleton.JointName.NameCodingKey
    public let isTracked: Bool
    public let position: simd_float3
    
    public init(joint: HandSkeleton.Joint) {
        self.name = joint.name.codableName
        self.isTracked = joint.isTracked
        self.position = joint.localPosition
    }
    public init(name: HandSkeleton.JointName.NameCodingKey, isTracked: Bool, position: simd_float3) {
        self.name = name
        self.isTracked = isTracked
        self.position = position
    }
    
    public func reversedChirality() -> HVJointInfo {
        return HVJointInfo(name: name, isTracked: isTracked, position: -position)
    }
}
extension HVJointInfo: CustomStringConvertible, Codable {
    public var description: String {
        return "name: \(name), isTracked: \(isTracked), position: \(position)"
    }
    
    enum CodingKeys: CodingKey {
        case name
        case isTracked
        case position
    }
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<HVJointInfo.CodingKeys> = try decoder.container(keyedBy: HVJointInfo.CodingKeys.self)
        
        self.name = try container.decode(HandSkeleton.JointName.NameCodingKey.self, forKey: HVJointInfo.CodingKeys.name)
        self.isTracked = try container.decodeIfPresent(Bool.self, forKey: HVJointInfo.CodingKeys.isTracked) ?? true
        self.position = try container.decode(simd_float3.self, forKey: HVJointInfo.CodingKeys.position)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<HVJointInfo.CodingKeys> = encoder.container(keyedBy: HVJointInfo.CodingKeys.self)
        
        try container.encode(self.name, forKey: HVJointInfo.CodingKeys.name)
        try container.encode(self.isTracked, forKey: HVJointInfo.CodingKeys.isTracked)
        try container.encode(self.position, forKey: HVJointInfo.CodingKeys.position)
    }
}





public enum HVJointOfFinger: CaseIterable {
    case thump
    case indexFinger
    case middleFinger
    case ringFinger
    case littleFinger
    case wristMetacarpal
    case foreArm
    
    public var jointNames: [HandSkeleton.JointName] {
        switch self {
        case .thump:
            return [.thumbKnuckle, .thumbIntermediateBase, .thumbIntermediateTip, .thumbTip]
        case .indexFinger:
            return [.indexFingerKnuckle, .indexFingerIntermediateBase, .indexFingerIntermediateTip, .indexFingerTip]
        case .middleFinger:
            return [.middleFingerKnuckle, .middleFingerIntermediateBase, .middleFingerIntermediateTip, .middleFingerTip]
        case .ringFinger:
            return [.ringFingerKnuckle, .ringFingerIntermediateBase, .ringFingerIntermediateTip, .ringFingerTip]
        case .littleFinger:
            return [.littleFingerKnuckle, .littleFingerIntermediateBase, .littleFingerIntermediateTip, .littleFingerTip]
        case .wristMetacarpal:
            return [.wrist, .indexFingerMetacarpal, .middleFingerMetacarpal, .ringFingerMetacarpal, .littleFingerMetacarpal]
        case .foreArm:
            return [.forearmWrist, .forearmArm]
        }
    }
    
    public static let allFingers: Set<HVJointOfFinger> = [.thump, .indexFinger, .middleFinger, .ringFinger, .littleFinger]
    public static let allFingersAndWrist: Set<HVJointOfFinger> = [.thump, .indexFinger, .middleFinger, .ringFinger, .littleFinger, .wristMetacarpal]
    public static let allFingersAndWristAndForearm: Set<HVJointOfFinger> = [.thump, .indexFinger, .middleFinger, .ringFinger, .littleFinger, .wristMetacarpal, .foreArm]
}


