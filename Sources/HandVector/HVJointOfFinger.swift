//
//  HVJointOfFinger.swift
//
//
//  Created by xu on 2024/8/16.
//

import ARKit


public enum HVJointOfFinger:Sendable, Equatable, CaseIterable {
    case thumb
    case indexFinger
    case middleFinger
    case ringFinger
    case littleFinger
    case metacarpal
    case forearm
    
    public var jointGroupNames: [HandSkeleton.JointName] {
        switch self {
        case .thumb:
            [.thumbKnuckle, .thumbIntermediateBase, .thumbIntermediateTip, .thumbTip]
        case .indexFinger:
            [.indexFingerKnuckle, .indexFingerIntermediateBase, .indexFingerIntermediateTip, .indexFingerTip]
        case .middleFinger:
            [.middleFingerKnuckle, .middleFingerIntermediateBase, .middleFingerIntermediateTip, .middleFingerTip]
        case .ringFinger:
            [.ringFingerKnuckle, .ringFingerIntermediateBase, .ringFingerIntermediateTip, .ringFingerTip]
        case .littleFinger:
            [.littleFingerKnuckle, .littleFingerIntermediateBase, .littleFingerIntermediateTip, .littleFingerTip]
        case .metacarpal:
            [.indexFingerMetacarpal, .middleFingerMetacarpal, .ringFingerMetacarpal, .littleFingerMetacarpal]
        case .forearm:
            [.forearmWrist, .forearmArm]
        }
    }
}
public extension Set<HVJointOfFinger> {
    
    public static let fiveFingers: Set<HVJointOfFinger> = [.thumb, .indexFinger, .middleFinger, .ringFinger, .littleFinger]
    public static let fiveFingersAndForeArm: Set<HVJointOfFinger> = [.thumb, .indexFinger, .middleFinger, .ringFinger, .littleFinger, .forearm]
    public static let fiveFingersAndWrist: Set<HVJointOfFinger> = [.thumb, .indexFinger, .middleFinger, .ringFinger, .littleFinger, .metacarpal]
    public static let all: Set<HVJointOfFinger> = [.thumb, .indexFinger, .middleFinger, .ringFinger, .littleFinger, .metacarpal, .forearm]
    
    public var jointGroupNames: [HandSkeleton.JointName] {
        var jointNames: [HandSkeleton.JointName] = []
        for finger in HVJointOfFinger.allCases {
            if contains(finger) {
                jointNames.append(contentsOf: finger.jointGroupNames)
            }
        }
        return jointNames
    }
}
