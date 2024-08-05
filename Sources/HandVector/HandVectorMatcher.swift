//
//  HandVectorMatcher.swift
//  FingerDance
//
//  Created by 许同学 on 2024/1/2.
//

import Foundation
import simd
import ARKit

public struct HandVectorMatcher: Sendable, Equatable {
    public let chirality: HandAnchor.Chirality.NameCodingKey
    public let allJoints: [HandSkeleton.JointName.NameCodingKey: HVJointInfo]
    public let transform: simd_float4x4
    
    internal let internalVectors: [HandSkeleton.JointName.NameCodingKey: InternalVectorInfo]
    internal func vectorEndTo(_ named: HandSkeleton.JointName) -> InternalVectorInfo {
        return internalVectors[named.codableName]!
    }
    
    
    public static func genetatePositions(from handSkeleton: HandSkeleton) -> [HandSkeleton.JointName.NameCodingKey: HVJointInfo] {
        var positions: [HandSkeleton.JointName.NameCodingKey: HVJointInfo] = [:]
        HandSkeleton.JointName.allCases.forEach { jointName in
            positions[jointName.codableName] = HVJointInfo(joint: handSkeleton.joint(jointName))
        }
        return positions
    }
    
    public init?(chirality: HandAnchor.Chirality, allJoints: [HandSkeleton.JointName.NameCodingKey: HVJointInfo], transform: simd_float4x4) {
        if allJoints.count >= HandSkeleton.JointName.allCases.count {
            self.chirality = chirality.codableName
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
        self.chirality = chirality.codableName
        self.allJoints = Self.genetatePositions(from: handSkeleton)
        self.transform = transform
        self.internalVectors = Self.genetateVectors(from: allJoints)
    }
    static func genetateVectors(from positions: [HandSkeleton.JointName.NameCodingKey: HVJointInfo]) -> [HandSkeleton.JointName.NameCodingKey: InternalVectorInfo] {
        var vectors: [HandSkeleton.JointName.NameCodingKey: InternalVectorInfo] = [:]
        
        let wrist = positions[.wrist]!
        let forearmWrist = positions[.forearmWrist]!
        let forearmArm = positions[.forearmArm]!
        vectors[.forearmWrist] = InternalVectorInfo(from: forearmArm, to: forearmWrist)
        vectors[.forearmArm] = InternalVectorInfo(from: forearmWrist, to: forearmArm)
        vectors[.wrist] = InternalVectorInfo(from: forearmArm, to: wrist)
        
        let thumbKnuckle = positions[.thumbKnuckle]!
        let thumbIntermediateBase = positions[.thumbIntermediateBase]!
        let thumbIntermediateTip = positions[.thumbIntermediateTip]!
        let thumbTip = positions[.thumbTip]!
        vectors[.thumbKnuckle] = InternalVectorInfo(from: wrist, to: thumbKnuckle)
        vectors[.thumbIntermediateBase] = InternalVectorInfo(from: thumbKnuckle, to: thumbIntermediateBase)
        vectors[.thumbIntermediateTip] = InternalVectorInfo(from: thumbIntermediateBase, to: thumbIntermediateTip)
        vectors[.thumbTip] = InternalVectorInfo(from: thumbIntermediateTip, to: thumbTip)
        
        let indexFingerMetacarpal = positions[.indexFingerMetacarpal]!
        let indexFingerKnuckle = positions[.indexFingerKnuckle]!
        let indexFingerIntermediateBase = positions[.indexFingerIntermediateBase]!
        let indexFingerIntermediateTip = positions[.indexFingerIntermediateTip]!
        let indexFingerTip = positions[.indexFingerTip]!
        
        vectors[.indexFingerMetacarpal] = InternalVectorInfo(from: wrist, to: indexFingerMetacarpal)
        vectors[.indexFingerKnuckle] = InternalVectorInfo(from: indexFingerMetacarpal, to: indexFingerKnuckle)
        vectors[.indexFingerIntermediateBase] = InternalVectorInfo(from: indexFingerKnuckle, to: indexFingerIntermediateBase)
        vectors[.indexFingerIntermediateTip] = InternalVectorInfo(from: indexFingerIntermediateBase, to: indexFingerIntermediateTip)
        vectors[.indexFingerTip] = InternalVectorInfo(from: indexFingerIntermediateTip, to: indexFingerTip)
                                              
        let middleFingerMetacarpal = positions[.middleFingerMetacarpal]!
        let middleFingerKnuckle = positions[.middleFingerKnuckle]!
        let middleFingerIntermediateBase = positions[.middleFingerIntermediateBase]!
        let middleFingerIntermediateTip = positions[.middleFingerIntermediateTip]!
        let middleFingerTip = positions[.middleFingerTip]!
        
        vectors[.middleFingerMetacarpal] = InternalVectorInfo(from: wrist, to: middleFingerMetacarpal)
        vectors[.middleFingerKnuckle] = InternalVectorInfo(from: middleFingerMetacarpal, to: middleFingerKnuckle)
        vectors[.middleFingerIntermediateBase] = InternalVectorInfo(from: middleFingerKnuckle, to: middleFingerIntermediateBase)
        vectors[.middleFingerIntermediateTip] = InternalVectorInfo(from: middleFingerIntermediateBase, to: middleFingerIntermediateTip)
        vectors[.middleFingerTip] = InternalVectorInfo(from: middleFingerIntermediateTip, to: middleFingerTip)
        
        
        let ringFingerMetacarpal = positions[.ringFingerMetacarpal]!
        let ringFingerKnuckle = positions[.ringFingerKnuckle]!
        let ringFingerIntermediateBase = positions[.ringFingerIntermediateBase]!
        let ringFingerIntermediateTip = positions[.ringFingerIntermediateTip]!
        let ringFingerTip = positions[.ringFingerTip]!
        
        vectors[.ringFingerMetacarpal] = InternalVectorInfo(from: wrist, to: ringFingerMetacarpal)
        vectors[.ringFingerKnuckle] = InternalVectorInfo(from: ringFingerMetacarpal, to: ringFingerKnuckle)
        vectors[.ringFingerIntermediateBase] = InternalVectorInfo(from: ringFingerKnuckle, to: ringFingerIntermediateBase)
        vectors[.ringFingerIntermediateTip] = InternalVectorInfo(from: ringFingerIntermediateBase, to: ringFingerIntermediateTip)
        vectors[.ringFingerTip] = InternalVectorInfo(from: ringFingerIntermediateTip, to: ringFingerTip)
        
        
        let littleFingerMetacarpal = positions[.littleFingerMetacarpal]!
        let littleFingerKnuckle = positions[.littleFingerKnuckle]!
        let littleFingerIntermediateBase = positions[.littleFingerIntermediateBase]!
        let littleFingerIntermediateTip = positions[.littleFingerIntermediateTip]!
        let littleFingerTip = positions[.littleFingerTip]!
        
        vectors[.littleFingerMetacarpal] = InternalVectorInfo(from: wrist, to: littleFingerMetacarpal)
        vectors[.littleFingerKnuckle] = InternalVectorInfo(from: littleFingerMetacarpal, to: littleFingerKnuckle)
        vectors[.littleFingerIntermediateBase] = InternalVectorInfo(from: littleFingerKnuckle, to: littleFingerIntermediateBase)
        vectors[.littleFingerIntermediateTip] = InternalVectorInfo(from: littleFingerIntermediateBase, to: littleFingerIntermediateTip)
        vectors[.littleFingerTip] = InternalVectorInfo(from: littleFingerIntermediateTip, to: littleFingerTip)
        return vectors
    }
    
    public func reversedChirality() -> HandVectorMatcher {
        var infoNew: [HandSkeleton.JointName.NameCodingKey: HVJointInfo] = [:]
        for (name, info) in allJoints {
            infoNew[name] = info.reversedChirality()
        }
        let m = HandVectorMatcher(chirality: chirality == .left ? .right : .left, allJoints: infoNew, transform: simd_float4x4([-transform.columns.0, transform.columns.1, -transform.columns.2, transform.columns.3]))!
        return m
    }
}

public extension HandVectorMatcher {
    /// Fingers and wrist and forearm
    func similarity(to vector: HandVectorMatcher) -> Float {
        return similarity(of: HVJointOfFinger.allFingersAndWristAndForearm, to: vector)
    }
    /// Fingers your selected
    func similarity(of fingers: Set<HVJointOfFinger>, to vector: HandVectorMatcher) -> Float {
        var similarity: Float = 0
        let jointNames = fingers.flatMap { $0.jointNames }
        similarity = jointNames.map { name in
            let dv = dot(vector.vectorEndTo(name).normalizedVector, self.vectorEndTo(name).normalizedVector)
            return dv
        }.reduce(0) { $0 + $1 }
        
        similarity /= Float(jointNames.count)
        return similarity
    }
    
