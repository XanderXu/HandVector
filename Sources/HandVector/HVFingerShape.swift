//
//  HVFingerShape.swift
//  HandVector
//
//  Created by 许同学 on 2024/8/20.
//

import ARKit

public struct HVFingerShape: Sendable, Equatable {
    struct FingerShapeConfiguration {
        public var maximumBaseCurlDegrees: Float
        public var maximumFullCurlDegrees1: Float
        public var maximumFullCurlDegrees2: Float
        public var maximumFullCurlDegrees3: Float
        public var maximumPinchDistance: Float
        public var maximumSpreadDegrees: Float
        public var maximumTipCurlDegrees1: Float
        public var maximumTipCurlDegrees2: Float
        
        public var minimumBaseCurlDegrees: Float
        public var minimumFullCurlDegrees1: Float
        public var minimumFullCurlDegrees2: Float
        public var minimumFullCurlDegrees3: Float
        public var minimumPinchDistance: Float
        public var minimumSpreadDegrees: Float
        public var minimumTipCurlDegrees1: Float
        public var minimumTipCurlDegrees2: Float
    }

    public struct FingerShapeTypes: OptionSet, Hashable {
        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let baseCurl = FingerShapeTypes(rawValue: 1 << 0)
        public static let tipCurl  = FingerShapeTypes(rawValue: 1 << 1)
        public static let fullCurl = FingerShapeTypes(rawValue: 1 << 2)
        public static let pinch    = FingerShapeTypes(rawValue: 1 << 3)
        public static let spread   = FingerShapeTypes(rawValue: 1 << 4)
        
        public static let all: FingerShapeTypes = [.baseCurl, .tipCurl, .fullCurl, .pinch, .spread]
    }
    let finger: HVJointGroupOptions
    let fingerShapeTypes: FingerShapeTypes
    
    let fullCurl: Float
    let baseCurl: Float
    let tipCurl: Float
    let pinch: Float?
    let spread: Float?
}
