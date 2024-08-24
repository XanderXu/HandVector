//
//  File.swift
//  
//
//  Created by 许同学 on 2024/6/5.
//

import ARKit


public struct HVJointInfo: Sendable, Equatable {
    public let name: HandSkeleton.JointName
    public let isTracked: Bool
    // relative to anchor
    public let transform: simd_float4x4
    // relative to parent joint
    public let transformToParent: simd_float4x4
    
    public init(joint: HandSkeleton.Joint) {
        self.name = joint.name
        self.isTracked = joint.isTracked
        self.transform = joint.anchorFromJointTransform
        self.transformToParent = joint.parentFromJointTransform
    }
    
    public init(name: HandSkeleton.JointName, isTracked: Bool, anchorFromJointTransform: simd_float4x4, parentFromJointTransform: simd_float4x4) {
        self.name = name
        self.isTracked = isTracked
        self.transform = anchorFromJointTransform
        self.transformToParent = parentFromJointTransform
    }
    
    public func reversedChirality() -> HVJointInfo {
        return HVJointInfo(name: name, isTracked: isTracked, anchorFromJointTransform: transform.positionReversed, parentFromJointTransform: transformToParent.positionReversed)
    }

    public var position: SIMD3<Float> {
        return transform.columns.3.xyz
    }

    public var description: String {
        return "name: \(name), isTracked: \(isTracked), position: \(transform.columns.0.xyz)"
    }
    
}
