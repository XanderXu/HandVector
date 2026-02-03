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
            self.internalVectors = Self.generateVectors(from: allJoints)
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
        self.allJoints = Self.generateJoints(from: handSkeleton)
        self.transform = transform
        self.internalVectors = Self.generateVectors(from: allJoints)
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
    private static func generateJoints(from handSkeleton: HandSkeleton) -> [HandSkeleton.JointName: HVJointInfo] {
        var joints: [HandSkeleton.JointName: HVJointInfo] = [:]
        HandSkeleton.JointName.allCases.forEach { jointName in
            joints[jointName] = HVJointInfo(joint: handSkeleton.joint(jointName))
        }
        return joints
    }

    
    /// Optimized vector generation using simd operations
    private static func generateVectors(from positions: [HandSkeleton.JointName: HVJointInfo]) -> [simd_float3] {
        // Pre-allocate array with known size (27 vectors)
        var vectors = [simd_float3]()
        vectors.reserveCapacity(27)

        // Cache all joints upfront to eliminate repeated dictionary lookups
        let wrist = positions[.wrist]!
        let forearmArm = positions[.forearmArm]!
        let forearmWrist = positions[.forearmWrist]!

        let thumbKnuckle = positions[.thumbKnuckle]!
        let thumbIntermediateBase = positions[.thumbIntermediateBase]!
        let thumbIntermediateTip = positions[.thumbIntermediateTip]!
        let thumbTip = positions[.thumbTip]!

        let indexMetacarpal = positions[.indexFingerMetacarpal]!
        let indexKnuckle = positions[.indexFingerKnuckle]!
        let indexIntermediateBase = positions[.indexFingerIntermediateBase]!
        let indexIntermediateTip = positions[.indexFingerIntermediateTip]!
        let indexTip = positions[.indexFingerTip]!

        let middleMetacarpal = positions[.middleFingerMetacarpal]!
        let middleKnuckle = positions[.middleFingerKnuckle]!
        let middleIntermediateBase = positions[.middleFingerIntermediateBase]!
        let middleIntermediateTip = positions[.middleFingerIntermediateTip]!
        let middleTip = positions[.middleFingerTip]!

        let ringMetacarpal = positions[.ringFingerMetacarpal]!
        let ringKnuckle = positions[.ringFingerKnuckle]!
        let ringIntermediateBase = positions[.ringFingerIntermediateBase]!
        let ringIntermediateTip = positions[.ringFingerIntermediateTip]!
        let ringTip = positions[.ringFingerTip]!

        let littleMetacarpal = positions[.littleFingerMetacarpal]!
        let littleKnuckle = positions[.littleFingerKnuckle]!
        let littleIntermediateBase = positions[.littleFingerIntermediateBase]!
        let littleIntermediateTip = positions[.littleFingerIntermediateTip]!
        let littleTip = positions[.littleFingerTip]!

        // Helper function to calculate and normalize vector
        @inline(__always)
        func addVector(from: HVJointInfo, to: HVJointInfo) {
            let position4 = SIMD4(to.positionToParent, 0)
            let vector = (from.transformToParent * position4).xyz
            vectors.append(simd_normalize(vector))
        }

        // Forearm and wrist
        addVector(from: forearmArm, to: wrist)

        // Thumb
        addVector(from: wrist, to: thumbKnuckle)
        addVector(from: thumbKnuckle, to: thumbIntermediateBase)
        addVector(from: thumbIntermediateBase, to: thumbIntermediateTip)
        addVector(from: thumbIntermediateTip, to: thumbTip)

        // Index finger
        addVector(from: wrist, to: indexMetacarpal)
        addVector(from: indexMetacarpal, to: indexKnuckle)
        addVector(from: indexKnuckle, to: indexIntermediateBase)
        addVector(from: indexIntermediateBase, to: indexIntermediateTip)
        addVector(from: indexIntermediateTip, to: indexTip)

        // Middle finger
        addVector(from: wrist, to: middleMetacarpal)
        addVector(from: middleMetacarpal, to: middleKnuckle)
        addVector(from: middleKnuckle, to: middleIntermediateBase)
        addVector(from: middleIntermediateBase, to: middleIntermediateTip)
        addVector(from: middleIntermediateTip, to: middleTip)

        // Ring finger
        addVector(from: wrist, to: ringMetacarpal)
        addVector(from: ringMetacarpal, to: ringKnuckle)
        addVector(from: ringKnuckle, to: ringIntermediateBase)
        addVector(from: ringIntermediateBase, to: ringIntermediateTip)
        addVector(from: ringIntermediateTip, to: ringTip)

        // Little finger
        addVector(from: wrist, to: littleMetacarpal)
        addVector(from: littleMetacarpal, to: littleKnuckle)
        addVector(from: littleKnuckle, to: littleIntermediateBase)
        addVector(from: littleIntermediateBase, to: littleIntermediateTip)
        addVector(from: littleIntermediateTip, to: littleTip)

        // Forearm vectors
        addVector(from: forearmArm, to: forearmWrist)
        addVector(from: forearmWrist, to: forearmArm)

        return vectors
    }
}
