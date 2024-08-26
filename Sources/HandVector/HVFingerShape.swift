//
//  HVFingerShape.swift
//  HandVector
//
//  Created by 许同学 on 2024/8/20.
//

import ARKit

public struct HVFingerShape: Sendable, Equatable {
    public enum FingerShapeType: Int, Sendable, Equatable, CaseIterable {
        case baseCurl = 1
        case tipCurl = 2
        case fullCurl = 4
        case pinch = 8
        case spread = 16
    }
    
    
    let finger: HVJointOfFinger
    let fingerShapeTypes: Set<HVFingerShape.FingerShapeType>
    
    let fullCurl: Float
    let baseCurl: Float
    let tipCurl: Float
    /// not avalible on thumb
    let pinch: Float?
    /// not avalible on littleFinger
    let spread: Float?
    
    
    init(finger: HVJointOfFinger, fingerShapeType: HVFingerShape.FingerShapeType, joints: [HandSkeleton.JointName: HVJointInfo]) {
        self.init(finger: finger, fingerShapeTypes: [fingerShapeType], joints: joints)
    }
    init(finger: HVJointOfFinger, fingerShapeTypes: Set<HVFingerShape.FingerShapeType> = .all, joints: [HandSkeleton.JointName: HVJointInfo]) {
        func linearInterpolate(lowerBound: Float, upperBound: Float, value: Float, clamp: Bool = true) -> Float {
            let p = (value-lowerBound)/(upperBound-lowerBound)
            if clamp {
                return simd_clamp(p, 0, 1)
            } else {
                return p
            }
        }
        
        self.finger = finger
        self.fingerShapeTypes = fingerShapeTypes
        
        var baseCurl: Float = 0
        var tipCurl: Float = 0
        var fullCurl: Float = 0
        var pinch: Float? = nil
        var spread: Float? = nil
        let config = finger.fingerShapeConfiguration
        
        if finger == .thumb {
            if fingerShapeTypes.contains(.baseCurl) {
                let joint = joints[finger.jointGroupNames[1]]!
                let xAxis = joint.transformToParent.columns.0
                let angle = atan2(xAxis.y, xAxis.x) / .pi * 180
                baseCurl = linearInterpolate(lowerBound: config.minimumBaseCurlDegrees, upperBound: config.maximumBaseCurlDegrees, value: angle)
                
//                print("baseCurl", angle, baseCurl)
            } else {
                baseCurl = 0
            }
            
            if fingerShapeTypes.contains(.tipCurl) {
                let joint = joints[finger.jointGroupNames[2]]!
                let xAxis = joint.transformToParent.columns.0
                let angle = atan2(xAxis.y, xAxis.x) / .pi * 180
                let tipCurl = linearInterpolate(lowerBound: config.minimumTipCurlDegrees1, upperBound: config.maximumTipCurlDegrees1, value: angle)
                
//                print("tipCurl", angle, tipCurl)
            } else {
                tipCurl = 0
            }
            
            if fingerShapeTypes.contains(.fullCurl) {
                fullCurl = (baseCurl + tipCurl)/2
            }
            
            if fingerShapeTypes.contains(.spread) {
                let joint = joints[finger.jointGroupNames[1]]!
                let xAxis = joint.transform.columns.0
                
                let angle = -atan2(xAxis.z, xAxis.x) / .pi * 180
                let spread = linearInterpolate(lowerBound: config.minimumSpreadDegrees, upperBound: config.maximumSpreadDegrees, value: angle)
                
//                print("spread", angle, spread)
            } else {
                spread = nil
            }
        } else {
            if fingerShapeTypes.contains(.baseCurl) {
                let joint = joints[finger.jointGroupNames.first!]!
                let xAxis = joint.transformToParent.columns.0
                let angle = atan2(xAxis.y, xAxis.x) / .pi * 180
                baseCurl = linearInterpolate(lowerBound: config.minimumBaseCurlDegrees, upperBound: config.maximumBaseCurlDegrees, value: angle)
                
//                print("baseCurl", angle, baseCurl)
            } else {
                baseCurl = 0
            }
            
            if fingerShapeTypes.contains(.tipCurl) {
                let joint1 = joints[finger.jointGroupNames[1]]!
                let xAxis1 = joint1.transformToParent.columns.0
                let angle1 = atan2(xAxis1.y, xAxis1.x) / .pi * 180
                let tipCurl1 = linearInterpolate(lowerBound: config.minimumTipCurlDegrees1, upperBound: config.maximumTipCurlDegrees1, value: angle1)
                
                let joint2 = joints[finger.jointGroupNames[2]]!
                let xAxis2 = joint2.transformToParent.columns.0
                let angle2 = atan2(xAxis2.y, xAxis2.x) / .pi * 180
                let tipCurl2 = linearInterpolate(lowerBound: config.minimumTipCurlDegrees2, upperBound: config.maximumTipCurlDegrees2, value: angle2)
                
                tipCurl = (tipCurl1 + tipCurl2)/2
//                print("tipCurl", angle1, angle2, tipCurl)
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
                let pinch = linearInterpolate(lowerBound: config.maximumPinchDistance, upperBound: config.minimumPinchDistance, value: distance)
                
//                print("pinch", distance,pinch)
            } else {
                pinch = nil
            }
            
            if fingerShapeTypes.contains(.spread), finger != .littleFinger {
                let joint1 = joints[finger.jointGroupNames[0]]!
                let joint2 = joints[finger.nextNeighbourFinger!.jointGroupNames[0]]!
                let xAxis1 = joint1.transform.columns.0
                let xAxis2 = joint2.transform.columns.0
                
                let xAxis = normalize(xAxis1 + xAxis2)
                let zAxis = normalize(joint1.transform.columns.2 + joint2.transform.columns.2)
                let yAxis = SIMD4<Float>(cross(zAxis.xyz, xAxis.xyz), 0)
                let p = (joint1.transform.columns.3 + joint2.transform.columns.3)/2
                
                let matrix = simd_float4x4(xAxis, yAxis, zAxis, p)
                let xAxis1R = matrix.inverse * xAxis1
                let xAxis2R = matrix.inverse * xAxis2
                
                let xAxis1H = SIMD3<Float>(xAxis1R.x, 0, xAxis1R.z)
                let xAxis2H = SIMD3<Float>(xAxis2R.x, 0, xAxis2R.z)
                
                let angle1 = atan2(xAxis1H.z, xAxis1H.x) / .pi * 180
                let angle2 = atan2(xAxis2H.z, xAxis2H.x) / .pi * 180
                
                let angle = angle2 - angle2
                let spread = linearInterpolate(lowerBound: config.minimumSpreadDegrees, upperBound: config.maximumSpreadDegrees, value: angle)
                
//                print("spread",angle1, angle2, angle, spread)
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
            return FingerShapeConfiguration(maximumBaseCurlDegrees: 55, maximumTipCurlDegrees1: 55, maximumTipCurlDegrees2: 0, maximumPinchDistance: 0, maximumSpreadDegrees: 40, minimumBaseCurlDegrees: 5, minimumTipCurlDegrees1: -15, minimumTipCurlDegrees2: 0, minimumPinchDistance: 0, minimumSpreadDegrees: 0)
        }
        static var indexFinger: FingerShapeConfiguration {
            return FingerShapeConfiguration(maximumBaseCurlDegrees: 70, maximumTipCurlDegrees1: 100, maximumTipCurlDegrees2: 60, maximumPinchDistance: 0.05, maximumSpreadDegrees: 35, minimumBaseCurlDegrees: -5, minimumTipCurlDegrees1: 0, minimumTipCurlDegrees2: 0, minimumPinchDistance: 0.008, minimumSpreadDegrees: 0)
        }
        static var middleFinger: FingerShapeConfiguration {
            return FingerShapeConfiguration(maximumBaseCurlDegrees: 75, maximumTipCurlDegrees1: 100, maximumTipCurlDegrees2: 70, maximumPinchDistance: 0.05, maximumSpreadDegrees: 25, minimumBaseCurlDegrees: -5, minimumTipCurlDegrees1: 0, minimumTipCurlDegrees2: 0, minimumPinchDistance: 0.008, minimumSpreadDegrees: 0)
        }
        static var ringFinger: FingerShapeConfiguration {
            return FingerShapeConfiguration(maximumBaseCurlDegrees: 80, maximumTipCurlDegrees1: 100, maximumTipCurlDegrees2: 70, maximumPinchDistance: 0.05, maximumSpreadDegrees: 30, minimumBaseCurlDegrees: -5, minimumTipCurlDegrees1: 0, minimumTipCurlDegrees2: 0, minimumPinchDistance: 0.015, minimumSpreadDegrees: 0)
        }
        static var littleFinger: FingerShapeConfiguration {
            return FingerShapeConfiguration(maximumBaseCurlDegrees: 80, maximumTipCurlDegrees1:85, maximumTipCurlDegrees2: 80, maximumPinchDistance: 0.05, maximumSpreadDegrees: 0, minimumBaseCurlDegrees: -5, minimumTipCurlDegrees1: 0, minimumTipCurlDegrees2: 0, minimumPinchDistance: 0.015, minimumSpreadDegrees: 0)
        }
        
    }
}
fileprivate extension HVJointOfFinger {
    fileprivate var fingerShapeConfiguration: HVFingerShape.FingerShapeConfiguration {
        switch self {
        case .thumb:
            return .thumb
        case .indexFinger:
            return .indexFinger
        case .middleFinger:
            return .middleFinger
        case .ringFinger:
            return .ringFinger
        case .littleFinger:
            return .littleFinger
        default:
            return .indexFinger
        }
    }
    
    fileprivate var nextNeighbourFinger: HVJointOfFinger? {
        switch self {
        case .thumb:
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
