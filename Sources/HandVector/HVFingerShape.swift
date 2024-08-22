//
//  HVFingerShape.swift
//  HandVector
//
//  Created by 许同学 on 2024/8/20.
//

import ARKit

public struct HVFingerShape: Sendable, Equatable {
    public enum FingerShapeType: Int {
        case baseCurl = 1
        case tipCurl = 2
        case fullCurl = 4
        case pinch = 8
        case spread = 16
    }
    
    
    let finger: HVJointGroupOptions
    let fingerShapeTypes: Set<HVFingerShape.FingerShapeType>
    
    let fullCurl: Float
    let baseCurl: Float
    let tipCurl: Float
    /// not avalible on thumb
    let pinch: Float?
    /// not avalible on littleFinger
    let spread: Float?
    
//    init(finger: HVJointGroupOptions, fingerShapeTypes: Set<HVFingerShape.FingerShapeType>, fullCurl: Float, baseCurl: Float, tipCurl: Float, pinch: Float?, spread: Float?) {
//        self.finger = finger
//        self.fingerShapeTypes = fingerShapeTypes
//        self.fullCurl = fullCurl
//        self.baseCurl = baseCurl
//        self.tipCurl = tipCurl
//        self.pinch = pinch
//        self.spread = spread
//    }
    init(finger: HVJointGroupOptions, fingerShapeTypes: Set<HVFingerShape.FingerShapeType> = .all, joints: [HandSkeleton.JointName: HVJointInfo]) {
        self.finger = finger
        self.fingerShapeTypes = fingerShapeTypes
        
        func linearInterpolate(min: Float, max: Float, t: Float) -> Float {
            let x = t < min ? min : (t > max ? max : t)
            return (x - min) / (max - min)
        }
        let config = finger.fingerShapeConfiguration
        
        if fingerShapeTypes.contains(.baseCurl), HVJointGroupOptions.fiveFingersAndForeArm.contains(finger) {
            let joint = joints[finger.jointGroupNames.first!]!
            let xAxis = joint.transformToParent.columns.0
            let angle = atan2(xAxis.y, xAxis.x)
            self.baseCurl = linearInterpolate(min: config.minimumBaseCurlDegrees, max: config.maximumBaseCurlDegrees, t: angle / .pi * 180)
            
            print(angle, angle / .pi * 180, baseCurl)
        } else {
            self.baseCurl = 0
        }
        
        if fingerShapeTypes.contains(.tipCurl), HVJointGroupOptions.fiveFingers.contains(finger) {
            let joint1 = joints[finger.jointGroupNames[1]]!
            let xAxis1 = joint1.transformToParent.columns.0
            let angle1 = atan2(xAxis1.y, xAxis1.x)
            let tipCurl1 = linearInterpolate(min: config.minimumTipCurlDegrees1, max: config.maximumTipCurlDegrees1, t: angle1 / .pi * 180)
            
            let joint2 = joints[finger.jointGroupNames[2]]!
            let xAxis2 = joint2.transformToParent.columns.0
            let angle2 = atan2(xAxis2.y, xAxis2.x)
            let tipCurl2 = linearInterpolate(min: config.minimumTipCurlDegrees2, max: config.maximumTipCurlDegrees2, t: angle2 / .pi * 180)
            
            self.tipCurl = (tipCurl1 + tipCurl2)/2
            print(angle1, angle1 / .pi * 180, angle2, angle2 / .pi * 180, tipCurl)
        } else {
            self.tipCurl = 0
        }
        
        fullCurl = 0
        pinch = 0
        spread = 0
    }
    
