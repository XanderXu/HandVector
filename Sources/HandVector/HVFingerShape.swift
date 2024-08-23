//
//  HVFingerShape.swift
//  HandVector
//
//  Created by 许同学 on 2024/8/20.
//

import ARKit
import SwiftUI
import UIKit
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
        func linearInterpolate(lowerBound: Float, upperBound: Float, x: Float) -> Float {
            let p = (x-lowerBound)/(upperBound-lowerBound)
            return simd_clamp(p, 0, 1)
        }
        
        self.finger = finger
        self.fingerShapeTypes = fingerShapeTypes
        
        var baseCurl: Float = 0
        var tipCurl: Float = 0
        var fullCurl: Float = 0
        var pinch: Float? = nil
        var spread: Float? = nil
        let config = finger.fingerShapeConfiguration
        
        if finger == .thump {
            if fingerShapeTypes.contains(.baseCurl) {
                let joint = joints[finger.jointGroupNames[1]]!
                let xAxis = joint.transformToParent.columns.0
                let angle = atan2(xAxis.y, xAxis.x)
                baseCurl = linearInterpolate(lowerBound: config.minimumBaseCurlDegrees, upperBound: config.maximumBaseCurlDegrees, x: angle / .pi * 180)
                
                print("baseCurl", angle, angle / .pi * 180, baseCurl)
            } else {
                baseCurl = 0
            }
            
            if fingerShapeTypes.contains(.tipCurl) {
                let joint = joints[finger.jointGroupNames[2]]!
                let xAxis = joint.transformToParent.columns.0
                let angle = atan2(xAxis.y, xAxis.x)
                let tipCurl = linearInterpolate(lowerBound: config.minimumTipCurlDegrees1, upperBound: config.maximumTipCurlDegrees1, x: angle / .pi * 180)
                
                print("tipCurl", angle, angle / .pi * 180, tipCurl)
            } else {
                tipCurl = 0
            }
            
            if fingerShapeTypes.contains(.fullCurl) {
                fullCurl = (baseCurl + tipCurl)/2
            }
            
            if fingerShapeTypes.contains(.spread) {
                let joint1 = joints[finger.jointGroupNames[1]]!
                let joint2 = joints[finger.nextNeighbourFinger!.jointGroupNames[0]]!
                let xAxis1 = joint1.transform.columns.0.xyz
                let xAxis2 = joint2.transform.columns.0.xyz
                
                let angle = acos(simd_dot(simd_float3(xAxis1.x, 0, xAxis1.z), simd_float3(xAxis2.x, 0, xAxis2.z)))
                let spread = linearInterpolate(lowerBound: config.minimumSpreadDegrees, upperBound: config.maximumSpreadDegrees, x: angle / .pi * 180)
                
                print("spread", angle, angle / .pi * 180, spread)
            } else {
                spread = nil
            }
        } else {
            if fingerShapeTypes.contains(.baseCurl) {
                let joint = joints[finger.jointGroupNames.first!]!
                let xAxis = joint.transformToParent.columns.0
                let angle = atan2(xAxis.y, xAxis.x)
                baseCurl = linearInterpolate(lowerBound: config.minimumBaseCurlDegrees, upperBound: config.maximumBaseCurlDegrees, x: angle / .pi * 180)
                
                print("baseCurl", angle, angle / .pi * 180, baseCurl)
            } else {
                baseCurl = 0
            }
            
            if fingerShapeTypes.contains(.tipCurl) {
                let joint1 = joints[finger.jointGroupNames[1]]!
                let xAxis1 = joint1.transformToParent.columns.0
                let angle1 = atan2(xAxis1.y, xAxis1.x)
                let tipCurl1 = linearInterpolate(lowerBound: config.minimumTipCurlDegrees1, upperBound: config.maximumTipCurlDegrees1, x: angle1 / .pi * 180)
                
                let joint2 = joints[finger.jointGroupNames[2]]!
                let xAxis2 = joint2.transformToParent.columns.0
                let angle2 = atan2(xAxis2.y, xAxis2.x)
                let tipCurl2 = linearInterpolate(lowerBound: config.minimumTipCurlDegrees2, upperBound: config.maximumTipCurlDegrees2, x: angle2 / .pi * 180)
                
                tipCurl = (tipCurl1 + tipCurl2)/2
                print("tipCurl", angle1, angle1 / .pi * 180, angle2, angle2 / .pi * 180, tipCurl)
            } else {
                tipCurl = 0
            }
            
            if fingerShapeTypes.contains(.fullCurl) {
                fullCurl = (baseCurl + tipCurl)/2
            }
            
            if fingerShapeTypes.contains(.pinch) {
                let joint1 = joints[.thumbTip]!
                let joint2 = joints[finger.jointGroupNames.last!]!
                let distance = simd_distance(joint1.position, joint2.position)
                let pinch = linearInterpolate(lowerBound: config.maximumPinchDistance, upperBound: config.minimumPinchDistance, x: distance)
                
                print("pinch", distance,pinch)
            } else {
                pinch = nil
            }
            
            if fingerShapeTypes.contains(.spread), finger != .littleFinger {
                let joint1 = joints[finger.jointGroupNames[0]]!
                let joint2 = joints[finger.nextNeighbourFinger!.jointGroupNames[0]]!
                let xAxis1 = joint1.transform.columns.0.xyz
                let xAxis2 = joint2.transform.columns.0.xyz
                
                let angle = acos(simd_dot(simd_float3(xAxis1.x, 0, xAxis1.z), simd_float3(xAxis2.x, 0, xAxis2.z)))
                let spread = linearInterpolate(lowerBound: config.minimumSpreadDegrees, upperBound: config.maximumSpreadDegrees, x: angle / .pi * 180)
                
                print("spread", angle, angle / .pi * 180, spread)
            } else {
                spread = nil
            }
            
        }
        self.baseCurl = baseCurl
        self.tipCurl = tipCurl
        self.fullCurl = fullCurl
        self.pinch = pinch
        self.spread = spread
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
            return FingerShapeConfiguration(maximumBaseCurlDegrees: 80, maximumTipCurlDegrees1: 100, maximumTipCurlDegrees2: 70, maximumPinchDistance: 0.05, maximumSpreadDegrees: 40, minimumBaseCurlDegrees: -5, minimumTipCurlDegrees1: 0, minimumTipCurlDegrees2: 0, minimumPinchDistance: 0.01, minimumSpreadDegrees: 0)
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
    
    fileprivate var nextNeighbourFinger: HVJointGroupOptions? {
        switch self {
        case .thump:
            return .indexFinger
        case .indexFinger:
            return .middleFinger
        case .middleFinger:
            return .ringFinger
        case .ringFinger:
            return .littleFinger
        case .littleFinger:
            return nil
        default:
            return nil
        }
    }
}
public extension Set<HVFingerShape.FingerShapeType> {
    public static let all: Set<HVFingerShape.FingerShapeType> = [.baseCurl, .tipCurl, .fullCurl, .pinch, .spread]
}