    func similarities(to vector: HandVectorMatcher) -> (average: Float, each: [HVJointOfFinger: Float]) {
        return similarities(of: HVJointOfFinger.allFingersAndWristAndForearm, to: vector)
    }
    func similarities(of fingers: Set<HVJointOfFinger>, to vector: HandVectorMatcher) -> (average: Float, each: [HVJointOfFinger: Float]) {
        let fingerTotal = fingers.reduce(into: [HVJointOfFinger: Float]()) { partialResult, finger in
            let fingerResult = finger.jointNames.reduce(into: Float.zero) { partialResult, name in
                let dv = dot(vector.vectorEndTo(name).normalizedVector, self.vectorEndTo(name).normalizedVector)
                partialResult += dv
            }
            partialResult[finger] = fingerResult
        }
        let fingerScore = fingerTotal.reduce(into: [HVJointOfFinger: Float]()) { partialResult, ele in
            partialResult[ele.key]  = ele.value / Float(ele.key.jointNames.count)
        }
        
        let jointTotal = fingerTotal.reduce(into: Float.zero) { partialResult, element in
            partialResult += element.value
        }
        let jointCount = fingers.flatMap { $0.jointNames }.count
        return (average: jointTotal / Float(jointCount), each: fingerScore)
    }
}

extension HandVectorMatcher {
    struct InternalVectorInfo: Hashable, Sendable, Codable, CustomStringConvertible {
        public let from: HandSkeleton.JointName.NameCodingKey
        public let to: HandSkeleton.JointName.NameCodingKey
        public let vector: simd_float3
        public let normalizedVector: simd_float3
        
        public func reversedChirality() -> InternalVectorInfo {
            return InternalVectorInfo(from: from, to: to, vector: -vector)
        }
        
        public init(from: HVJointInfo, to: HVJointInfo) {
            self.from = from.name
            self.to = to.name
            let position4 = SIMD4(to.position, 0)
            self.vector = (from.transfrom.inverse * position4).xyz
            if vector == .zero {
                self.normalizedVector = .zero
            } else {
                self.normalizedVector = normalize(self.vector)
            }
        }
        private init(from: HandSkeleton.JointName.NameCodingKey, to: HandSkeleton.JointName.NameCodingKey, vector: simd_float3) {
            self.from = from
            self.to = to
            self.vector = vector
            if vector == .zero {
                self.normalizedVector = .zero
            } else {
                self.normalizedVector = normalize(vector)
            }
        }
        
        public var description: String {
            return "from: \(from),\nto: \(to),\nvector: \(vector), normalizedVector:\(normalizedVector)"
        }
    }
}
