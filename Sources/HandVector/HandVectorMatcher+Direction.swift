//
//  File.swift
//  
//
//  Created by 许同学 on 2024/6/5.
//

import ARKit

public extension HandVectorMatcher {
    //world space direction
    public var fingersExtendedDirection: simd_float3 {
        return chirality == .left ? transform.columns.0.xyz : -transform.columns.0.xyz
    }
    public var thumbExtendedDirection: simd_float3 {
        return chirality == .left ? -transform.columns.2.xyz : transform.columns.2.xyz
    }
    public var palmDirection: simd_float3 {
        return chirality == .left ? transform.columns.1.xyz : -transform.columns.1.xyz
    }
    
    //in world space
    //direction: from knukle to tip of a finger
    public func fingerPositionDirection(of finger: HVJointOfFinger) -> (position: SIMD3<Float>, direction: SIMD3<Float>) {
        let tip = finger.jointNames.last!
        let tipLocal = allJoints[tip.codableName]?.position ?? .zero
        let tipWorld = transform * SIMD4(tipLocal, 1)
        
        let back = chirality == .left ? SIMD3<Float>(1, 0, 0) : SIMD3<Float>(-1, 0, 0)
        let knukle = finger.jointNames.first!
        let knukleLocal = allJoints[knukle.codableName]?.position ?? back
        let knukleWorld = transform * SIMD4(knukleLocal, 1)
        
        return (position: tipWorld.xyz, direction: simd_normalize(tipWorld.xyz - knukleWorld.xyz))
    }
    
}
