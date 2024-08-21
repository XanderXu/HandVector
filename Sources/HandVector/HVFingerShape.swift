//
//  HVFingerShape.swift
//  HandVector
//
//  Created by 许同学 on 2024/8/20.
//

import ARKit

public struct HVFingerShape: Sendable, Equatable {
    public struct FingerShapeConfiguration {
        public var maximumBaseCurlDegrees: Float
        public var maximumTipCurlDegrees1: Float
        public var maximumTipCurlDegrees2: Float
        public var maximumPinchDistance: Float
        public var maximumSpreadDegrees: Float
        
        public var minimumBaseCurlDegrees: Float
        public var minimumTipCurlDegrees1: Float
        public var minimumTipCurlDegrees2: Float
        public var minimumPinchDistance: Float
        public var minimumSpreadDegrees: Float
        
        
        public static var thumb: FingerShapeConfiguration {
            return FingerShapeConfiguration(maximumBaseCurlDegrees: 80, maximumTipCurlDegrees1: 90, maximumTipCurlDegrees2: 90, maximumPinchDistance: 0.05, maximumSpreadDegrees: 40, minimumBaseCurlDegrees: -5, minimumTipCurlDegrees1: 0, minimumTipCurlDegrees2: 0, minimumPinchDistance: 0.01, minimumSpreadDegrees: 0)
        }
        public static var indexFinger: FingerShapeConfiguration {
            return FingerShapeConfiguration(maximumBaseCurlDegrees: 80, maximumTipCurlDegrees1: 90, maximumTipCurlDegrees2: 90, maximumPinchDistance: 0.05, maximumSpreadDegrees: 40, minimumBaseCurlDegrees: -5, minimumTipCurlDegrees1: 0, minimumTipCurlDegrees2: 0, minimumPinchDistance: 0.01, minimumSpreadDegrees: 0)
        }
    }
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
    
    init(finger: HVJointGroupOptions, fingerShapeTypes: Set<HVFingerShape.FingerShapeType>, fullCurl: Float, baseCurl: Float, tipCurl: Float, pinch: Float?, spread: Float?) {
        self.finger = finger
        self.fingerShapeTypes = fingerShapeTypes
        self.fullCurl = fullCurl
        self.baseCurl = baseCurl
        self.tipCurl = tipCurl
        self.pinch = pinch
        self.spread = spread
    }
    init(finger: HVJointGroupOptions, fingerShapeTypes: Set<HVFingerShape.FingerShapeType> = .all, joints: [HandSkeleton.JointName: HVJointInfo]) {
        self.finger = finger
        self.fingerShapeTypes = fingerShapeTypes
        
        func linearInterpolate(min: Float, max: Float, t: Float) -> Float {
            let x = t < min ? min : (t > max ? max : t)
            return (x - min) / (max - min)
        }
        
        
        if fingerShapeTypes.contains(.baseCurl), HVJointGroupOptions.all.contains(finger) {
            let joint = joints[finger.jointGroupNames.first!]!
            let xAxis = joint.transformToParent.columns.0
            let angle = atan2(xAxis.y, xAxis.x)
            self.baseCurl = linearInterpolate(min: -5, max: 80, t: angle / .pi * 180)
            print(angle,angle / .pi * 180,baseCurl)
        } else {
            self.baseCurl = 0
        }
        tipCurl = 0
        fullCurl = 0
        pinch = 0
        spread = 0
    }
}

public extension Set<HVFingerShape.FingerShapeType> {
    public static let all: Set<HVFingerShape.FingerShapeType> = [.baseCurl, .tipCurl, .fullCurl, .pinch, .spread]
}
