//
//  HVJointGroupOptions.swift
//
//
//  Created by xu on 2024/8/16.
//

import ARKit


public struct HVJointGroupOptions: OptionSet, Hashable {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let thump    = HVJointGroupOptions(rawValue: 1 << 0)
    public static let indexFinger  = HVJointGroupOptions(rawValue: 1 << 1)
    public static let middleFinger   = HVJointGroupOptions(rawValue: 1 << 2)
    public static let ringFinger   = HVJointGroupOptions(rawValue: 1 << 3)
    public static let littleFinger   = HVJointGroupOptions(rawValue: 1 << 4)
    public static let wristMetacarpal   = HVJointGroupOptions(rawValue: 1 << 5)
    public static let foreArm   = HVJointGroupOptions(rawValue: 1 << 6)
    
    
    public static let fiveFingers: HVJointGroupOptions = [.thump, .indexFinger, .middleFinger, .ringFinger, .littleFinger]
    public static let fiveFingersAndForeArm: HVJointGroupOptions = [.thump, .indexFinger, .middleFinger, .ringFinger, .littleFinger, .foreArm]
    public static let fiveFingersAndWrist: HVJointGroupOptions = [.thump, .indexFinger, .middleFinger, .ringFinger, .littleFinger, .wristMetacarpal]
    public static let all: HVJointGroupOptions = [.thump, .indexFinger, .middleFinger, .ringFinger, .littleFinger, .wristMetacarpal, .foreArm]
    
    public var fingerGroups: [HVJointGroupOptions] {
        var baseGroup: [HVJointGroupOptions] = []
        if contains(.thump) {
            baseGroup.append(.thump)
        }
        if contains(.indexFinger) {
            baseGroup.append(.indexFinger)
        }
        if contains(.middleFinger) {
            baseGroup.append(.middleFinger)
        }
        if contains(.ringFinger) {
            baseGroup.append(.ringFinger)
        }
        if contains(.littleFinger) {
            baseGroup.append(.littleFinger)
        }
        if contains(.wristMetacarpal) {
            baseGroup.append(.wristMetacarpal)
        }
        if contains(.foreArm) {
            baseGroup.append(.foreArm)
        }
        return baseGroup
    }
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
