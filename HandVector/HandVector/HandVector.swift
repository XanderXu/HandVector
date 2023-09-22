//
//  HandVector.swift
//  HandVector
//
//  Created by xu on 2023/9/22.
//

#if targetEnvironment(simulator)
import ARKit
#else
@preconcurrency import ARKit
#endif
import Foundation
import simd

enum FingerType: Int, CaseIterable, Codable {
    case wrist = 0
    case thumb
    case index
    case middle
    case ring
    case little
}

struct HandVector: CustomStringConvertible, @unchecked Sendable {
    
    public var chirality: HandAnchor.Chirality
    /// A textual representation of this Skeleton.
    public var description: String// { get }

    /// All joints of this skeleton.
    public var allVectors: [FingerType: [simd_float3]]
    
    public func vector(_ named: HandSkeleton.JointName) -> simd_float3 {
        return .zero
    }
    public func normalizedVector(_ named: HandSkeleton.JointName) -> simd_float3 {
        return normalize(vector(named))
    }
}

func recordJiontVector(_ handSkeleton: HandSkeleton) {
   
    let wrist = handSkeleton.joint(.wrist)
    let wristPosition = wrist.anchorFromJointTransform.columns.3.xyz
    
    let thumb1 = handSkeleton.joint(.thumbKnuckle).anchorFromJointTransform.columns.3.xyz
    let thumb2 = handSkeleton.joint(.thumbIntermediateBase).anchorFromJointTransform.columns.3.xyz
    let thumb3 = handSkeleton.joint(.thumbIntermediateTip).anchorFromJointTransform.columns.3.xyz
    let thumb4 = handSkeleton.joint(.thumbTip).anchorFromJointTransform.columns.3.xyz
    
    let thumbVector0 = normalize(thumb1 - wristPosition)
    let thumbVector1 = normalize(thumb2 - thumb1)
    let thumbVector2 = normalize(thumb3 - thumb2)
    let thumbVector3 = normalize(thumb4 - thumb3)
    let thumbVector4 = normalize(wristPosition - thumb4)
    
    let index1 = handSkeleton.joint(.indexFingerMetacarpal).anchorFromJointTransform.columns.3.xyz
    let index2 = handSkeleton.joint(.indexFingerKnuckle).anchorFromJointTransform.columns.3.xyz
    let index3 = handSkeleton.joint(.indexFingerIntermediateBase).anchorFromJointTransform.columns.3.xyz
    let index4 = handSkeleton.joint(.indexFingerIntermediateTip).anchorFromJointTransform.columns.3.xyz
    let index5 = handSkeleton.joint(.indexFingerTip).anchorFromJointTransform.columns.3.xyz
    
    let indexVector0 = normalize(index1 - wristPosition)
    let indexVector1 = normalize(index2 - index1)
    let indexVector2 = normalize(index3 - index2)
    let indexVector3 = normalize(index4 - index3)
    let indexVector4 = normalize(index5 - index4)
    let indexVector5 = normalize(wristPosition - index5)
    
    let middle1 = handSkeleton.joint(.middleFingerMetacarpal).anchorFromJointTransform.columns.3.xyz
    let middle2 = handSkeleton.joint(.middleFingerKnuckle).anchorFromJointTransform.columns.3.xyz
    let middle3 = handSkeleton.joint(.middleFingerIntermediateBase).anchorFromJointTransform.columns.3.xyz
    let middle4 = handSkeleton.joint(.middleFingerIntermediateTip).anchorFromJointTransform.columns.3.xyz
    let middle5 = handSkeleton.joint(.middleFingerTip).anchorFromJointTransform.columns.3.xyz
    
    let middleVector0 = normalize(middle1 - wristPosition)
    let middleVector1 = normalize(middle2 - middle1)
    let middleVector2 = normalize(middle3 - middle2)
    let middleVector3 = normalize(middle4 - middle3)
    let middleVector4 = normalize(middle5 - middle4)
    let middleVector5 = normalize(wristPosition - middle5)
    
    let ring1 = handSkeleton.joint(.ringFingerMetacarpal).anchorFromJointTransform.columns.3.xyz
    let ring2 = handSkeleton.joint(.ringFingerKnuckle).anchorFromJointTransform.columns.3.xyz
    let ring3 = handSkeleton.joint(.ringFingerIntermediateBase).anchorFromJointTransform.columns.3.xyz
    let ring4 = handSkeleton.joint(.ringFingerIntermediateTip).anchorFromJointTransform.columns.3.xyz
    let ring5 = handSkeleton.joint(.ringFingerTip).anchorFromJointTransform.columns.3.xyz
    
    let ringVector0 = normalize(ring1 - wristPosition)
    let ringVector1 = normalize(ring2 - ring1)
    let ringVector2 = normalize(ring3 - ring2)
    let ringVector3 = normalize(ring4 - ring3)
    let ringVector4 = normalize(ring5 - ring4)
    let ringVector5 = normalize(wristPosition - ring5)
    
    let little1 = handSkeleton.joint(.littleFingerMetacarpal).anchorFromJointTransform.columns.3.xyz
    let little2 = handSkeleton.joint(.littleFingerKnuckle).anchorFromJointTransform.columns.3.xyz
    let little3 = handSkeleton.joint(.littleFingerIntermediateBase).anchorFromJointTransform.columns.3.xyz
    let little4 = handSkeleton.joint(.littleFingerIntermediateTip).anchorFromJointTransform.columns.3.xyz
    let little5 = handSkeleton.joint(.littleFingerTip).anchorFromJointTransform.columns.3.xyz
    
    let littleVector0 = normalize(little1 - wristPosition)
    let littleVector1 = normalize(little2 - little1)
    let littleVector2 = normalize(little3 - little2)
    let littleVector3 = normalize(little4 - little3)
    let littleVector4 = normalize(little5 - little4)
    let littleVector5 = normalize(wristPosition - little5)
}
