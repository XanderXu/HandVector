//
//  HVJointOfFinger.swift
//
//
//  Created by xu on 2024/8/16.
//

import ARKit


public enum HVJointOfFinger:Sendable, Equatable, CaseIterable {
    case thump
    case indexFinger
    case middleFinger
    case ringFinger
    case littleFinger
    case wristMetacarpal
    case foreArm
    
    public var jointGroupNames: [HandSkeleton.JointName] {
        switch self {
        case .thump:
            [.thumbKnuckle, .thumbIntermediateBase, .thumbIntermediateTip, .thumbTip]
        case .indexFinger:
            [.indexFingerKnuckle, .indexFingerIntermediateBase, .indexFingerIntermediateTip, .indexFingerTip]
        case .middleFinger:
            [.middleFingerKnuckle, .middleFingerIntermediateBase, .middleFingerIntermediateTip, .middleFingerTip]
        case .ringFinger:
            [.ringFingerKnuckle, .ringFingerIntermediateBase, .ringFingerIntermediateTip, .ringFingerTip]
        case .littleFinger:
            [.littleFingerKnuckle, .littleFingerIntermediateBase, .littleFingerIntermediateTip, .littleFingerTip]
        case .wristMetacarpal:
            [.wrist, .indexFingerMetacarpal, .middleFingerMetacarpal, .ringFingerMetacarpal, .littleFingerMetacarpal]
        case .foreArm:
            [.forearmWrist, .forearmArm]
        }
    }
}
public extension Set<HVJointOfFinger> {
    
    public static let fiveFingers: Set<HVJointOfFinger> = [.thump, .indexFinger, .middleFinger, .ringFinger, .littleFinger]
    public static let fiveFingersAndForeArm: Set<HVJointOfFinger> = [.thump, .indexFinger, .middleFinger, .ringFinger, .littleFinger, .foreArm]
    public static let fiveFingersAndWrist: Set<HVJointOfFinger> = [.thump, .indexFinger, .middleFinger, .ringFinger, .littleFinger, .wristMetacarpal]
    public static let all: Set<HVJointOfFinger> = [.thump, .indexFinger, .middleFinger, .ringFinger, .littleFinger, .wristMetacarpal, .foreArm]
    
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