    static func relatedJointNames(finger: HVJointGroupOptions, type: HVFingerShape.FingerShapeType) -> [HandSkeleton.JointName] {
        var jointNames: [HandSkeleton.JointName] = []
        
        return jointNames
    }
}
fileprivate extension HVFingerShape {
    struct FingerShapeConfiguration {
        var maximumBaseCurlDegrees: Float
        var maximumTipCurlDegrees1: Float
        var maximumTipCurlDegrees2: Float
        var maximumPinchDistance: Float
        var maximumSpreadDegrees: Float
        
        var minimumBaseCurlDegrees: Float
        var minimumTipCurlDegrees1: Float
        var minimumTipCurlDegrees2: Float
        var minimumPinchDistance: Float
        var minimumSpreadDegrees: Float
        
        
        static var thumb: FingerShapeConfiguration {
            return FingerShapeConfiguration(maximumBaseCurlDegrees: 80, maximumTipCurlDegrees1: 80, maximumTipCurlDegrees2: 80, maximumPinchDistance: 0.05, maximumSpreadDegrees: 40, minimumBaseCurlDegrees: -5, minimumTipCurlDegrees1: 0, minimumTipCurlDegrees2: 0, minimumPinchDistance: 0.01, minimumSpreadDegrees: 0)
        }
        static var indexFinger: FingerShapeConfiguration {
            return FingerShapeConfiguration(maximumBaseCurlDegrees: 80, maximumTipCurlDegrees1: 80, maximumTipCurlDegrees2: 80, maximumPinchDistance: 0.05, maximumSpreadDegrees: 40, minimumBaseCurlDegrees: -5, minimumTipCurlDegrees1: 0, minimumTipCurlDegrees2: 0, minimumPinchDistance: 0.01, minimumSpreadDegrees: 0)
        }
        static var middleFinger: FingerShapeConfiguration {
            return FingerShapeConfiguration(maximumBaseCurlDegrees: 80, maximumTipCurlDegrees1: 80, maximumTipCurlDegrees2: 80, maximumPinchDistance: 0.05, maximumSpreadDegrees: 40, minimumBaseCurlDegrees: -5, minimumTipCurlDegrees1: 0, minimumTipCurlDegrees2: 0, minimumPinchDistance: 0.01, minimumSpreadDegrees: 0)
        }
        static var ringFinger: FingerShapeConfiguration {
            return FingerShapeConfiguration(maximumBaseCurlDegrees: 80, maximumTipCurlDegrees1: 80, maximumTipCurlDegrees2: 80, maximumPinchDistance: 0.05, maximumSpreadDegrees: 40, minimumBaseCurlDegrees: -5, minimumTipCurlDegrees1: 0, minimumTipCurlDegrees2: 0, minimumPinchDistance: 0.01, minimumSpreadDegrees: 0)
        }
        static var littleFinger: FingerShapeConfiguration {
            return FingerShapeConfiguration(maximumBaseCurlDegrees: 80, maximumTipCurlDegrees1: 80, maximumTipCurlDegrees2: 80, maximumPinchDistance: 0.05, maximumSpreadDegrees: 40, minimumBaseCurlDegrees: -5, minimumTipCurlDegrees1: 0, minimumTipCurlDegrees2: 0, minimumPinchDistance: 0.01, minimumSpreadDegrees: 0)
        }
        static var foreArm: FingerShapeConfiguration {
            return FingerShapeConfiguration(maximumBaseCurlDegrees: 80, maximumTipCurlDegrees1: 80, maximumTipCurlDegrees2: 80, maximumPinchDistance: 0.05, maximumSpreadDegrees: 40, minimumBaseCurlDegrees: -5, minimumTipCurlDegrees1: 0, minimumTipCurlDegrees2: 0, minimumPinchDistance: 0.01, minimumSpreadDegrees: 0)
        }
    }
}
fileprivate extension HVJointGroupOptions {
    fileprivate var fingerShapeConfiguration: HVFingerShape.FingerShapeConfiguration {
        switch self {
        case .thump:
            return .thumb
        case .indexFinger:
            return .indexFinger
        case .middleFinger:
            return .middleFinger
        case .ringFinger:
            return .ringFinger
        case .littleFinger:
            return .littleFinger
        case .foreArm:
            return .foreArm
        default:
            return .foreArm
        }
    }
}
public extension Set<HVFingerShape.FingerShapeType> {
    public static let all: Set<HVFingerShape.FingerShapeType> = [.baseCurl, .tipCurl, .fullCurl, .pinch, .spread]
}
