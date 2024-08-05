//
//  File.swift
//  
//
//  Created by 许同学 on 2024/6/5.
//

import ARKit

public struct HVJointInfo: Sendable, Hashable, Codable {
    public let name: HandSkeleton.JointName.NameCodingKey
    public let isTracked: Bool
    public let transformArray: [SIMD4<Float>]
    
    /// The position of the joint to the hand anchor coordinate system.
    public var position: simd_float3 {
        return transformArray[3].xyz
    }
    /// The transform from the joint to the hand anchor coordinate system.
    public var transfrom: simd_float4x4 {
        return simd_float4x4.init(transformArray[0], transformArray[1], transformArray[2], transformArray[3])
    }
    public init(joint: HandSkeleton.Joint) {
        self.name = joint.name.codableName
        self.isTracked = joint.isTracked
        self.transformArray = [joint.anchorFromJointTransform.columns.0,
                                         joint.anchorFromJointTransform.columns.1,
                                         joint.anchorFromJointTransform.columns.2,
                                         joint.anchorFromJointTransform.columns.3]
    }
    public init(name: HandSkeleton.JointName.NameCodingKey, isTracked: Bool, transformArray: [SIMD4<Float>]) {
        self.name = name
        self.isTracked = isTracked
        self.transformArray = transformArray
    }
    public init(name: HandSkeleton.JointName.NameCodingKey, isTracked: Bool, anchorFromJointTransform: simd_float4x4) {
        self.name = name
        self.isTracked = isTracked
        self.transformArray = [anchorFromJointTransform.columns.0,
                               anchorFromJointTransform.columns.1,
                               anchorFromJointTransform.columns.2,
                               anchorFromJointTransform.columns.3]
    }
    
    public func reversedChirality() -> HVJointInfo {
        let anchorTransfrom = [transformArray[0],
                               transformArray[1],
                               transformArray[2],
                               SIMD4<Float>(-transformArray[3].xyz, 1)]
        return HVJointInfo(name: name, isTracked: isTracked, transformArray: anchorTransfrom)
    }
}
extension HVJointInfo: CustomStringConvertible {
    public var description: String {
        return "name: \(name), isTracked: \(isTracked), position: \(position)"
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


