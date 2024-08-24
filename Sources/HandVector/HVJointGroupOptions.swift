//
//  HVJointGroupOptions.swift
//
//
//  Created by xu on 2024/8/16.
//

import ARKit


public enum HVJointOfFinger:Sendable, Equatable {
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
    
//    public var fingers: [HVJointOfFinger] {
//        var baseGroup: [HVJointOfFinger] = []
//        if contains(.thump) {
//            baseGroup.append(.thump)
//        }
//        if contains(.indexFinger) {
//            baseGroup.append(.indexFinger)
//        }
//        if contains(.middleFinger) {
//            baseGroup.append(.middleFinger)
//        }
//        if contains(.ringFinger) {
//            baseGroup.append(.ringFinger)
//        }
//        if contains(.littleFinger) {
//            baseGroup.append(.littleFinger)
//        }
//        if contains(.wristMetacarpal) {
//            baseGroup.append(.wristMetacarpal)
//        }
//        if contains(.foreArm) {
//            baseGroup.append(.foreArm)
//        }
//        return baseGroup
//    }
    public var jointGroupNames: [HandSkeleton.JointName] {
        var jointNames: [HandSkeleton.JointName] = []
        if contains(.thump) {
            jointNames.append(contentsOf: [.thumbKnuckle, .thumbIntermediateBase, .thumbIntermediateTip, .thumbTip])
        }
        if contains(.indexFinger) {
            jointNames.append(contentsOf: [.indexFingerKnuckle, .indexFingerIntermediateBase, .indexFingerIntermediateTip, .indexFingerTip])
        }
        if contains(.middleFinger) {
            jointNames.append(contentsOf: [.middleFingerKnuckle, .middleFingerIntermediateBase, .middleFingerIntermediateTip, .middleFingerTip])
        }
        if contains(.ringFinger) {
            jointNames.append(contentsOf: [.ringFingerKnuckle, .ringFingerIntermediateBase, .ringFingerIntermediateTip, .ringFingerTip])
        }
        if contains(.littleFinger) {
            jointNames.append(contentsOf: [.littleFingerKnuckle, .littleFingerIntermediateBase, .littleFingerIntermediateTip, .littleFingerTip])
        }
        if contains(.wristMetacarpal) {
            jointNames.append(contentsOf: [.wrist, .indexFingerMetacarpal, .middleFingerMetacarpal, .ringFingerMetacarpal, .littleFingerMetacarpal])
        }
        if contains(.foreArm) {
            jointNames.append(contentsOf: [.forearmWrist, .forearmArm])
        }
        return jointNames
    }
}
