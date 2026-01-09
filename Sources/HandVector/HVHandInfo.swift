//
//  HandVectorMatcher.swift
//  FingerDance
//
//  Created by 许同学 on 2024/1/2.
//

import Foundation
import simd
import ARKit

public struct HVHandInfo: Sendable, Equatable {
    public let chirality: HandAnchor.Chirality
    public let allJoints: [HandSkeleton.JointName: HVJointInfo]
    public let transform: simd_float4x4
    
    internal let internalVectors: [simd_float3]
    internal func vectorEndTo(_ named: HandSkeleton.JointName) -> simd_float3 {
        return internalVectors[named.jointIndex]
    }
    
    public static var builtinHandInfo: [String : HVHandInfo] = {
        let dict = HVHandJsonModel.loadHandJsonModelDict(fileName: "BuiltinHand", bundle: handAssetsBundle)!.reduce(into: [String: HVHandInfo](), {
            $0[$1.key] = $1.value.convertToHVHandInfo()
        })
        return dict
    }()
    
    public func calculateFingerShape(finger: HVJointOfFinger, fingerShapeTypes: Set<HVFingerShape.FingerShapeType> = .all) -> HVFingerShape {
        let shape = HVFingerShape(finger: finger, fingerShapeTypes: fingerShapeTypes, joints: allJoints)
        return shape
    }
    
    public init?(chirality: HandAnchor.Chirality, allJoints: [HandSkeleton.JointName: HVJointInfo], transform: simd_float4x4) {
        if allJoints.count >= HandSkeleton.JointName.allCases.count {
            self.chirality = chirality
            self.allJoints = allJoints
            self.transform = transform
            self.internalVectors = Self.genetateVectors(from: allJoints)
        } else {
            return nil
        }
    }
    public init?(handAnchor: HandAnchor) {
        guard let handSkeleton = handAnchor.handSkeleton else  {
            return nil
        }
        self.init(chirality: handAnchor.chirality, handSkeleton: handSkeleton, transform: handAnchor.originFromAnchorTransform)
    }
    public init(chirality: HandAnchor.Chirality, handSkeleton: HandSkeleton, transform: simd_float4x4) {
        self.chirality = chirality
        self.allJoints = Self.genetateJoints(from: handSkeleton)
        self.transform = transform
        self.internalVectors = Self.genetateVectors(from: allJoints)
    }
    
    
    public func reversedChirality() -> HVHandInfo {
        var infoNew: [HandSkeleton.JointName: HVJointInfo] = [:]
        for (name, info) in allJoints {
            infoNew[name] = info.reversedChirality()
        }
        let m = HVHandInfo(chirality: chirality == .left ? .right : .left, allJoints: infoNew, transform: simd_float4x4([-transform.columns.0, transform.columns.1, -transform.columns.2, transform.columns.3]))!
        return m
    }
}

private extension HVHandInfo {
    private static func genetateJoints(from handSkeleton: HandSkeleton) -> [HandSkeleton.JointName: HVJointInfo] {
        var joints: [HandSkeleton.JointName: HVJointInfo] = [:]
        HandSkeleton.JointName.allCases.forEach { jointName in
            joints[jointName] = HVJointInfo(joint: handSkeleton.joint(jointName))
        }
        return joints
    }

    
    /// Optimized vector generation using simd operations
    private static func genetateVectors(from positions: [HandSkeleton.JointName: HVJointInfo]) -> [simd_float3] {
        // Pre-allocate array with known size (27 vectors)
        var vectors = [simd_float3]()
        vectors.reserveCapacity(27)
        
        // Helper function to calculate and normalize vector
        @inline(__always)
        func addVector(from: HVJointInfo, to: HVJointInfo) {
            let position4 = SIMD4(to.positionToParent, 0)
            let vector = (from.transformToParent * position4).xyz
            vectors.append(simd_normalize(vector))
        }
        
        // Cache frequently used joints
        let wrist = positions[.wrist]!
        let forearmArm = positions[.forearmArm]!
        let forearmWrist = positions[.forearmWrist]!
        
        // Forearm and wrist
        addVector(from: forearmArm, to: wrist)
        
        // Thumb
        let thumbKnuckle = positions[.thumbKnuckle]!
        addVector(from: wrist, to: thumbKnuckle)
        addVector(from: thumbKnuckle, to: positions[.thumbIntermediateBase]!)
        addVector(from: positions[.thumbIntermediateBase]!, to: positions[.thumbIntermediateTip]!)
        addVector(from: positions[.thumbIntermediateTip]!, to: positions[.thumbTip]!)
        
        // Index finger
        let indexMetacarpal = positions[.indexFingerMetacarpal]!
        addVector(from: wrist, to: indexMetacarpal)
        addVector(from: indexMetacarpal, to: positions[.indexFingerKnuckle]!)
        addVector(from: positions[.indexFingerKnuckle]!, to: positions[.indexFingerIntermediateBase]!)
        addVector(from: positions[.indexFingerIntermediateBase]!, to: positions[.indexFingerIntermediateTip]!)
        addVector(from: positions[.indexFingerIntermediateTip]!, to: positions[.indexFingerTip]!)
        
        // Middle finger
        let middleMetacarpal = positions[.middleFingerMetacarpal]!
        addVector(from: wrist, to: middleMetacarpal)
        addVector(from: middleMetacarpal, to: positions[.middleFingerKnuckle]!)
        addVector(from: positions[.middleFingerKnuckle]!, to: positions[.middleFingerIntermediateBase]!)
        addVector(from: positions[.middleFingerIntermediateBase]!, to: positions[.middleFingerIntermediateTip]!)
        addVector(from: positions[.middleFingerIntermediateTip]!, to: positions[.middleFingerTip]!)
        
        // Ring finger
        let ringMetacarpal = positions[.ringFingerMetacarpal]!
        addVector(from: wrist, to: ringMetacarpal)
        addVector(from: ringMetacarpal, to: positions[.ringFingerKnuckle]!)
        addVector(from: positions[.ringFingerKnuckle]!, to: positions[.ringFingerIntermediateBase]!)
        addVector(from: positions[.ringFingerIntermediateBase]!, to: positions[.ringFingerIntermediateTip]!)
        addVector(from: positions[.ringFingerIntermediateTip]!, to: positions[.ringFingerTip]!)
        
        // Little finger
        let littleMetacarpal = positions[.littleFingerMetacarpal]!
        addVector(from: wrist, to: littleMetacarpal)
        addVector(from: littleMetacarpal, to: positions[.littleFingerKnuckle]!)
        addVector(from: positions[.littleFingerKnuckle]!, to: positions[.littleFingerIntermediateBase]!)
        addVector(from: positions[.littleFingerIntermediateBase]!, to: positions[.littleFingerIntermediateTip]!)
        addVector(from: positions[.littleFingerIntermediateTip]!, to: positions[.littleFingerTip]!)
        
        // Forearm vectors
        addVector(from: forearmArm, to: forearmWrist)
        addVector(from: forearmWrist, to: forearmArm)
        
        return vectors
    }
}
